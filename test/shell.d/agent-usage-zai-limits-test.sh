#!/bin/bash

# The Z.ai collector's limits: how it reads the monitor endpoint's windows and
# plan, a key without a Coding Plan, a rejected key, the keys pi saves, and its
# adapter for the contract checks. The unused-machine record is held centrally
# by the partition test, the limits cache's mechanics by the shared test, and
# the scan cache by the scanner test.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"
source "$SHELL_TEST_DIR/agent-usage-helpers.sh"

agent_sandbox

python3 - <<'PY'
from agent_usage_fixtures import *

QUOTA = "api.z.ai/api/monitor/usage/quota/limit"
ANSWER = {"data": {"level": "max", "limits": [
  {"type": "CREDIT_LIMIT", "unit": 3, "number": 5, "percentage": 44.0, "nextResetTime": ms_in(3 * 3600)},
  {"type": "CREDIT_LIMIT", "unit": 6, "number": 1, "percentage": 10, "nextResetTime": ms_in(5 * 86400)},
]}}


def keyed(key="token"):
  os.environ["ZAI_API_KEY"] = key


def zai(answer=None, mode="up", args=("--force",)):
  with FakeHttp({QUOTA: answer}, mode=mode) as http:
    record = collect("zai", *args)
  return record, http


# ---------------------------------------------------------------- contract

sandbox()
fresh = check_limits_contract(Adapter("zai", plant=keyed, answer={QUOTA: ANSWER}))
expect("Z.ai's plan and windows come from the monitor endpoint",
       [fresh["tierLabel"], [(entry["label"], entry["percent"]) for entry in fresh["limits"]]],
       ["Max", [("Session (5-hour)", 0.44), ("Weekly (7-day)", 0.1)]], fresh)

# A failed check keeps the plan with the windows.
record, _ = zai(mode="down")
expect("Z.ai collector keeps the cached plan past a failed check", [record["tierLabel"], record["limitsStale"]], ["Max", True], record)

# A rejected key is a sign-in to redo, and only then is the key blamed.
record, _ = zai(mode=401)
check("Z.ai collector blames the key only when the key is rejected",
      record["usageStatusText"] == "Sign-in expired" and "rejected the saved API key" in record["authHelpText"] and len(record["limits"]) == 2, record)

# Another key never shows this one's numbers.
keyed("other-key")
record, _ = zai(mode="down")
expect("Z.ai collector keeps each key's limits apart", [record["limits"], record["usageStatusText"]], [[], "Z.ai limits unavailable"], record)

# ------------------------------------------------------------- the answer

# The mapped session and weekly windows, then the entries that must drop: a
# window tagged with an unmapped (unit, number), one whose percentage will not
# parse, and one whose percentage is a boolean. nextResetTime is milliseconds
# for the first and plain seconds for the second, to prove a seconds epoch is
# not rendered 1000x in the future.
sandbox()
keyed()
week = int(time.time() + 5 * 86400)
with contextlib.redirect_stderr(io.StringIO()):
  record, _ = zai({"data": {"level": "pro", "limits": [
    {"type": "CREDIT_LIMIT", "unit": 3, "number": 5, "percentage": 42.0, "nextResetTime": ms_in(3 * 3600)},
    {"type": "TOKENS_LIMIT", "unit": 6, "number": 1, "percentage": 10, "nextResetTime": week},
    {"type": "CREDIT_LIMIT", "unit": 9, "number": 9, "percentage": 5, "nextResetTime": ms_in(3 * 3600)},
    {"type": "CREDIT_LIMIT", "unit": 3, "number": 5, "percentage": None, "nextResetTime": ms_in(3 * 3600)},
    {"type": "CREDIT_LIMIT", "unit": 3, "number": 5, "percentage": True, "nextResetTime": ms_in(3 * 3600)},
  ]}})
expect("Z.ai collector reads windows, tier, seconds/ms resets, and drops bad rows",
       [[(entry["label"], entry["percent"]) for entry in record["limits"]], record["tierLabel"], record["limits"][1]["resetsAt"][:10]],
       [[("Session (5-hour)", 0.42), ("Weekly (7-day)", 0.1)], "Pro", datetime.fromtimestamp(week, timezone.utc).date().isoformat()], record)

# A key with no plan is a pay-as-you-go account: no trouble, no blame on the
# key, and no limits kept from a plan that lapsed.
record, _ = zai({"success": False, "msg": "This API key has no coding plan"})
expect("Z.ai collector treats a no-plan key as healthy, without limits",
       [record["usageStatusText"], record["authHelpText"], bool(record.get("retryAdvised")), record["limits"], record["limitsStale"]],
       ["", "", False, [], False], record)

# With nothing kept, a failed check says the limits are unavailable; only a
# transport failure asks for an early retry.
for path in limits_cache_files("zai"):
  path.unlink()
record, _ = zai(mode="down")
check("Z.ai collector reports unavailable limits when offline with nothing kept, and advises a retry",
      record["usageStatusText"] == "Z.ai limits unavailable" and record.get("retryAdvised") is True and record["limits"] == []
      and "reach" in record["authHelpText"], record)
record, _ = zai(mode=500)
expect("Z.ai collector does not advise a retry for a server's error status",
       [record["usageStatusText"], bool(record.get("retryAdvised"))], ["Z.ai limits unavailable", False], record)

# A predictable lock path must not follow and truncate a planted symlink.
lock = load_collector("zai").limits_cache_paths("token", "zai")[1]
sentinel = home() / "sentinel"
sentinel.write_text("intact")
lock.parent.mkdir(parents=True, exist_ok=True)
lock.unlink(missing_ok=True)
lock.symlink_to(sentinel)
zai(ANSWER)
expect("Z.ai collector does not follow a planted lock symlink", sentinel.read_text(), "intact")

# ------------------------------------------------------------ credentials

# A key pi saved with /login counts as a credential.
sandbox()
pi_auth(None, "zai", "pi-saved")
expect("Z.ai collector reads the key pi saved in auth.json", list(load_collector("zai").credentials()), ["pi-saved", "zai"])
PY
