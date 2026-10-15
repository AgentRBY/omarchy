#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

require_command python3

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT

export HOME="$test_tmp/home"
export XDG_STATE_HOME="$test_tmp/state"
export XDG_CACHE_HOME="$test_tmp/cache"

collector="$ROOT/bin/omarchy-agent-usage-freebuff"
projects="$HOME/.config/manicode/projects/testproj/chats"

# Freebuff stores each chat as a directory named for its UTC start time,
# holding a chat-messages.json array. Message ids carry the epoch
# milliseconds of their creation; user messages are plain strings and AI
# replies keep text in typed blocks.
make_chat() {
  local dir="$1"
  mkdir -p "$dir"
  cat >"$dir/chat-messages.json"
}

today=$(python3 -c 'import datetime as dt; print(dt.datetime.now().strftime("%Y-%m-%d"))')
yesterday=$(python3 -c 'import datetime as dt; print((dt.datetime.now() - dt.timedelta(days=1)).strftime("%Y-%m-%d"))')
now_ms=$(python3 -c 'import time; print(int(time.time() * 1000))')
yesterday_ms=$(python3 -c 'import time; print(int((time.time() - 86400) * 1000))')

# One chat from yesterday, one from today: two prompts and two replies total.
make_chat "$projects/2026-09-30T10-00-00.000Z" <<EOF
[
  {"id": "user-$yesterday_ms", "variant": "user", "timestamp": "10:00 AM", "content": "fix the login bug"},
  {"id": "ai-$((yesterday_ms + 2000))-abc", "variant": "ai", "timestamp": "10:00 AM", "content": "", "blocks": [{"type": "text", "content": "On it. Reading the auth module now."}]},
  {"id": "user-$((yesterday_ms + 4000))", "variant": "user", "timestamp": "10:01 AM", "content": "thanks, ship it"}
]
EOF
make_chat "$projects/2026-10-01T15-30-00.000Z" <<EOF
[
  {"id": "user-$now_ms", "variant": "user", "timestamp": "03:30 PM", "content": "add a usage collector"},
  {"id": "ai-$((now_ms + 2000))-def", "variant": "ai", "timestamp": "03:31 PM", "content": "", "blocks": [{"type": "text", "content": "Done — the collector prints the panel record."}]}
]
EOF

record=$("$collector" --force)

# The record is one line of JSON with the schema the panel reads.
[[ $(printf '%s' "$record" | jq -e '.schemaVersion' ) == 1 ]] || fail "schemaVersion"
pass "record carries schemaVersion 1"

[[ $(printf '%s' "$record" | jq -r '.id') == "freebuff" ]] || fail "id"
[[ $(printf '%s' "$record" | jq -r '.name') == "Freebuff" ]] || fail "name"
pass "record identifies as freebuff / Freebuff"

[[ $(printf '%s' "$record" | jq '.totalPrompts') == 3 ]] || fail "totalPrompts"
[[ $(printf '%s' "$record" | jq '.totalSessions') == 2 ]] || fail "totalSessions"
[[ $(printf '%s' "$record" | jq '.activeDays') == 2 ]] || fail "activeDays"
pass "prompts, sessions, and active days counted across chats"

[[ $(printf '%s' "$record" | jq '.todayPrompts') == 1 ]] || fail "todayPrompts"
[[ $(printf '%s' "$record" | jq '.todaySessions') == 1 ]] || fail "todaySessions"
pass "today's numbers cover only today's chat"

# The chat files record no token usage, and the record invents none.
[[ $(printf '%s' "$record" | jq -c '{todayTotalTokens, todayTokensByModel, modelUsage, chart: ([.recentDays[].messageCount] | add), days: (.recentDays | length)}') == '{"todayTotalTokens":0,"todayTokensByModel":{},"modelUsage":{},"chart":0,"days":7}' ]] ||
  fail "token fields stay at zero" "$record"
pass "token fields stay at zero rather than estimated from text"

