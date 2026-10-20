#!/bin/bash

# The Ollama Cloud collector's own parts: the ollama-cloud filter over pi and
# omp sessions with model tags merged, the configured model prefix, Ollama's
# usage and plan answers, and its key. Roots, forks, cloud-tagged models
# through the local daemon, both opencode stores, OPENCODE_DB and untrusted
# values are held by the shared and partition tests, as is the
# unused-machine record; the limits and scan caches go through the contract
# checks.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"
source "$SHELL_TEST_DIR/agent-usage-helpers.sh"

agent_sandbox

python3 - <<'PY'
from agent_usage_fixtures import *

# The checks below compare today's totals with rows stamped now.
freeze_today()
USAGE = "ollama.com/api/usage"
ME = "ollama.com/api/me"
ROUTES = {
  USAGE: {
    "activity": {"cost": "0.00"},
    "limits": {
      "session": {"usage": 0.434, "models": [{"name": "deepseek-v4-pro:0813", "request_count": 340}]},
      "weekly": {"usage": 0.298, "models": [{"name": "kimi-k3", "request_count": 377}]},
    },
  },
  ME: {"Plan": "pro"},
}


def ollama(*args, routes=None, mode="up"):
  with FakeHttp(ROUTES if routes is None else routes, mode=mode) as http:
    record = collect("ollama", *(args or ("--force",)))
  ollama.requests = http.count
  return record


def sessions():
  return home() / ".pi" / "agent" / "sessions"


def prefix(value):
  if value is None:
    (config_home() / "omarchy" / "agents" / "ollama.json").unlink()
  else:
    write_json(config_home() / "omarchy" / "agents" / "ollama.json", {"modelPrefix": value})


# ------------------------------------------------------------ local stats

