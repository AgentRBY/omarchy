#!/bin/bash

source "$(dirname "$0")/base-test.sh"

require_command jq
require_command python3
require_command rg

TEST_HOME=$(mktemp -d)
SERVER_PID=""
cleanup() {
  [[ -n $SERVER_PID ]] && kill "$SERVER_PID" 2>/dev/null
  rm -rf "$TEST_HOME"
}
trap cleanup EXIT

export HOME="$TEST_HOME"
export XDG_CACHE_HOME="$TEST_HOME/cache"
export XDG_DATA_HOME="$TEST_HOME/data"
export XDG_CONFIG_HOME="$TEST_HOME/config"
unset LITELLM_BASE_URL LITELLM_API_KEY LITELLM_MASTER_KEY PI_CODING_AGENT_DIR OPENCODE_DB

collector="$ROOT/bin/omarchy-agent-usage-litellm"
STATE="$TEST_HOME/server"
mkdir -p "$STATE"
BUDGET_CACHE="$XDG_CACHE_HOME/omarchy/agent-usage"

# A stand-in proxy: /key/info answers with $STATE/body and the status in
# $STATE/status, or redirects to $STATE/redirect when that is set. Every
# request and its key is noted, so a refused redirect can prove the key
# never left.
python3 - "$STATE" <<'PY' &
import http.server, pathlib, sys
state = pathlib.Path(sys.argv[1])

class Handler(http.server.BaseHTTPRequestHandler):
  def do_GET(self):
    with (state / "log").open("a") as log:
      log.write(f"{self.headers.get('Host')} {self.path} {self.headers.get('Authorization', '')}\n")
    redirect = state / "redirect"
    if redirect.exists():
      self.send_response(302)
      self.send_header("Location", redirect.read_text().strip())
      self.end_headers()
      return
    status = int((state / "status").read_text()) if (state / "status").exists() else 200
    self.send_response(status)
    self.send_header("Content-Type", "application/json")
    self.end_headers()
    self.wfile.write((state / "body").read_bytes() if (state / "body").exists() else b"{}")

  def log_message(self, *args):
    pass

server = http.server.HTTPServer(("127.0.0.1", 0), Handler)
(state / "port").write_text(str(server.server_address[1]))
server.serve_forever()
PY
SERVER_PID=$!
for _ in $(seq 50); do
  [[ -s $STATE/port ]] && break
  sleep 0.1
done
[[ -s $STATE/port ]] || fail "LiteLLM test server starts"
PORT=$(cat "$STATE/port")
PROXY="http://127.0.0.1:$PORT"

requests() {
  [[ -f $STATE/log ]] && wc -l <"$STATE/log" || echo 0
}

serve() {
  printf '%s' "$1" >"$STATE/status"
  printf '%s' "${2-}" >"$STATE/body"
}

serve 200 '{"key": "sk-hash", "info": {"key_alias": "laptop", "spend": 12.5, "max_budget": 50, "budget_reset_at": null}}'

# ------------------------------------------------------------ unused machine

result=$("$collector")
[[ $(jq -c '[.ready, .limits, has("balance"), .usageStatusText, .authHelpText, .tierLabel, .todayTotalTokens, (.recentDays | length), has("retryAdvised")]' <<<"$result") == '[false,[],false,"","","",0,7,false]' ]] ||
  fail "LiteLLM collector prints an empty, not-ready record on an unused machine" "$result"
[[ $(requests) == "0" ]] ||
  fail "LiteLLM collector asks nothing without a key" "$(requests)"
pass "LiteLLM collector prints an empty, not-ready record on an unused machine"

# ----------------------------------------------------------------- budget

mkdir -p "$XDG_CONFIG_HOME/omarchy/agents"
printf '{"baseUrl": "%s/v1/", "apiKey": "config-key"}\n' "$PROXY" >"$XDG_CONFIG_HOME/omarchy/agents/litellm.json"
result=$("$collector")
[[ $(jq -c '[.ready, (.balance == {"currency":"USD","estimated":false,"funded":50,"remaining":37.5,"spent":12.5}), .limitsStale, .usageStatusText, .authHelpText, .tierLabel, .hasPromptStats // true, has("scope")]' <<<"$result") == '[true,true,false,"","","",true,false]' ]] ||
  fail "LiteLLM collector reads the key's budget as a balance" "$result"
