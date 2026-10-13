#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

require_command jq
require_command python3

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT

export HOME="$test_tmp/home"
export XDG_STATE_HOME="$test_tmp/state"
export XDG_CACHE_HOME="$test_tmp/cache"
export XDG_DATA_HOME="$test_tmp/data"
unset CODEX_HOME

mkdir -p "$HOME/.codex/sessions" "$test_tmp/bin"
printf '{"tokens":{"account_id":"acct-one"}}\n' >"$HOME/.codex/auth.json"

# A stand-in app-server whose rate-limit answer CODEX_FAKE picks: limits, a
# backend error, a sign-out, or dying with or without saying why.
cat >"$test_tmp/bin/codex" <<'PY'
#!/usr/bin/python3
import json, os, sys, time
mode = os.environ.get("CODEX_FAKE", "ok")
now = int(time.time())
for line in sys.stdin:
  message = json.loads(line)
  if "id" not in message:
    continue
  if message["method"] == "account/rateLimits/read":
    if mode == "died":
      print("error sending request for url (https://chatgpt.com/backend-api/wham/usage)", file=sys.stderr)
      sys.exit(1)
    if mode == "silent":
      sys.exit(0)
    if mode == "backend":
      print(json.dumps({"id": message["id"], "error": {"code": -32603, "message": "failed to fetch codex rate limits"}}), flush=True)
      continue
    if mode == "auth":
      print(json.dumps({"id": message["id"], "error": {"code": -32603, "message": "not authenticated"}}), flush=True)
      continue
    print(json.dumps({"id": message["id"], "result": {"rateLimits": {"planType": "pro",
      "primary": {"usedPercent": 40, "windowDurationMins": 300, "resetsAt": now + 3600},
      "secondary": {"usedPercent": 70, "windowDurationMins": 10080, "resetsAt": now + 2}}}}), flush=True)
    continue
  print(json.dumps({"id": message["id"], "result": {}}), flush=True)
PY
chmod +x "$test_tmp/bin/codex"

collect() {
  CODEX_FAKE="$1" PATH="$test_tmp/bin:$PATH" "$ROOT/bin/omarchy-agent-usage-codex" --force
}

fresh=$(collect ok)
[[ $(jq -c '{limitsStale, fresh: (.limitsFetchedAt > 0), used: [.limits[].percent], tierLabel}' <<<"$fresh") == '{"limitsStale":false,"fresh":true,"used":[0.4,0.7],"tierLabel":"pro"}' ]] ||
  fail "fresh Codex limits are live and say when they were measured" "$fresh"
pass "fresh Codex limits are live and say when they were measured"
fetched_at=$(jq '.limitsFetchedAt' <<<"$fresh")

# Let the weekly window reset before the next probe fails.
sleep 3

for mode in backend died; do
  kept=$(collect "$mode")
  [[ $(jq -c --argjson at "$fetched_at" '{limitsStale, at: (.limitsFetchedAt == $at), used: [.limits[].percent * 100 | round], status: .usageStatusText, tierLabel}' <<<"$kept") == '{"limitsStale":true,"at":true,"used":[40,0],"status":"","tierLabel":"pro"}' ]] ||
    fail "a failed Codex probe ($mode) keeps the last limits, marked stale" "$kept"
  pass "a failed Codex probe ($mode) keeps the last limits, marked stale"
done

for mode in auth silent; do
  dropped=$(collect "$mode")
  [[ $(jq -c '{limitsStale, limits}' <<<"$dropped") == '{"limitsStale":true,"limits":[]}' && $(jq -r '.usageStatusText' <<<"$dropped") != "" ]] ||
    fail "a Codex sign-out ($mode) is reported, not hidden behind old limits" "$dropped"
  pass "a Codex sign-out ($mode) is reported, not hidden behind old limits"
done

printf '{"tokens":{"account_id":"acct-two"}}\n' >"$HOME/.codex/auth.json"
other=$(collect backend)
[[ $(jq -c '{limits, status: .usageStatusText}' <<<"$other") == '{"limits":[],"status":"Codex limits unavailable"}' ]] ||
  fail "a home signed in to another account never shows the last one's limits" "$other"
pass "a home signed in to another account never shows the last one's limits"
