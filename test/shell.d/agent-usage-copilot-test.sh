#!/bin/bash

# The Copilot collector's own sources: the CLI's session store and, for CLIs
# that predate its usage table, the session transcripts; the monthlyCredits
# budget behind the local estimate; and GitHub's quota answer, asked as gh's
# account or an exported token. The unused-machine record is held centrally
# by the partition test, and the limits and scan caches by the contract
# checks.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"
source "$SHELL_TEST_DIR/agent-usage-helpers.sh"

agent_sandbox

# Fixtures are stamped in UTC and checked against the local day and the UTC
# allowance month; pinning the zone keeps both on the same date at any hour.
export TZ=UTC

# Every run re-derives "today" and the allowance month from the clock and
# compares them with stamps taken at the start. Starting too close to UTC
# midnight (under TZ=UTC also the month boundary) lets them diverge mid-run,
# so wait for the new day instead.
seconds_to_midnight=$(( 86400 - $(date -u +%s) % 86400 ))
if (( seconds_to_midnight < 120 )); then
  sleep "$seconds_to_midnight"
fi

python3 - <<'PY'
from agent_usage_fixtures import *
import hashlib

NOW = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
YESTERDAY = (datetime.now(timezone.utc) - timedelta(days=1)).strftime("%Y-%m-%dT%H:%M:%SZ")
TODAY = datetime.now().astimezone().date().isoformat()
RESET = (datetime.now(timezone.utc) + timedelta(days=10)).replace(microsecond=0)
QUOTA_URL = "api.github.com/copilot_internal/user"
EVENT_COLUMNS = "session_id, created_at, model, total_nano_aiu, input_tokens, output_tokens, cache_read_tokens, cache_write_tokens, reasoning_tokens"


def quota(plan, entitlement, used, **snapshot):
  return {
    "copilot_plan": plan,
    "quota_reset_date_utc": RESET.strftime("%Y-%m-%dT%H:%M:%S.000Z"),
    "quota_snapshots": {"premium_interactions": {"unlimited": False, "entitlement": entitlement, "credits_used": used, **snapshot}},
  }


def configured(**config):
  write_json(config_home() / "omarchy" / "agents" / "copilot.json", config)


def copilot_home():
  return home() / ".copilot"


# The session store carries one row per billed assistant request. As in the
# real CLI, input_tokens is the whole prompt (cache reads and writes included)
# and output_tokens already includes reasoning_tokens.
def store(rows):
  path = copilot_home() / "session-store.db"
  path.parent.mkdir(parents=True, exist_ok=True)
  conn = sqlite3.connect(path)
  conn.execute("CREATE TABLE IF NOT EXISTS assistant_usage_events (id INTEGER PRIMARY KEY AUTOINCREMENT, session_id TEXT, created_at TEXT, model TEXT, total_nano_aiu INTEGER, input_tokens INTEGER, output_tokens INTEGER, cache_read_tokens INTEGER, cache_write_tokens INTEGER, reasoning_tokens INTEGER, duration_ms INTEGER)")
  conn.executemany(f"INSERT INTO assistant_usage_events ({EVENT_COLUMNS}) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", rows)
  conn.commit()
  conn.close()


def transcript(session, events):
  path = copilot_home() / "session-state" / session / "events.jsonl"
  path.parent.mkdir(parents=True, exist_ok=True)
  path.write_text("".join(json.dumps({"type": kind, "data": data, "id": "x", "timestamp": at}) + "\n" for kind, data, at in events))


def copilot(*args, routes=None, mode="up", force=True):
  with FakeHttp(routes or {}, mode=mode) as http:
    record = collect("copilot", *(args or (("--force",) if force else ())))
  copilot.asked = [request["headers"].get("authorization") for request in http.requests]
  return record


def meter(record):
  return {"limits": [[limit["label"], limit["percent"], limit["resetsAt"] != ""] for limit in record["limits"]], "stale": record["limitsStale"],
          "status": record["usageStatusText"], "retry": record.get("retryAdvised", False), "tier": record["tierLabel"]}


# ------------------------------------------------------------- the store

