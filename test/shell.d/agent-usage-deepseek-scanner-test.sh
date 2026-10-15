#!/bin/bash

source "$(dirname "$0")/base-test.sh"

require_command jq
require_command python3

# A key in the environment would send the collector to DeepSeek.
unset DEEPSEEK_API_KEY DEEPSEEK_API_BASE_URL PI_CODING_AGENT_DIR

timestamp="$(date +%Y-%m-%d)T12:00:00Z"
now_ms="$(date +%s)000"

HOMES=()
trap 'rm -rf "${HOMES[@]}"' EXIT

new_home() {
  local home
  home=$(mktemp -d)
  HOMES+=("$home")
  printf '%s\n' "$home"
}

# The collector run as it is installed, with every store under one home.
collect() {
  local home="$1"
  shift
  HOME="$home" XDG_CACHE_HOME="$home/.cache" XDG_DATA_HOME="$home/.local/share" XDG_CONFIG_HOME="$home/.config" \
    "$ROOT/bin/omarchy-agent-usage-deepseek" "$@" 2>/dev/null
}

# ---------------------------------------------------------------- pi and omp

PI_HOME=$(new_home)
mkdir -p "$PI_HOME/.pi/agent/sessions/project" "$PI_HOME/.omp/agent/sessions/project"

cat >"$PI_HOME/.pi/agent/sessions/project/pi.jsonl" <<EOF
{"type":"message","id":"pi-1","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-pi","usage":{"input":10,"output":4,"cacheRead":3,"cacheWrite":2,"totalTokens":19}}}
{"type":"message","id":"pi-2","timestamp":"$timestamp","message":{"role":"assistant","provider":"anthropic","model":"claude-test","usage":{"input":999,"output":999}}}
{"type":"message","id":"pi-3","timestamp":"$timestamp","message":{"role":"assistant","provider":"openai-codex","model":"gpt-test","usage":{"input":999,"output":999}}}
EOF
cat >"$PI_HOME/.omp/agent/sessions/project/omp.jsonl" <<EOF
{ "type": "message", "id": "omp-1", "timestamp": "$timestamp", "message": { "role": "assistant", "provider": "deepseek", "model": "deepseek-omp", "usage": { "input": 20, "output": 5, "cacheRead": 4, "cacheWrite": 1, "totalTokens": 30 } } }
EOF

result=$(collect "$PI_HOME")

[[ $(jq -r '.todayTotalTokens' <<<"$result") == "49" ]] ||
  fail "DeepSeek collector counts usage from pi and omp sessions" "$result"
pass "DeepSeek collector counts usage from pi and omp sessions"

[[ $(jq -c '.modelUsage' <<<"$result") == '{"deepseek-pi":{"inputTokens":10,"outputTokens":4,"cacheReadInputTokens":3,"cacheCreationInputTokens":2},"deepseek-omp":{"inputTokens":20,"outputTokens":5,"cacheReadInputTokens":4,"cacheCreationInputTokens":1}}' ]] ||
  fail "DeepSeek collector filters pi and omp sessions to DeepSeek providers" "$result"
pass "DeepSeek collector filters pi and omp sessions to DeepSeek providers"

[[ $(jq -r '"\(.todayPrompts):\(.todaySessions)"' <<<"$result") == "2:2" ]] ||
  fail "DeepSeek collector counts each message once per session" "$result"
pass "DeepSeek collector counts each message once per session"

# Local usage alone puts DeepSeek in use; without a key there is no plan and
# no balance section.
[[ $(jq -c '{id, ready, tierLabel, hasPromptStats, balance: has("balance"), usageStatusText, authHelpText}' <<<"$result") == '{"id":"deepseek","ready":true,"tierLabel":"","hasPromptStats":true,"balance":false,"usageStatusText":"","authHelpText":""}' ]] ||
  fail "DeepSeek collector prints a valid record without a key" "$result"
pass "DeepSeek collector prints a valid record without a key"

# Nothing used and no key: a record the panel skips, with the full empty
# stats block.
EMPTY_HOME=$(new_home)
result=$(collect "$EMPTY_HOME")
[[ $(jq -c '{ready, tierLabel, limits, limitsStale, limitsFetchedAt, usageStatusText, authHelpText, totalPrompts, activeDays, activeDates, modelUsage, recentDays: (.recentDays | length), balance: has("balance")}' <<<"$result") == '{"ready":false,"tierLabel":"","limits":[],"limitsStale":false,"limitsFetchedAt":0,"usageStatusText":"","authHelpText":"","totalPrompts":0,"activeDays":0,"activeDates":[],"modelUsage":{},"recentDays":7,"balance":false}' ]] ||
  fail "DeepSeek collector prints a record the panel skips without DeepSeek" "$result"