[[ $(tail -n 1 "$STATE/log") == "127.0.0.1:$PORT /key/info Bearer config-key" ]] ||
  fail "LiteLLM collector asks /key/info with the configured key" "$(cat "$STATE/log")"
pass "LiteLLM collector reads the key's budget from /key/info"

[[ $(LITELLM_BASE_URL="$PROXY" LITELLM_API_KEY=env-key "$collector" --force >/dev/null && tail -n 1 "$STATE/log") == *"Bearer env-key" ]] ||
  fail "LiteLLM collector prefers the environment's key" "$(cat "$STATE/log")"
pass "LiteLLM collector prefers the environment's key"

# A key without a budget spends without limit: no balance, nothing wrong.
serve 200 '{"info": {"spend": 3, "max_budget": null}}'
result=$("$collector" --force)
[[ $(jq -c '[.ready, has("balance"), .usageStatusText]' <<<"$result") == '[true,false,""]' ]] ||
  fail "LiteLLM collector shows no balance for a key without a budget" "$result"
pass "LiteLLM collector shows no balance for a key without a budget"

# ------------------------------------------------------------- probe reuse

serve 200 '{"info": {"spend": 10, "max_budget": 40}}'
"$collector" --force >/dev/null
before=$(requests)
result=$("$collector")
[[ $(requests) == "$before" && $(jq -r '.balance.remaining == 30' <<<"$result") == "true" ]] ||
  fail "LiteLLM collector reuses a check from seconds ago" "$result"
"$collector" --force >/dev/null
[[ $(requests) == "$((before + 1))" ]] ||
  fail "LiteLLM collector --force checks again" "$(requests)"
pass "LiteLLM collector reuses a recent check and --force checks again"

# --------------------------------------------------------------- failures

cache_file=$(ls "$BUDGET_CACHE"/litellm-limits-*.json | head -n 1)
for file in "$BUDGET_CACHE"/litellm-limits-*.json; do
  jq -c --argjson t "$((($(date +%s) - 3600) * 1000))" '.fetchedAtMs = $t' "$file" >"$file.tmp" && mv "$file.tmp" "$file"
done

serve 500
result=$("$collector")
[[ $(jq -c '[(.balance.remaining == 30), .limitsStale, .usageStatusText, has("retryAdvised"), .limitsFetchedAt > 0]' <<<"$result") == '[true,true,"",false,true]' ]] ||
  fail "LiteLLM collector keeps the last budget stale after a failed check" "$result"
pass "LiteLLM collector keeps the last budget stale after a failed check"

printf '{"baseUrl": "http://127.0.0.1:1", "apiKey": "config-key"}\n' >"$XDG_CONFIG_HOME/omarchy/agents/litellm.json"
result=$("$collector")
[[ $(jq -c '[.retryAdvised, .usageStatusText, has("balance")]' <<<"$result") == '[true,"Balance unavailable",false]' ]] ||
  fail "LiteLLM collector advises a retry when the proxy is unreachable" "$result"
pass "LiteLLM collector advises a retry only when the proxy is unreachable"
printf '{"baseUrl": "%s", "apiKey": "config-key"}\n' "$PROXY" >"$XDG_CONFIG_HOME/omarchy/agents/litellm.json"

serve 401
result=$("$collector")
[[ $(jq -c '[.usageStatusText, .limitsStale, (.balance.remaining == 30)]' <<<"$result") == '["Sign-in expired",true,true]' ]] ||
  fail "LiteLLM collector says a refused key needs replacing" "$result"
pass "LiteLLM collector says a refused key needs replacing"

rm -f "$BUDGET_CACHE"/litellm-limits-*.json
serve 500
result=$("$collector")
[[ $(jq -c '[.usageStatusText, has("balance"), .limitsFetchedAt]' <<<"$result") == '["Balance unavailable",false,0]' ]] ||
  fail "LiteLLM collector says the balance is unavailable with nothing kept" "$result"
[[ $(jq -r '.authHelpText' <<<"$result") == *"status 500"* ]] ||
  fail "LiteLLM collector says what failed" "$result"
pass "LiteLLM collector says the balance is unavailable with nothing kept"