sandbox()
configured(monthlyCredits=1500, remote=False)
store([
  ("sess-a", NOW, "claude-sonnet-4-5", 500_000_000, 1600, 300, 400, 0, 50),
  ("sess-a", NOW, "claude-sonnet-4-5", 500_000_000, 900, 200, 100, 0, 0),
  ("sess-b", NOW, "gpt-5.2", 500_000_000, 1900, 700, 100, 300, 100),
])
record = copilot()
expect("the store's billed requests are counted, kept out of the prompt totals, by session and token",
       {key: record[key] for key in ("ready", "todayPrompts", "hasPromptStats", "todaySessions", "todayTotalTokens")} | {"day": record["recentDays"][-1]["date"]},
       {"ready": True, "todayPrompts": 3, "hasPromptStats": False, "todaySessions": 2, "todayTotalTokens": 5600, "day": TODAY}, record)
expect("reasoning stays inside output, and cached tokens split off the prompt", record["modelUsage"], {
  "claude-sonnet-4-5": {"inputTokens": 2000, "outputTokens": 500, "cacheReadInputTokens": 500, "cacheCreationInputTokens": 0},
  "gpt-5.2": {"inputTokens": 1500, "outputTokens": 700, "cacheReadInputTokens": 100, "cacheCreationInputTokens": 300},
}, record)
expect("a monthlyCredits budget gives a labeled local estimate of the month's credits",
       [record["limits"][0]["label"], record["limits"][0]["percent"], bool(record["limits"][0]["resetsAt"])], ["Monthly allowance (est.)", 0.001, True], record)

# Without the live quota or a budget there is no plan and no meter, while the
# local stats still show.
configured(remote=False)
record = copilot()
expect("no meter without the quota or a budget", [record["ready"], record["tierLabel"], record["limits"]], [True, "", []], record)
configured(monthlyCredits=3000, remote=False)
record = copilot()
expect("the estimate follows the monthlyCredits budget", [record["tierLabel"], record["limits"][0]["percent"]], ["", 0.0005], record)

# Lifetime totals cover the whole store, however many rows it holds.
sandbox()
configured(remote=False)
old = (datetime.now(timezone.utc) - timedelta(days=100)).strftime("%Y-%m-%dT%H:%M:%SZ")
store([(f"old-{n % 7}", old, "gpt-5.2", 0, 10, 1, 0, 0, 0) for n in range(25_000)] + [("new", NOW, "gpt-5.2", 0, 10, 1, 0, 0, 0)])
record = copilot()
expect("lifetime totals come from the full store", [record["totalPrompts"], record["totalSessions"], record["activeDays"]], [25001, 8, 2], record)

# ------------------------------------------------------- the transcripts

# Without a usage table the transcripts stand in. Shutdown metrics are
# cumulative across resumes and already include cached and reasoning tokens;
# replies after the last shutdown count on their output tokens alone.
def metrics(input, output, read, write, nano):
  return {"claude-sonnet-4.6": {"requests": {"count": 1, "cost": 1}, "totalNanoAiu": nano,
                                "usage": {"inputTokens": input, "outputTokens": output, "cacheReadTokens": read, "cacheWriteTokens": write, "reasoningTokens": 20}}}


sandbox()
configured(monthlyCredits=1500, remote=False)
transcript("sess-t", [
  ("session.start", {"sessionId": "sess-t"}, NOW),
  ("user.message", {"content": "first prompt"}, NOW),
  ("user.message", {"content": "injected", "source": "skill-demo"}, NOW),
  ("assistant.message", {"model": "claude-sonnet-4.6", "outputTokens": 100}, NOW),
  ("session.shutdown", {"shutdownType": "routine", "modelMetrics": metrics(1000, 200, 600, 100, 2_000_000_000)}, NOW),
  ("session.resume", {}, NOW),
  ("user.message", {"content": "second prompt", "source": "user"}, NOW),
  ("assistant.message", {"model": "claude-sonnet-4.6", "outputTokens": 50}, NOW),
  ("session.shutdown", {"shutdownType": "routine", "modelMetrics": metrics(1500, 300, 900, 100, 3_000_000_000)}, NOW),
  ("user.message", {"content": "third prompt"}, NOW),
  ("assistant.message", {"model": "claude-sonnet-4.6", "outputTokens": 40}, NOW),
])
record = copilot()
expect("the transcripts count the user's prompts and offer them to the panel",
       [record["ready"], record["todayPrompts"], record["todaySessions"], record["hasPromptStats"]], [True, 3, 1, True], record)
