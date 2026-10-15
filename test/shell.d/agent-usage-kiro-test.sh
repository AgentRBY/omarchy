#!/bin/bash

source "$(dirname "$0")/base-test.sh"

require_command jq
require_command python3

COLLECTOR="$ROOT/bin/omarchy-agent-usage-kiro"
TMP_ROOT=$(mktemp -d)
trap 'rm -rf "$TMP_ROOT"' EXIT

unset XDG_CACHE_HOME

today=$(date +%Y-%m-%d)
now_iso=$(date -u +%Y-%m-%dT%H:%M:%SZ)
two_days_ago=$(date -d '2 days ago' +%Y-%m-%d)
two_days_ago_iso=$(date -u -d '2 days ago' +%Y-%m-%dT%H:%M:%SZ)

new_home() {
  local home="$TMP_ROOT/$1"
  mkdir -p "$home/.kiro/sessions/cli"
  printf '%s\n' "$home"
}

collect() {
  local home="$1"
  shift
  HOME="$home" XDG_CACHE_HOME="$home/.cache" "$COLLECTOR" "$@"
}

# write_session <home> <id> <turns json>
write_session() {
  cat >"$1/.kiro/sessions/cli/$2.json" <<EOF
{"session_id":"$2","created_at":"$now_iso","session_state":{"rts_model_state":{"model_info":{"model_id":"claude-sonnet-4.5"}},"conversation_metadata":{"user_turn_metadatas":$3}}}
EOF
}

# ---------------------------------------------------------------- unused

home=$(new_home empty)
record=$(collect "$home" --force)
[[ $(jq -c '{schemaVersion, id, name, ready, hasPromptStats, tierLabel, usageStatusText, authHelpText, limits, limitsStale, limitsFetchedAt, balance: has("balance"), todayPrompts, todaySessions, todayTotalTokens, todayTokensByModel, totalPrompts, totalSessions, activeDays, activeDates, modelUsage, days: (.recentDays | length)}' <<<"$record") == '{"schemaVersion":1,"id":"kiro","name":"Kiro","ready":false,"hasPromptStats":true,"tierLabel":"","usageStatusText":"","authHelpText":"","limits":[],"limitsStale":false,"limitsFetchedAt":0,"balance":false,"todayPrompts":0,"todaySessions":0,"todayTotalTokens":0,"todayTokensByModel":{},"totalPrompts":0,"totalSessions":0,"activeDays":0,"activeDates":[],"modelUsage":{},"days":7}' ]] ||
  fail "Kiro collector prints a full empty record the panel skips on an unused machine" "$record"
pass "Kiro collector prints a full empty record the panel skips on an unused machine"

# ---------------------------------------------------------------- turns