# Local chats alone make Freebuff in use, signed in or not, and a missing
# sign-in is nothing to fix: Freebuff has no limits to read.
[[ $(printf '%s' "$record" | jq -c '{ready, tierLabel, usageStatusText, authHelpText, limits}') == '{"ready":true,"tierLabel":"","usageStatusText":"","authHelpText":"","limits":[]}' ]] ||
  fail "local usage makes the record ready" "$record"
pass "local chats make the record ready without a sign-in"

# The sign-in checks run on an empty config home, where only the sign-in
# decides readiness.
signin_home="$test_tmp/signin"
credentials="$signin_home/credentials.json"
mkdir -p "$signin_home"

record=$(FREEBUFF_CONFIG_DIR="$signin_home" "$collector" --force)
[[ $(printf '%s' "$record" | jq -c '{ready, tierLabel, usageStatusText, authHelpText, limits, balance: has("balance"), totalPrompts, totalSessions, activeDays, activeDates}') == '{"ready":false,"tierLabel":"","usageStatusText":"","authHelpText":"","limits":[],"balance":false,"totalPrompts":0,"totalSessions":0,"activeDays":0,"activeDates":[]}' ]] ||
  fail "unused machine prints a record the panel skips" "$record"
pass "an unused machine prints a full empty record the panel skips"

for invalid in '{}' '{"default":{}}' '{"default":{"authToken":""}}' 'not-json'; do
  printf '%s' "$invalid" >"$credentials"
  record=$(FREEBUFF_CONFIG_DIR="$signin_home" "$collector" --force)
  [[ $(printf '%s' "$record" | jq '.ready') == "false" ]] || fail "invalid credentials not ready: $invalid"
done
pass "empty, unusable, and malformed credentials are not signed in"

printf '{"default":{"authToken":"test-token"}}' >"$credentials"
record=$(FREEBUFF_CONFIG_DIR="$signin_home" "$collector" --force)
[[ $(printf '%s' "$record" | jq -c '{ready, tierLabel, usageStatusText}') == '{"ready":true,"tierLabel":"","usageStatusText":""}' ]] ||
  fail "token credentials are a sign-in" "$record"
pass "token credentials make the record ready without naming a plan"

# Freebuff moves the token to the keychain and leaves the profile behind.
printf '{"default":{"name":"a","tokenStore":"keychain"}}' >"$credentials"
record=$(FREEBUFF_CONFIG_DIR="$signin_home" "$collector" --force)
[[ $(printf '%s' "$record" | jq -c '{ready, usageStatusText, authHelpText}') == '{"ready":true,"usageStatusText":"","authHelpText":""}' ]] ||
  fail "a keychain sign-in is a sign-in" "$record"
pass "a keychain-backed sign-in makes the record ready"

# Untrusted message ids: a time far in the future or nonsense falls back to
# the file's last write, and a prompt without text is no prompt.
odd_home="$test_tmp/odd"
make_chat "$odd_home/projects/p/chats/c1" <<EOF
[
  {"id": "user-9999999999999", "variant": "user", "content": "future"},
  {"id": "user-abc", "variant": "user", "content": "no time"},
  {"id": "user-$now_ms", "variant": "user", "content": "   "},
  {"id": "user-$now_ms", "variant": "user", "content": ["not", "text"]},
  "junk"
]
EOF
record=$(FREEBUFF_CONFIG_DIR="$odd_home" "$collector" --force)
[[ $(printf '%s' "$record" | jq -c '{todayPrompts, totalPrompts, activeDates}') == "{\"todayPrompts\":2,\"totalPrompts\":2,\"activeDates\":[\"$today\"]}" ]] ||
  fail "untrusted ids fall back to the file's day" "$record"
pass "untrusted message ids and empty prompts don't skew the counts"

# A chat caught mid-write (invalid JSON) must not take the scan down or be
# counted as a complete prompt until it can be read successfully.
mkdir -p "$projects/2026-10-01T16-00-00.000Z"
printf '[{"id": "user-%s", "variant": "user", "content": "half written' "$now_ms" \
  >"$projects/2026-10-01T16-00-00.000Z/chat-messages.json"