expect("the transcripts read shutdown usage once",
       [record["modelUsage"]["claude-sonnet-4.6"], record["todayTotalTokens"]],
       [{"inputTokens": 500, "outputTokens": 340, "cacheReadInputTokens": 900, "cacheCreationInputTokens": 100}, 1840], record)
expect("the transcripts estimate spend from shutdown cost", record["limits"][0]["percent"], 0.002, record)

# A store that is there but can't be snapshotted leaves only the transcripts,
# and that short scan isn't cached for the runs after it.
check("a complete scan is cached", scan_cache_files("copilot"))
for path in scan_cache_files("copilot"):
  path.unlink()
(copilot_home() / "session-store.db").write_text("not a database")
record = copilot()
expect("a scan the store couldn't join serves its run but isn't cached", [record["todayPrompts"], scan_cache_files("copilot")], [3, []], record)

# A segment that spans midnight books its shutdown totals on the days its
# replies landed on: output by each day's reply output (40 / 60), everything
# else by reply count (2 / 1).
sandbox()
configured(remote=False)
transcript("sess-m", [
  ("user.message", {"content": "late prompt"}, YESTERDAY),
  ("assistant.message", {"model": "claude-sonnet-4.6", "outputTokens": 30}, YESTERDAY),
  ("assistant.message", {"model": "claude-sonnet-4.6", "outputTokens": 10}, YESTERDAY),
  ("assistant.message", {"model": "claude-sonnet-4.6", "outputTokens": 60}, NOW),
  ("session.shutdown", {"shutdownType": "routine", "modelMetrics": {"claude-sonnet-4.6": {
    "usage": {"inputTokens": 1300, "outputTokens": 100, "cacheReadTokens": 600, "cacheWriteTokens": 100, "reasoningTokens": 0}, "totalNanoAiu": 0}}}, NOW),
])
record = copilot()
expect("a midnight-spanning segment is booked on both days",
       [record["recentDays"][-2]["messageCount"], record["recentDays"][-1]["messageCount"], record["todayTotalTokens"]], [906, 494, 494], record)
expect("a split segment's totals stay whole", record["modelUsage"]["claude-sonnet-4.6"],
       {"inputTokens": 600, "outputTokens": 100, "cacheReadInputTokens": 600, "cacheCreationInputTokens": 100}, record)

# --------------------------------------------------------------- contract

# The live quota answers in AI credits, account-wide; it wins over the local
# estimate and supplies the plan and reset date.
sandbox()
ROUTES = {QUOTA_URL: quota("business", 1900, 475, token_based_billing=True, remaining=1425)}


def signed_in():
  copilot_home().mkdir(parents=True, exist_ok=True)
  configured(monthlyCredits=3000)
  os.environ["COPILOT_QUOTA_TOKEN"] = "test-token"


def add_request():
  store([(f"grown-{ms_in(0)}", NOW, "gpt-5.2", 0, 10, 1, 0, 0, 0)])


# - elapsed: the cache keeps GitHub's answer itself, its reset date at the
#   top level and no limit windows, so the contract's window rewrite can't
#   reach it; the own check below rewrites the reset date instead.
adapter = Adapter("copilot", plant=signed_in, answer=ROUTES, grow=add_request, skip=("elapsed",))
fresh = check_limits_contract(adapter)
expect("the live allowance is read in credits, with GitHub's plan and reset date",
       [fresh["limits"][0]["label"], fresh["limits"][0]["percent"], fresh["tierLabel"], fresh["limits"][0]["resetsAt"]],
       ["Monthly allowance", 0.25, "Business", RESET.isoformat()], fresh)
check_scan_cache(adapter)

# Once the kept answer's window has reset, its usage is back at zero and the
# next reset unknown.
for path in limits_cache_files("copilot"):
  write_json(path, dict(json.loads(path.read_text()), resetsAt=iso_in(-3600)))
record = copilot(routes=ROUTES, mode=500)
expect("a kept allowance whose window ended comes back at zero",
       [record["limits"][0]["label"], record["limits"][0]["percent"], record["limits"][0]["resetsAt"], record["limitsStale"], record["tierLabel"]],
       ["Monthly allowance", 0.0, "", True, "Business"], record)

# gh signed in on a machine that never ran the Copilot CLI: nothing is asked.
copilot("--force", "--copilot-home", str(home() / "never-ran"), routes=ROUTES)
expect("GitHub isn't asked where the CLI never ran", copilot.asked, [])
del os.environ["COPILOT_QUOTA_TOKEN"]

