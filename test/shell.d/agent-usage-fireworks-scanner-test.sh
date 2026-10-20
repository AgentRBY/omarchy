#!/bin/bash

# The Fireworks collector's own sources: the key from FIREWORKS_API_KEY,
# firectl's auth.ini, or a pi or opencode login; the billing API's usage
# buckets, paged; and the balance, live where the key can read the ledger and
# estimated from configured funding where it can't. The unused-machine record
# is held centrally by the partition test.
#
# Fireworks keeps a balance and no limit windows, and reuses its usage rows
# through a limits cache rather than a scan cache, so neither contract check
# fits it as they stand: check_balance_contract below holds the balance to the
# same probe contract, and the usage reuse windows have a check of their own.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"
source "$SHELL_TEST_DIR/agent-usage-helpers.sh"

agent_sandbox

# Bucket dates resolve in local time, so pin the zone or the fixtures below
# would shift by a day depending on where the test runs.
export TZ=UTC

python3 - <<'PY'
from agent_usage_fixtures import *
from datetime import date

API = "https://api.fireworks.ai"
TODAY = time.strftime("%Y-%m-%d")
ROWS = [{"startTime": TODAY + "T00:00:00Z", "promptTokens": "100", "completionTokens": "20", "group": {"model_name": "accounts/fireworks/models/kimi-k2p5"}}]
LIVE = {"balance": {"units": "12", "nanos": 500000000}}
ROUTES = {
  ":getBalance": LIVE,
  "/billingUsage": {"serverlessCosts": ROWS},
  "/usageCosts:query": {"subtotal": {"units": "8", "nanos": 600000000}},
}
# A key without the billing role: the ledger is gated, so the balance is
# estimated from the configured funding and the rated costs since.
ESTIMATED = dict(ROUTES, **{":getBalance": 403})
# Nor can it read the costs, so there is no balance at all.
NO_BALANCE = dict(ROUTES, **{":getBalance": 403, "/usageCosts:query": 403, "/billing/summary": 403})


def signed_in(key="fw_test"):
  auth = home() / ".fireworks" / "auth.ini"
  auth.parent.mkdir(parents=True, exist_ok=True)
  auth.write_text(f"[default]\napi_key = {key}\naccount_id = example\n")
  write_json(config_home() / "omarchy" / "agents" / "fireworks.json", {"accountId": "example", "fundedAmount": 20, "fundedAt": "2026-07-01"})


def fireworks(*args, routes=None, mode="up", force=True, **env):
  saved = dict(os.environ)
  os.environ.update(env)
  try:
    with FakeHttp(ROUTES if routes is None else routes, mode=mode) as http:
      record = collect("fireworks", *(args or (("--force",) if force else ())))
  finally:
    os.environ.clear()
    os.environ.update(saved)
  fireworks.asked = ["balance" if ":getBalance" in request["url"] else "usage" for request in http.requests]
  return record


def remaining(record):
  return (record.get("balance") or {}).get("remaining")


# check_limits_contract held to the balance instead of limit windows: a fresh
# probe, the 15-second reuse for a normal and a --limits-only run, --force, a
# failed check and an unreachable service keeping the last balance stale, and
# a refused key. A candidate for the shared fixtures.
def check_balance_contract(plant, per_probe):
  for path in limits_cache_files("fireworks"):
    path.unlink()
  plant()
  fresh = fireworks()
  check("fireworks: a fresh balance is live, stamped, healthy, and asked for once per probe",
        remaining(fresh) is not None and fresh["limitsStale"] is False and fresh["limitsFetchedAt"] > 0 and fresh["usageStatusText"] == ""
        and fresh["authHelpText"] == "" and not fresh.get("retryAdvised") and len(fireworks.asked) == per_probe, json.dumps(fresh))
  for args in ((), ("--limits-only",)):
    reused = fireworks(*args, mode=500, force=False)
    check(f"fireworks: a {'--limits-only' if args else 'normal'} run inside the probe interval reuses the answer, live",
          fireworks.asked == [] and reused.get("balance") == fresh["balance"] and reused["limitsFetchedAt"] == fresh["limitsFetchedAt"]
          and reused["limitsStale"] is False and reused["usageStatusText"] == "", json.dumps(reused))
  forced = fireworks()
  check("fireworks: --force asks again inside the probe interval", len(fireworks.asked) == per_probe and forced["limitsStale"] is False, json.dumps(forced))
  kept = fireworks(mode=500)
  check("fireworks: a failed check keeps the last balance, stale, with when it was measured",
        kept.get("balance") == forced["balance"] and kept["limitsStale"] is True and kept["limitsFetchedAt"] == forced["limitsFetchedAt"]
        and kept["usageStatusText"] == "" and not kept.get("retryAdvised"), json.dumps(kept))
  for mode in ("down", "timeout"):
    unreachable = fireworks(mode=mode)
    check(f"fireworks: an unreachable service ({mode}) advises a retry and keeps the last balance, stale",
          unreachable.get("retryAdvised") is True and unreachable.get("balance") == forced["balance"] and unreachable["limitsStale"] is True
          and unreachable["usageStatusText"] == "", json.dumps(unreachable))
  refused = fireworks(mode=401)
  check("fireworks: a refused key says 'Sign-in expired', advises no retry, and shows nothing as live",
        refused["usageStatusText"] == "Sign-in expired" and not refused.get("retryAdvised") and refused["limitsStale"] is True, json.dumps(refused))
  return fresh