pass "DeepSeek collector prints a record the panel skips without DeepSeek"

# Profiles keep their own session trees, PI_CODING_AGENT_DIR moves pi's, and
# a home that is a git checkout ignoring everything still gets scanned. A
# fork's copy of its parent's message counts once, a line without an id
# always counts, a usage block with only a total still counts, and either
# spelling of the token fields reads.
ROOTS_HOME=$(new_home)
mkdir -p "$ROOTS_HOME/.git" "$ROOTS_HOME/.pi/agent/sessions/p" "$ROOTS_HOME/.omp/profiles/work/agent/sessions/p" "$ROOTS_HOME/moved/sessions/p"
printf '*\n' >"$ROOTS_HOME/.gitignore"
cat >"$ROOTS_HOME/.pi/agent/sessions/p/parent.jsonl" <<EOF
{"type":"message","id":"m-1","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":1}}}
{"type":"message","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":2}}}
{"type":"message","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":2}}}
EOF
cat >"$ROOTS_HOME/.pi/agent/sessions/p/fork.jsonl" <<EOF
{"type":"message","id":"m-1","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":1}}}
EOF
cat >"$ROOTS_HOME/.omp/profiles/work/agent/sessions/p/omp.jsonl" <<EOF
{"type":"message","id":"w-1","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"totalTokens":40}}}
{"type":"message","id":"w-2","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"inputTokens":100,"output_tokens":200,"cache_read_input_tokens":300,"cacheWriteTokens":400}}}
EOF
cat >"$ROOTS_HOME/moved/sessions/p/pi.jsonl" <<EOF
{"type":"message","id":"d-1","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":5000}}}
EOF
result=$(PI_CODING_AGENT_DIR="$ROOTS_HOME/moved" collect "$ROOTS_HOME")
[[ $(jq -c '{todayTotalTokens, totalPrompts, usage: .modelUsage["deepseek-v4"]}' <<<"$result") == '{"todayTotalTokens":6045,"totalPrompts":6,"usage":{"inputTokens":5145,"outputTokens":200,"cacheReadInputTokens":300,"cacheCreationInputTokens":400}}' ]] ||
  fail "DeepSeek collector reads every pi and omp session root once per message" "$result"
pass "DeepSeek collector reads every pi and omp session root once per message"

# A timestamp or token count that can't be trusted costs its row or field,
# never the scan.
BAD_HOME=$(new_home)
mkdir -p "$BAD_HOME/.pi/agent/sessions/p"
cat >"$BAD_HOME/.pi/agent/sessions/p/pi.jsonl" <<EOF
{"type":"message","id":"b-1","timestamp":true,"message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":1000}}}
{"type":"message","id":"b-2","timestamp":-5,"message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":1000}}}
{"type":"message","id":"b-3","timestamp":1e300,"message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":1000}}}
{"type":"message","id":"b-4","timestamp":"yesterday-ish","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":1000}}}
{"type":"message","id":"b-5","timestamp":NaN,"message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":1000}}}
{"type":"message","id":"b-6","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":7,"output":true,"cacheRead":-50,"cacheWrite":1e300}}}
{"type":"message","id":"b-7","timestamp":$now_ms,"message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":3}}}
EOF
result=$(collect "$BAD_HOME")
[[ $(jq -c '{todayTotalTokens, totalPrompts}' <<<"$result") == '{"todayTotalTokens":10,"totalPrompts":2}' ]] ||
  fail "DeepSeek collector skips untrusted timestamps and token counts" "$result"
pass "DeepSeek collector skips untrusted timestamps and token counts"

# ---------------------------------------------------------------- opencode

OPENCODE_HOME=$(new_home)

python3 - "$OPENCODE_HOME/.local/share/opencode/opencode.db" <<'PY'
import json
import sqlite3
import sys
import time
from pathlib import Path

db = Path(sys.argv[1])
db.parent.mkdir(parents=True, exist_ok=True)
conn = sqlite3.connect(db)
conn.execute("CREATE TABLE message (id text PRIMARY KEY, session_id text NOT NULL, time_created integer NOT NULL, time_updated integer NOT NULL, data text NOT NULL)")
now_ms = int(time.time() * 1000)

def message(id, provider, model, input=0, output=0, reasoning=0, read=0, write=0):
  return (id, "ses_1", now_ms, now_ms, json.dumps({
    "role": "assistant",
    "providerID": provider,
    "modelID": model,
    "tokens": {"input": input, "output": output, "reasoning": reasoning, "cache": {"read": read, "write": write}},
    "time": {"created": now_ms},
  }))