# A redirect to another host must not carry the key along.
serve 200 '{"info": {"spend": 1, "max_budget": 2}}'
printf 'http://localhost:%s/key/info' "$PORT" >"$STATE/redirect"
result=$("$collector" --force)
rm "$STATE/redirect"
[[ $(jq -r '.authHelpText' <<<"$result") == *"redirected off the configured host"* ]] ||
  fail "LiteLLM collector refuses a redirect to another host" "$result"
! grep -q "^localhost" "$STATE/log" ||
  fail "LiteLLM collector never sends the key to another host" "$(cat "$STATE/log")"
pass "LiteLLM collector refuses a redirect to another host"

# A base URL carrying credentials is refused before any request.
printf '{"baseUrl": "http://user:pass@127.0.0.1:%s", "apiKey": "config-key"}\n' "$PORT" >"$XDG_CONFIG_HOME/omarchy/agents/litellm.json"
before=$(requests)
result=$("$collector" --force)
[[ $(requests) == "$before" && $(jq -r '.usageStatusText' <<<"$result") == "Balance unavailable" ]] ||
  fail "LiteLLM collector refuses a base URL with credentials in it" "$result"
pass "LiteLLM collector refuses a base URL with credentials in it"
rm "$XDG_CONFIG_HOME/omarchy/agents/litellm.json"

# ------------------------------------------------------------- local stats

today=$(date +%Y-%m-%d)
sessions="$TEST_HOME/.pi/agent/sessions/--work--"
mkdir -p "$sessions" "$XDG_DATA_HOME/opencode"
line() {
  printf '{"type":"message","id":"%s","timestamp":"%sT12:00:00.000Z","message":{"role":"assistant","provider":"%s","model":"anthropic/claude-sonnet-4","usage":{"input":%s,"output":10,"cacheRead":5,"cacheWrite":0}}}\n' "$1" "$today" "$2" "$3"
}
{ line a litellm 100; line b anthropic 999; line c litellm false; } >"$sessions/one.jsonl"
printf '*\n' >"$TEST_HOME/.gitignore"
git -C "$TEST_HOME" init -q

python3 - "$XDG_DATA_HOME/opencode/opencode.db" <<'PY'
import json, sqlite3, sys, time
conn = sqlite3.connect(sys.argv[1]); now = int(time.time() * 1000)
conn.execute("CREATE TABLE message (id TEXT PRIMARY KEY, session_id TEXT, time_created INTEGER, time_updated INTEGER, data TEXT)")
def row(mid, provider, inp):
  return (mid, "s1", now, now, json.dumps({"role": "assistant", "providerID": provider, "modelID": "gpt-5", "tokens": {"input": inp, "output": 1, "reasoning": 1, "cache": {"read": 0, "write": 0}}, "time": {"created": now}}))
conn.executemany("INSERT INTO message VALUES (?, ?, ?, ?, ?)", [row("m1", "litellm", 20), row("m2", "openai", 999), row("m3", "litellm-proxy", 999)])
conn.execute("INSERT INTO message VALUES ('m4', 's1', 0, 0, 'not json \"providerID\": \"litellm\"')")
conn.commit(); conn.close()
PY

result=$("$collector" --force)
# pi: a 115 and c 15 (its boolean input reads as nothing); opencode m1 22.
# Other providers, a lookalike id and a broken row add nothing.
[[ $(jq -c '[.ready, .todayTotalTokens, .todayPrompts, .todaySessions, (.modelUsage | keys), .usageStatusText]' <<<"$result") == '[true,152,3,2,["claude-sonnet-4","gpt-5"],"Waiting for auth"]' ]] ||
  fail "LiteLLM collector counts pi and opencode usage on the litellm provider" "$result"
pass "LiteLLM collector counts pi and opencode usage on the litellm provider, waiting for auth without a key"

# A scan from seconds ago is reused; --force reads again.
line d litellm 1000 >>"$sessions/one.jsonl"
[[ $(jq -r '.todayTotalTokens' <<<"$("$collector")") == "152" && $(jq -r '.todayTotalTokens' <<<"$("$collector" --force)") == "1167" ]] ||
  fail "LiteLLM collector reuses a recent scan and --force rescans" "$("$collector")"
pass "LiteLLM collector reuses a recent scan and --force rescans"