# ---------------------------------------------------------------- contract

sandbox()
fresh = check_balance_contract(signed_in, 2)
expect("the record is account-wide and prepaid, with tokens and no prompt counts or limits",
       {key: fresh.get(key) for key in ("ready", "hasPromptStats", "scope", "tierLabel", "limits", "todayTotalTokens", "hasLocalStats")},
       {"ready": True, "hasPromptStats": False, "scope": "account", "tierLabel": "Prepaid", "limits": [], "todayTotalTokens": 120, "hasLocalStats": True}, fresh)
expect("the live getBalance ledger is preferred when the key can read it", fresh["balance"],
       {"remaining": 12.5, "funded": 20.0, "spent": 7.5, "currency": "USD", "estimated": False}, fresh)

# The usage rows are this record's stats, reused like a local scan: briefly
# on a normal run and for 15 minutes on the near-limit refresh, which probes
# the balance like a normal run.
fireworks()
for path in cache_root().glob("fireworks-*.json"):
  data = json.loads(path.read_text())
  write_json(path, dict(data, fetchedAtMs=data["fetchedAtMs"] - 60_000))
fireworks("--limits-only")
limits_only = fireworks.asked
fireworks(force=False)
expect("a minute-old answer serves --limits-only its usage but not its balance, and a normal run neither",
       [limits_only, fireworks.asked], [["balance"], ["usage"]])

# ------------------------------------------------------------- the balance

# A key that can't read the ledger gets an estimate from the configured
# funding, less the costs rated since.
sandbox()
signed_in()
record = fireworks(routes=ESTIMATED)
expect("the balance is estimated from configured funding", record["balance"],
       {"remaining": 11.4, "funded": 20.0, "spent": 8.6, "currency": "USD", "estimated": True}, record)

# A failed balance check keeps the last good balance, stale, with the status
# left to limitsStale; with nothing kept it says the balance is unavailable,
# and the tokens still show.
record = fireworks(routes=NO_BALANCE)
expect("a failed balance check keeps the last balance, stale",
       [remaining(record), record["limitsStale"], record["usageStatusText"], record["authHelpText"], record.get("retryAdvised")],
       [11.4, True, "", "The Fireworks API key cannot read billing data", None], record)
for path in limits_cache_files("fireworks"):
  path.unlink()
record = fireworks(routes=NO_BALANCE)
expect("a failed balance check with nothing kept says so and keeps the tokens",
       [record["ready"], "balance" in record, record["modelUsage"]["kimi-k2.5"]["outputTokens"], record["usageStatusText"], record["limitsStale"]],
       [True, False, 20, "Balance unavailable", True], record)

# Usage and balance both unreachable with nothing kept: the stats source is
# unavailable.
sandbox()
signed_in()
record = fireworks(mode="down")
expect("an unreachable API with nothing kept says Fireworks is unavailable",
       [record["ready"], record["usageStatusText"], record["limitsStale"], record.get("retryAdvised"), record.get("balance")],
       [True, "Fireworks unavailable", True, True, None], record)

# Another key, or the same key now pointed at another account, never shows
# these numbers.
fireworks()
record = fireworks(mode="down", FIREWORKS_API_KEY="fw_other")
expect("each key's answers are kept apart", [record.get("balance"), record["todayTotalTokens"], record["usageStatusText"]], [None, 0, "Fireworks unavailable"], record)
record = fireworks(mode="down", FIREWORKS_ACCOUNT_ID="elsewhere")
expect("each account's answers are kept apart", [record.get("balance"), record["todayTotalTokens"]], [None, 0], record)

# ------------------------------------------------------------ the answer

module = load_collector("fireworks")

# Today's uncached, cached and output tokens count once, cache apart in the
# model totals, over the 30-day window.
summary = module.summarize_usage({"serverlessCosts": [
  {"startTime": "2026-07-31T00:00:00Z", "promptTokens": "100", "cachedPromptTokens": "40", "uncachedPromptTokens": "60", "completionTokens": "20",
   "group": {"model_name": "accounts/fireworks/models/kimi-k2p5"}},
  {"startTime": "2026-07-30T00:00:00Z", "promptTokens": "300", "cachedPromptTokens": "0", "completionTokens": "50",
   "group": {"model_name": "accounts/fireworks/models/deepseek-v3p2"}},
  {"startTime": "2026-07-20T00:00:00Z", "promptTokens": "500", "cachedPromptTokens": "0", "completionTokens": "100",
   "group": {"model_name": "accounts/fireworks/models/kimi-k2p5"}},
]}, date(2026, 7, 31))
expect("today's token categories count once, cache apart, over the 30-day window",
       [summary["todayTotalTokens"], summary["recentDays"][-1]["messageCount"], summary["activeDays"], summary["modelUsage"]["kimi-k2.5"]],
       [120, 120, 3, {"inputTokens": 560, "outputTokens": 120, "cacheReadInputTokens": 40, "cacheCreationInputTokens": 0}], summary)