conn.executemany(
  "INSERT INTO message VALUES (?, ?, ?, ?, ?)",
  [
    message("m-1", "deepseek", "deepseek-model", input=100, output=20, reasoning=5, read=30, write=2),
    message("m-2", "openai", "gpt-model", input=999, output=999),
    message("m-3", "anthropic", "claude-model", input=999, output=999),
  ],
)
conn.commit()
conn.close()
PY

result=$(collect "$OPENCODE_HOME")

[[ $(jq -r '.todayTotalTokens' <<<"$result") == "157" ]] ||
  fail "DeepSeek collector counts opencode messages on a DeepSeek provider" "$result"
pass "DeepSeek collector counts opencode messages on a DeepSeek provider"

[[ $(jq -c '.modelUsage["deepseek-model"]' <<<"$result") == '{"inputTokens":100,"outputTokens":25,"cacheReadInputTokens":30,"cacheCreationInputTokens":2}' ]] ||
  fail "DeepSeek collector keeps reasoning with output and cache apart in opencode" "$result"
pass "DeepSeek collector keeps reasoning with output and cache apart in opencode"

# A day active in both pi and opencode is still one active day.
mkdir -p "$OPENCODE_HOME/.pi/agent/sessions/project"
cp "$PI_HOME/.pi/agent/sessions/project/pi.jsonl" "$OPENCODE_HOME/.pi/agent/sessions/project/"
result=$(collect "$OPENCODE_HOME" --force)

[[ $(jq -r '"\(.todayTotalTokens):\(.totalSessions):\(.activeDays)"' <<<"$result") == "176:2:1" ]] ||
  fail "DeepSeek collector counts a day shared by pi and opencode once" "$result"
pass "DeepSeek collector counts a day shared by pi and opencode once"

# --------------------------------------------------------------- scan cache

# A normal run reuses a scan for a few seconds, --limits-only for longer,
# and --force rescans.
CACHE_HOME=$(new_home)
mkdir -p "$CACHE_HOME/.pi/agent/sessions/p"
cat >"$CACHE_HOME/.pi/agent/sessions/p/pi.jsonl" <<EOF
{"type":"message","id":"c-1","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":7,"output":3}}}
EOF
result=$(collect "$CACHE_HOME")
[[ $(jq -r '.todayTotalTokens' <<<"$result") == "10" ]] ||
  fail "DeepSeek collector scans without a cache" "$result"
[[ -n $(find "$CACHE_HOME/.cache/omarchy/agent-usage" -name 'deepseek-scan-*.json' -print -quit) ]] ||
  fail "DeepSeek collector writes a scan cache"

cat >>"$CACHE_HOME/.pi/agent/sessions/p/pi.jsonl" <<EOF
{"type":"message","id":"c-2","timestamp":"$timestamp","message":{"role":"assistant","provider":"deepseek","model":"deepseek-v4","usage":{"input":90}}}
EOF
result=$(collect "$CACHE_HOME")
[[ $(jq -r '.todayTotalTokens' <<<"$result") == "10" ]] ||
  fail "DeepSeek collector reuses a recent scan" "$result"
result=$(collect "$CACHE_HOME" --limits-only)
[[ $(jq -c '{todayTotalTokens, totalPrompts}' <<<"$result") == '{"todayTotalTokens":10,"totalPrompts":1}' ]] ||
  fail "DeepSeek collector --limits-only emits a complete record from cache" "$result"
result=$(collect "$CACHE_HOME" --force)
[[ $(jq -r '.todayTotalTokens' <<<"$result") == "100" ]] ||
  fail "DeepSeek collector --force rescans" "$result"
pass "DeepSeek collector caches and reuses local stats"

# Without rg the sessions can't be read, and a scan missing them is never
# cached as the whole story.
rm -rf "$CACHE_HOME/.cache"
HOME="$CACHE_HOME" XDG_CACHE_HOME="$CACHE_HOME/.cache" XDG_DATA_HOME="$CACHE_HOME/.local/share" \
  PATH="$CACHE_HOME/no-bin" "$ROOT/bin/omarchy-agent-usage-deepseek" >/dev/null 2>&1
[[ -z $(find "$CACHE_HOME/.cache" -name 'deepseek-scan-*.json' 2>/dev/null) ]] ||
  fail "DeepSeek collector doesn't cache a scan that couldn't read the sessions"
pass "DeepSeek collector doesn't cache a scan that couldn't read the sessions"