home=$(new_home turns)
write_session "$home" s1 "[
  {\"model\":\"claude-opus-4.6\",\"end_timestamp\":\"$now_iso\",\"total_request_count\":3,\"input_token_count\":1200,\"output_token_count\":300,\"cache_read_input_token_count\":800,\"cache_write_input_token_count\":40,\"metering_usage\":[{\"value\":0.4,\"unit\":\"credit\"}]},
  {\"model\":\"auto\",\"end_timestamp\":\"$now_iso\",\"total_request_count\":2,\"input_token_count\":0,\"output_token_count\":0,\"metering_usage\":[{\"value\":0.1,\"unit\":\"credit\"}]},
  {\"end_timestamp\":\"$two_days_ago_iso\",\"total_request_count\":1,\"input_token_count\":50,\"output_token_count\":5},
  {\"end_timestamp\":\"$now_iso\",\"total_request_count\":0}
]"
write_session "$home" s2 "[{\"end_timestamp\":\"$two_days_ago_iso\",\"total_request_count\":1}]"

record=$(collect "$home" --force)
[[ $(jq -c '{ready, todayPrompts, todaySessions, todayTotalTokens, totalPrompts, totalSessions, activeDays}' <<<"$record") == '{"ready":true,"todayPrompts":2,"todaySessions":1,"todayTotalTokens":2340,"totalPrompts":4,"totalSessions":2,"activeDays":2}' ]] ||
  fail "Kiro collector counts each user turn as a prompt and each file as a session" "$record"
pass "Kiro collector counts each user turn as a prompt and each file as a session"

[[ $(jq -c '.modelUsage' <<<"$record") == '{"claude-opus-4.6":{"inputTokens":1200,"outputTokens":300,"cacheReadInputTokens":800,"cacheCreationInputTokens":40},"claude-sonnet-4.5":{"inputTokens":50,"outputTokens":5,"cacheReadInputTokens":0,"cacheCreationInputTokens":0}}' ]] ||
  fail "Kiro collector reports Kiro's own token counts by model and estimates none" "$record"
pass "Kiro collector reports Kiro's own token counts by model and estimates none"

[[ $(jq -r --arg day "$two_days_ago" '.recentDays[] | select(.date == $day) | .messageCount' <<<"$record") == "55" ]] ||
  fail "Kiro collector books a turn on the day it ended" "$record"
pass "Kiro collector books a turn on the day it ended"

[[ $(jq -c '[has("todayTotalCredits"), has("todayCreditsByModel"), has("totalCredits")]' <<<"$record") == '[false,false,false]' ]] ||
  fail "Kiro collector keeps to the record contract's fields" "$record"
pass "Kiro collector keeps to the record contract's fields"

# ---------------------------------------------------------------- untrusted fields

home=$(new_home untrusted)
write_session "$home" odd "[
  {\"end_timestamp\":\"later\",\"total_request_count\":1,\"input_token_count\":10},
  {\"end_timestamp\":\"2999-01-01T00:00:00Z\",\"total_request_count\":1,\"input_token_count\":10},
  {\"end_timestamp\":\"$now_iso\",\"total_request_count\":true,\"input_token_count\":\"9\",\"output_token_count\":-4,\"cache_read_input_token_count\":NaN,\"cache_write_input_token_count\":1e30},
  {\"end_timestamp\":$(date +%s)000,\"total_request_count\":1,\"output_token_count\":7}
]"
printf '{"session_state":' >"$home/.kiro/sessions/cli/torn.json"
record=$(collect "$home" --force 2>/dev/null)
# An unreadable or future end time falls back to the session's creation time;
# a turn whose every count is bad never ran.
[[ $(jq -c '{todayPrompts, todayTotalTokens}' <<<"$record") == '{"todayPrompts":3,"todayTotalTokens":27}' ]] ||
  fail "Kiro collector skips bad times and bad token fields without losing the record" "$record"
pass "Kiro collector skips bad times and bad token fields without losing the record"

[[ -z $(find "$home/.cache/omarchy/agent-usage" -name 'kiro-scan-*.json' 2>/dev/null) ]] ||
  fail "Kiro collector does not cache a scan that could not read every session"
pass "Kiro collector does not cache a scan that could not read every session"

# ---------------------------------------------------------------- scan cache

home=$(new_home cache)
write_session "$home" s1 "[{\"end_timestamp\":\"$now_iso\",\"total_request_count\":1,\"input_token_count\":10}]"
collect "$home" >/dev/null
write_session "$home" s2 "[{\"end_timestamp\":\"$now_iso\",\"total_request_count\":1,\"input_token_count\":5}]"
[[ $(collect "$home" | jq -r '.todayTotalTokens') == "10" ]] ||
  fail "Kiro collector reuses a scan from the last few seconds"
[[ $(collect "$home" --limits-only | jq -r '.todayTotalTokens') == "10" ]] ||
  fail "Kiro collector reuses a recent scan for --limits-only"
[[ $(collect "$home" --force | jq -r '.todayTotalTokens') == "15" ]] ||
  fail "Kiro collector rescans with --force"
pass "Kiro collector reuses a recent scan and rescans with --force"

cache_file=$(find "$home/.cache/omarchy/agent-usage" -name 'kiro-scan-*.json' -print -quit)
[[ $(jq -r '.scanDate' "$cache_file") == "$today" ]] ||
  fail "Kiro collector stamps its scan cache with the day it was made" "$(cat "$cache_file")"
jq '.scanDate = "2000-01-01" | .stats.todayTotalTokens = 1' "$cache_file" >"$cache_file.new" && mv "$cache_file.new" "$cache_file"
[[ $(collect "$home" | jq -r '.todayTotalTokens') == "15" ]] ||
  fail "Kiro collector ignores a scan cache from another day"
pass "Kiro collector ignores a scan cache from another day"

# The cache stamped in the future is distrusted rather than kept forever.
jq '.stats.todayTotalTokens = 1' "$cache_file" >"$cache_file.new" && mv "$cache_file.new" "$cache_file"
touch -d '+1 hour' "$cache_file"
[[ $(collect "$home" | jq -r '.todayTotalTokens') == "15" ]] ||
  fail "Kiro collector distrusts a scan cache dated in the future"
pass "Kiro collector distrusts a scan cache dated in the future"

# Kiro rewrites a session file whole each turn; the index rereads it.
write_session "$home" s1 "[{\"end_timestamp\":\"$now_iso\",\"total_request_count\":1,\"input_token_count\":10},{\"end_timestamp\":\"$now_iso\",\"total_request_count\":1,\"input_token_count\":20}]"
[[ $(collect "$home" --force | jq -r '"\(.todayPrompts):\(.todayTotalTokens)"') == "3:35" ]] ||
  fail "Kiro collector rereads a session file that changed"
pass "Kiro collector rereads a session file that changed"