# pi and omp sessions on the ollama-cloud provider are the local stats; other
# providers and prompts in the same files stay out, and model version tags
# merge.
sandbox()
write_pi_session(sessions() / "project" / "pi.jsonl", [
  pi_reply("ollama-cloud", id="pi-1", model="deepseek-v4-pro:0813", usage={"input": 10, "output": 4, "cacheRead": 3, "cacheWrite": 2, "totalTokens": 19}),
  pi_reply("ollama-cloud", id="pi-2", model="deepseek-v4-pro:0731", usage={"input": 5, "output": 1, "cacheRead": 0, "cacheWrite": 0, "totalTokens": 6}),
  pi_reply("anthropic", id="pi-3", model="claude-test", usage={"input": 999, "output": 999}),
  {"type": "message", "id": "pi-4", "timestamp": iso_in(0), "message": {"role": "user", "provider": "ollama-cloud", "model": "deepseek-v4-pro:0813", "usage": {"input": 999, "output": 999}}},
  pi_reply("ollama-cloud", id="pi-5", model="deepseek-v4-pro:0813", usage={"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0, "totalTokens": 0}),
])
write_pi_session(home() / ".omp" / "agent" / "sessions" / "project" / "omp.jsonl", [
  pi_reply("ollama-cloud", id="omp-1", model="kimi-k3", usage={"input": 20, "output": 5, "cacheRead": 4, "cacheWrite": 1, "totalTokens": 30}),
])
record = ollama()
expect("Ollama counts ollama-cloud usage from pi and omp, merging model tags", [record["name"], record["todayTotalTokens"], record["modelUsage"]], ["Ollama Cloud", 55, {
  "deepseek-v4-pro": {"inputTokens": 15, "outputTokens": 5, "cacheReadInputTokens": 3, "cacheCreationInputTokens": 2},
  "kimi-k3": {"inputTokens": 20, "outputTokens": 5, "cacheReadInputTokens": 4, "cacheCreationInputTokens": 1},
}], record)

# In use here, but no key to ask for the account's limits.
expect("Ollama in use without a key waits for auth", [record["ready"], record["usageStatusText"], record["limitsStale"], ollama.requests],
       [True, "Waiting for auth", False, 0], record)

# A configured model prefix restricts the local stats to matching models, and
# a scan only answers for the filter it applied: the same filter reuses it,
# another scans again.
prefix("kimi")
expect("Ollama honors the configured model prefix", list(ollama()["modelUsage"]), ["kimi-k3"])
expect("Ollama reuses a scan made with the same model prefix", list(ollama("--limits-only")["modelUsage"]), ["kimi-k3"])
prefix(None)
expect("Ollama scans again when the model prefix changes", sorted(ollama("--limits-only")["modelUsage"]), ["deepseek-v4-pro", "kimi-k3"])

# ---------------------------------------------------------------- contract

sandbox()


def add_reply():
  add_reply.count = getattr(add_reply, "count", 0) + 1
  write_pi_session(sessions() / "grown" / f"{add_reply.count}.jsonl", [pi_reply("ollama-cloud", 5, id=f"grown-{add_reply.count}")])


# A probe asks for the usage and then the plan. Ollama's usage answer names no
# reset times, so no kept window can elapse; the contract's check that kept
# limits come back as they were measured covers how they are kept.
adapter = Adapter("ollama", plant=lambda: os.environ.update(OLLAMA_API_KEY="key"), answer=ROUTES, requests_per_probe=2,
                  skip=("elapsed",), grow=add_reply, pi_root=sessions)
fresh = check_limits_contract(adapter)
expect("Ollama's plan and its session and weekly fractions come from its answers, with no reset times made up", {
  "tierLabel": fresh["tierLabel"], "limits": fresh["limits"],
}, {
  "tierLabel": "Pro", "limits": [
    {"label": "Session (5-hour)", "percent": 0.434, "resetsAt": ""},
    {"label": "Weekly (7-day)", "percent": 0.298, "resetsAt": ""},
  ],
}, fresh)
check_scan_cache(adapter)

# ---------------------------------------------------------------- the key

# A rejected key is a sign-in to redo, and says so.
record = ollama(mode=401)
check("Ollama explains a rejected key", "rejected" in record["authHelpText"], record)

# A plan lookup that fails keeps the plan last named.
record = ollama(routes={**ROUTES, ME: urllib.error.URLError(OSError("plan lookup timed out"))})
expect("Ollama keeps the cached plan when the plan lookup fails", [record["tierLabel"], record["limitsStale"]], ["Pro", False], record)

# An answer never rolls back one another run stamped while this one waited
# on the network.
def later_run(request):
  edit_limits_cache("ollama", fetched_ago=-60)
  return ROUTES[USAGE]


ollama(routes={**ROUTES, USAGE: later_run})
expect("Ollama never overwrites a newer cached answer with its own",
       [json.loads(path.read_text())["fetchedAtMs"] > ms_in(30) for path in limits_cache_files("ollama")], [True])
edit_limits_cache("ollama", fetched_ago=0)

# Another key never shows this one's numbers or plan.
os.environ["OLLAMA_API_KEY"] = "other-key"
record = ollama(mode="down")
expect("Ollama keeps each key's limits and plan apart", [record["limits"], record["tierLabel"], record["usageStatusText"]],
       [[], "", "Ollama limits unavailable"], record)

# ---------------------------------------------------------- the answer

# With nothing kept, a failed check says the limits are unavailable; only an
# unreachable endpoint asks for an early retry.
sandbox()
os.environ["OLLAMA_API_KEY"] = "key"
record = ollama(mode="down")
expect("Ollama offline with nothing kept says its limits are unavailable and advises a retry",
       [record["usageStatusText"], record.get("retryAdvised")], ["Ollama limits unavailable", True], record)
record = ollama(mode=500)
expect("Ollama advises no retry for a server's error status", [record["usageStatusText"], record.get("retryAdvised")],
       ["Ollama limits unavailable", None], record)

# An answer with no usable windows explains itself instead of printing none.
record = ollama(routes={USAGE: {"limits": {"session": {"usage": "unknown"}, "weekly": None}}, ME: {"Plan": "pro"}})
expect("Ollama reports an answer without usable limits", [record["limits"], record["usageStatusText"], "no limits" in record["authHelpText"]],
       [[], "Ollama limits unavailable", True], record)
PY