expect("untrusted token fields are skipped", module.summarize_usage({"serverlessCosts": [
  {"startTime": TODAY + "T00:00:00Z", "promptTokens": True, "completionTokens": "NaN", "group": {"model_name": "a"}},
  {"startTime": TODAY + "T00:00:00Z", "promptTokens": 1e300, "completionTokens": "inf", "group": {"model_name": "b"}},
  {"startTime": TODAY + "T00:00:00Z", "promptTokens": -5, "completionTokens": 7, "group": {"model_name": "c"}},
]})["modelUsage"], {"c": {"inputTokens": 0, "outputTokens": 7, "cacheReadInputTokens": 0, "cacheCreationInputTokens": 0}})
expect("Money reads units and nanos", float(module.money_value({"units": "12", "nanos": 430000000})), 12.43)

# billingUsage pages long ranges, so every continuation token is followed,
# from a window that opens at local midnight.
client = module.FireworksClient("fw_test", API)
with FakeHttp({"pageToken=p2": {"serverlessCosts": [{"startTime": "2026-07-31T00:00:00Z"}]},
               "/billingUsage": {"serverlessCosts": [{"startTime": "2026-07-30T00:00:00Z"}], "nextPageToken": "p2"}}) as http:
  merged = client.usage("example", date(2026, 7, 1), date(2026, 8, 1))
first = urllib.parse.parse_qs(urllib.parse.urlsplit(http.requests[0]["url"]).query)
expect("billingUsage continuation tokens are followed", [len(merged["serverlessCosts"]), len(http.requests), first["startTime"]], [2, 2, ["2026-07-01T00:00:00Z"]])

# A reply that isn't an object, or usage rows that aren't a list, fail the
# check rather than passing for an idle account; a missing list is an idle
# month, since the API leaves empty lists out.
def fails(call):
  try:
    call()
  except module.FireworksError:
    return True
  return False


with FakeHttp({"/v1/accounts": []}):
  odd_object = fails(lambda: client.request("/v1/accounts"))
with FakeHttp({"/billingUsage": {"serverlessCosts": "rows"}}):
  odd_rows = fails(lambda: client.usage("example", date(2026, 7, 1), date(2026, 8, 1)))
with FakeHttp({"/billingUsage": {}}):
  idle = client.usage("example", date(2026, 7, 1), date(2026, 8, 1))
expect("a reply of the wrong shape fails, and a missing usage list reads as idle", [odd_object, odd_rows, idle], [True, True, {"serverlessCosts": []}])

# East of Greenwich, a local-midnight bucket starts on the previous UTC date;
# the row still lands on the local day it names, and the query window asks
# for local midnights expressed in UTC.
saved_tz = os.environ.get("TZ")
os.environ["TZ"] = "Etc/GMT-2"
time.tzset()
try:
  east = [module.row_date({"startTime": "2026-07-30T22:00:00Z"}), module.local_midnight_utc(date(2026, 7, 31))]
finally:
  if saved_tz is None:
    os.environ.pop("TZ", None)
  else:
    os.environ["TZ"] = saved_tz
  time.tzset()
expect("buckets are dated by local day, and windows open at local midnight in UTC", east, ["2026-07-31", "2026-07-30T22:00:00Z"])

# ---------------------------------------------------------- the credentials

# firectl's auth.ini, then a pi login, then opencode's; pi's key resolves a
# $VAR reference and leaves a !command lookup to pi.
sandbox()
auth = home() / ".fireworks" / "auth.ini"
signed_in()
expect("firectl's auth.ini gives the key and account", list(module.read_auth_file(auth)), ["fw_test", "example"])
missing = home() / "missing.ini"
opencode_auth(None, "fireworks-ai", "fw_opencode")
expect("opencode's key is the last resort", [module.credentials(missing, {})[0], module.credentials(auth, {})[0]], ["fw_opencode", "fw_test"])
pi_auth(None, "fireworks", "fw_pi")
expect("a pi login comes below firectl and above opencode", [module.credentials(missing, {})[0], module.credentials(auth, {})[0]], ["fw_pi", "fw_test"])
os.environ["FW_TEST_ENV_KEY"] = "fw_from_env"
expect("pi's $VAR keys resolve, and a missing one stays unresolved",
       [module.resolve_pi_key("$FW_TEST_ENV_KEY"), module.resolve_pi_key("$FW_DEFINITELY_MISSING")], ["fw_from_env", ""])
pi_auth(None, "fireworks", "!secret-tool lookup fw")
expect("pi's !command keys are skipped for the next rung", module.credentials(missing, {})[0], "fw_opencode")
PY