# --force: the collector dedups concurrent runs through a recent-scan cache,
# so a normal rerun inside the test would legitimately reuse the scan above.
record=$("$collector" --force)
[[ $(printf '%s' "$record" | jq '.totalPrompts') == 3 ]] || fail "partial prompt omitted"
[[ $(printf '%s' "$record" | jq '.totalSessions') == 2 ]] || fail "partial session omitted"
pass "incomplete chat is omitted from displayed usage"

cat >"$projects/2026-10-01T16-00-00.000Z/chat-messages.json" <<EOF
[{"id":"user-$now_ms","variant":"user","content":"repaired prompt"}]
EOF
record=$("$collector" --limits-only)
[[ $(printf '%s' "$record" | jq '.totalPrompts') == 4 ]] || fail "repaired prompt not rescanned"
[[ $(printf '%s' "$record" | jq '.totalSessions') == 3 ]] || fail "repaired session not rescanned"
pass "incomplete scan does not poison cache after chat repair"

# A normal run reuses a scan from the last few seconds and --limits-only one
# from the last quarter hour; --force always rescans.
make_chat "$projects/2026-10-01T17-00-00.000Z" <<EOF
[{"id":"user-$now_ms","variant":"user","content":"one more"}]
EOF
[[ $("$collector" | jq '.totalPrompts') == 4 ]] || fail "normal run reuses a recent scan"
[[ $("$collector" --limits-only | jq '.totalPrompts') == 4 ]] || fail "--limits-only reuses a recent scan"
[[ $("$collector" --force | jq '.totalPrompts') == 5 ]] || fail "--force rescans"
pass "recent scans are reused and --force rescans"

cache_file=$(find "$XDG_CACHE_HOME/omarchy/agent-usage" -name 'freebuff-scan-*.json' -print -quit)
[[ $(jq -r '.scanDate' "$cache_file") == "$today" ]] || fail "cache carries its scan date"
jq '.scanDate = "2000-01-01"' "$cache_file" >"$cache_file.new" && mv "$cache_file.new" "$cache_file"
make_chat "$projects/2026-10-01T18-00-00.000Z" <<EOF
[{"id":"user-$now_ms","variant":"user","content":"after midnight"}]
EOF
[[ $("$collector" | jq '.totalPrompts') == 6 ]] || fail "a cache from another day is rescanned"
pass "a scan cache from another day is not reused"

# A cache written before the token estimate was dropped is not reused.
jq '.schemaVersion = 1' "$cache_file" >"$cache_file.new" && mv "$cache_file.new" "$cache_file"
make_chat "$projects/2026-10-01T19-00-00.000Z" <<EOF
[{"id":"user-$now_ms","variant":"user","content":"newer schema"}]
EOF
[[ $("$collector" --limits-only | jq '.totalPrompts') == 7 ]] || fail "an old cache schema is rescanned"
pass "a cache from an older schema is rescanned"

# The update wrapper writes the record where the panel reads it. It scans for
# collectors under OMARCHY_PATH, which the running shell points at the
# installed tree, so the test points it at this checkout the same way.
export PATH="$ROOT/bin:$PATH"
export OMARCHY_PATH="$ROOT"
"$ROOT/bin/omarchy-agent-usage-update" freebuff
[[ -f "$XDG_STATE_HOME/omarchy/agents/usage/freebuff.json" ]] || fail "wrapper record"
jq -e '.id == "freebuff"' "$XDG_STATE_HOME/omarchy/agents/usage/freebuff.json" >/dev/null || fail "wrapper json"
pass "usage-update writes the panel's freebuff.json"

# And the stock agents still collect through the same wrapper.
"$ROOT/bin/omarchy-agent-usage-update" codex
[[ -f "$XDG_STATE_HOME/omarchy/agents/usage/codex.json" ]] || fail "codex via wrapper"
pass "usage-update still serves the stock collectors"