# ---------------------------------------------------------------------- gh

# The quota as gh's account sees it: a fake gh logs every run, and hosts.yml
# names who it is signed in as, so a reused answer needs no gh at all.
sandbox()
copilot_home().mkdir()
configured(monthlyCredits=3000)
gh_log = home() / "gh.log"
for name, body in (("gh", f'printf "%s\\n" "$*" >>{gh_log}\n[[ $1 == "auth" && $2 == "token" ]] && echo gh-token\n'), ("broken-gh", "exit 1\n")):
  stub = home() / name / "gh"
  stub.parent.mkdir()
  stub.write_text("#!/bin/bash\n" + body)
  stub.chmod(0o755)
hosts = config_home() / "gh" / "hosts.yml"
hosts.parent.mkdir(parents=True)
hosts.write_text("github.com:\n    users:\n        tester:\n    git_protocol: ssh\n    user: tester\n")
GH_ROUTES = {QUOTA_URL: quota("individual", 300, 30)}
os.environ["PATH"] = f"{home() / 'gh'}:{os.environ['PATH']}"


def gh_runs():
  return len(gh_log.read_text().splitlines()) if gh_log.exists() else 0


record = copilot(routes=GH_ROUTES)
expect("the quota is asked as gh's account", [meter(record), gh_runs(), copilot.asked],
       [{"limits": [["Monthly allowance", 0.1, True]], "stale": False, "status": "", "retry": False, "tier": "Pro"}, 1, ["Bearer gh-token"]], record)
copilot(routes=GH_ROUTES, force=False)
copilot("--limits-only", routes=GH_ROUTES)
expect("a reused answer runs no gh", [copilot.asked, gh_runs()], [[], 1])

# Another gh account has nothing kept; how it failed decides what it says.
hosts.write_text("github.com:\n    user: someone-else\n")
failed = {mode: copilot(routes=GH_ROUTES, mode=mode) for mode in ("down", 500, 401)}
expect("with nothing kept, a failure says what failed",
       [[record["usageStatusText"], record.get("retryAdvised", False), record["authHelpText"] != ""] for record in failed.values()],
       [["Copilot limits unavailable", True, True], ["Copilot limits unavailable", False, True], ["Sign-in expired", False, True]], failed)
expect("an error status is the detail, not a sign-in hint",
       ["status 500" in failed[500]["authHelpText"], "gh auth login" in failed[500]["authHelpText"]], [True, False], failed[500])

# gh still signed in to the first account but failing to hand over its token
# keeps that account's last allowance, stale.
hosts.write_text("github.com:\n    user: tester\n")
real_path = os.environ["PATH"]
os.environ["PATH"] = f"{home() / 'broken-gh'}:{real_path}"
record = copilot(routes=GH_ROUTES)
expect("gh failing to hand over its token keeps the last allowance, stale",
       [meter(record), "gh auth status" in record["authHelpText"], copilot.asked],
       [{"limits": [["Monthly allowance", 0.1, True]], "stale": True, "status": "", "retry": False, "tier": "Pro"}, True, []], record)

# No token anywhere, with the CLI in use: waiting for a sign-in.
os.environ["PATH"] = str(home() / "no-gh")
record = copilot(routes=GH_ROUTES)
expect("no GitHub token anywhere waits for a sign-in", [record["usageStatusText"], "gh auth login" in record["authHelpText"]], ["Waiting for auth", True], record)
os.environ["PATH"] = real_path

# An answer under the old copilot-quota-* name is adopted once.
os.environ["COPILOT_QUOTA_TOKEN"] = "legacy-token"
digest = hashlib.sha256(b"legacy-token").hexdigest()[:16]
legacy = cache_root() / f"copilot-quota-{digest}.json"
write_json(legacy, {"available": True, "entitlement": 100, "used": 40, "resetsAt": RESET.isoformat(), "planLabel": "Pro", "fetchedAtMs": 1000})
record = copilot(routes=GH_ROUTES, mode="down")
expect("an answer cached under the old name is adopted",
       [meter(record)["limits"], record["limitsStale"], legacy.exists(), (cache_root() / f"copilot-limits-{digest}.json").exists()],
       [[["Monthly allowance", 0.4, True]], True, False, True], record)
PY
