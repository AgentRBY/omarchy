#!/bin/bash

# The shared collector module, shell/plugins/agents/collectors.py, holds the
# parts of the collector contract every collector shares. Each collector's
# own tests cover its record end to end; this one holds the module's pieces
# to the contract directly, so a collector built on them inherits it.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

require_command python3
require_command rg

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

WORK="$WORK" python3 - <<'PY'
import json
import os
import sqlite3
import sys
import time
from datetime import datetime, timedelta, timezone
from pathlib import Path

sys.dont_write_bytecode = True
sys.path.insert(0, os.path.join(os.environ["OMARCHY_PATH"], "shell", "plugins", "agents"))
import collectors  # noqa: E402

work = Path(os.environ["WORK"])
home = work / "home"
home.mkdir()
os.environ["HOME"] = str(home)
os.environ["XDG_CACHE_HOME"] = str(work / "cache")
os.environ["XDG_DATA_HOME"] = str(home / ".local" / "share")
for name in ("PI_CODING_AGENT_DIR", "PI_CODING_AGENT_SESSION_DIR", "OPENCODE_DB"):
  os.environ.pop(name, None)


def check(description, condition, detail=""):
  if condition:
    print("ok - " + description)
    return
  print("not ok - " + description, file=sys.stderr)
  if detail:
    print(detail, file=sys.stderr)
  sys.exit(1)


today = datetime.now().strftime("%Y-%m-%d")
stamp = datetime.now(timezone.utc).isoformat(timespec="milliseconds").replace("+00:00", "Z")

# ------------------------------------------------------------- untrusted values

check("local_day reads a row with no time as today's", collectors.local_day(None) == today)
check(
  "local_day skips zero, negative, huge, NaN, boolean, and garbage times",
  [collectors.local_day(value) for value in (0, -5, 1e300, float("nan"), True, "not a date", "", [1])] == [None] * 8,
)
check("local_day reads epoch milliseconds, seconds, and digit strings alike", len({
  collectors.local_day(1_700_000_000_000),
  collectors.local_day(1_700_000_000),
  collectors.local_day("1700000000000"),
}) == 1)
check(
  "token counts skip booleans, strings, NaN, negatives, and absurd values",
  [collectors.token_count(value) for value in (True, "12", float("nan"), -1, 1e300, 12)] == [0, 0, 0, 0, 0, 12],
)
check(
  "usage_tokens takes the first spelling present",
  collectors.usage_tokens({"input_tokens": 9, "input": 3}, "input", "inputTokens", "input_tokens") == 3,
)

# ------------------------------------------------------------------ time

real_time = time.time
time.time = lambda: 1_000.0009
try:
  check("stamps are floored, never rounded", collectors.now_ms() == 1_000_000)
finally:
  time.time = real_time

now = time.time()
check("the age guard takes a stamp younger than the limit", collectors.age_below(now - 5, 15))
check("the age guard refuses a stamp as old as the limit", not collectors.age_below(now - 15, 15))
check("the age guard refuses a stamp from the future", not collectors.age_below(now + 60, 15))
check("a zero limit reuses nothing", not collectors.age_below(now, 0))
check("an untrusted stamp reads as never", [collectors.stamp(value) for value in (True, "5", float("inf"), -3, 7.9)] == [0, 0, 0, 0, 7])
check(
  "the scan reuse windows are 20, 900, and 0 seconds",
  (collectors.scan_max_age(False, False), collectors.scan_max_age(False, True), collectors.scan_max_age(True, True)) == (20, 900, 0),
)

# ------------------------------------------------------------------ record

record = collectors.base_record("demo", "Demo")
check(
  "the unused-machine record is unready, with no status, limits, or balance",
  {key: record[key] for key in ("schemaVersion", "id", "name", "ready", "hasLocalStats", "hasPromptStats", "tierLabel", "usageStatusText", "authHelpText", "limits", "limitsStale", "limitsFetchedAt")}
  == {"schemaVersion": 1, "id": "demo", "name": "Demo", "ready": False, "hasLocalStats": False, "hasPromptStats": True, "tierLabel": "", "usageStatusText": "", "authHelpText": "", "limits": [], "limitsStale": False, "limitsFetchedAt": 0}
  and "balance" not in record,
  json.dumps(record),
)
check(
  "the unused-machine record carries the full, zeroed stats block",
  [day["messageCount"] for day in record["recentDays"]] == [0] * 7
  and record["recentDays"][-1]["date"] == today
  and all(record[key] in (0, {}, []) for key in ("todayPrompts", "todaySessions", "todayTotalTokens", "todayTokensByModel", "totalPrompts", "totalSessions", "activeDays", "activeDates", "modelUsage")),
  json.dumps(record),
)

stats = collectors.Stats()
stats.add(today, "s1", "m", 1, 2, 3, 4)
stats.add(today, "s1", "m", 10, 0, 0, 0)
stats.add("2000-01-01", "s2", "n", 5, 0, 0, 0)
snapshot = stats.snapshot()
check(
  "the stats accumulator turns replies into the record's stats",
  (snapshot["todayPrompts"], snapshot["todaySessions"], snapshot["todayTotalTokens"], snapshot["totalPrompts"], snapshot["totalSessions"], snapshot["activeDates"], snapshot["recentDays"][-1]["messageCount"], snapshot["todayTokensByModel"], snapshot["modelUsage"]["m"])
  == (2, 1, 20, 3, 2, ["2000-01-01", today], 20, {"m": 20}, {"inputTokens": 11, "outputTokens": 2, "cacheReadInputTokens": 3, "cacheCreationInputTokens": 4}),
  json.dumps(snapshot),
)

# ------------------------------------------------------------- scan cache

calls = []


def scan():
  calls.append(1)
  return {**collectors.empty_stats(), "totalPrompts": len(calls)}, True


first = collectors.cached_scan("demo", ["a"], 20, scan)
again = collectors.cached_scan("demo", ["a"], 20, scan)
forced = collectors.cached_scan("demo", ["a"], 0, scan)
check("a scan is reused within its window and rebuilt at zero", (first["totalPrompts"], again["totalPrompts"], forced["totalPrompts"]) == (1, 1, 2))
cache_file, _ = collectors.scan_cache_paths("demo", ["a"])
cached = json.loads(cache_file.read_text())
check("the scan cache records its day", cached["scanDate"] == today and cached["schemaVersion"] == 2)
cached["scanDate"] = "2000-01-01"
cache_file.write_text(json.dumps(cached))
check("a scan from another day is a miss", collectors.cached_scan("demo", ["a"], 900, scan)["totalPrompts"] == 3)
check("a scan with other options is a miss", collectors.cached_scan("demo", ["a"], 900, scan, match={"modelPrefix": "kimi"})["totalPrompts"] == 4)
check("a scan with the same options is reused", collectors.cached_scan("demo", ["a"], 900, scan, match={"modelPrefix": "kimi"})["totalPrompts"] == 4)
collectors.cached_scan("demo", ["b"], 0, lambda: ({**collectors.empty_stats(), "totalPrompts": 99}, False))
check("an incomplete scan is never cached", collectors.cached_scan("demo", ["b"], 900, scan)["totalPrompts"] == 5)

# ------------------------------------------------------------------ limits

cache = collectors.LimitsCache("demo", "who@example.com")
check("each credential gets its own limits cache", cache.path.name.startswith("demo-limits-") and cache.path != collectors.LimitsCache("demo", "other").path)
past = (datetime.now(timezone.utc) - timedelta(hours=1)).isoformat()
future = (datetime.now(timezone.utc) + timedelta(hours=1)).isoformat()
fetched = cache.save([
  {"label": "Session", "percent": 0.8, "resetsAt": past},
  {"label": "Weekly", "percent": 0.3, "resetsAt": future},
  {"label": "Monthly", "percent": 0.5, "resetsAt": ""},
])
kept = collectors.LimitsCache("demo", "who@example.com")
check(
  "a kept window whose reset passed reads 0 with no reset; others stay as they were",
  [(entry["percent"], entry["resetsAt"]) for entry in kept.limits] == [(0.0, ""), (0.3, future), (0.5, "")],
  json.dumps(kept.limits),
)
check("a fresh answer stands in for a probe, but not past --force", kept.fresh(False) and not kept.fresh(True))
check("the stale fallback carries when the limits were measured", kept.kept() == (kept.limits, fetched))
os.utime(kept.path, (0, 0))
check("the limits cache is read whatever its file time", collectors.LimitsCache("demo", "who@example.com").fetched_at == fetched)
data = json.loads(kept.path.read_text())
data["fetchedAtMs"] = collectors.now_ms() + 60_000
kept.path.write_text(json.dumps(data))
future_stamped = collectors.LimitsCache("demo", "who@example.com")
check("a future-stamped answer is kept but never trusted as fresh", future_stamped.limits and not future_stamped.fresh(False))
check("no answer at all has nothing to fall back on", collectors.LimitsCache("demo", "nobody").kept() == ([], 0))
check("an identity holding a lone surrogate still gets its own limits cache", collectors.LimitsCache("demo", "who\udc80").path != cache.path)

# ------------------------------------------------------------------- http

import io
import urllib.error
import urllib.request

real_urlopen = urllib.request.urlopen


def failing(error):
  def open_(request, timeout=None):
    raise error
  return open_


def outcome(opener):
  urllib.request.urlopen = opener
  try:
    return collectors.open_json(urllib.request.Request("https://example.invalid"))
  except collectors.HttpError as error:
    return (error.status, error.transport, error.invalid)
  finally:
    urllib.request.urlopen = real_urlopen


check("open_json returns the JSON answer", outcome(lambda request, timeout=None: io.BytesIO(b'{"a":1}')) == {"a": 1})
check("an HTTP status is a refusal, not a transport failure", outcome(failing(urllib.error.HTTPError("u", 401, "no", {}, None))) == (401, False, False))
check("no route, no DNS, and a timeout are transport failures", {outcome(failing(error)) for error in (urllib.error.URLError("no route"), TimeoutError("slow"), ConnectionResetError())} == {(0, True, False)})
check("a body that isn't JSON is an invalid answer", outcome(lambda request, timeout=None: io.BytesIO(b"<html>")) == (0, False, True))
handlers = [handler for handler in urllib.request._opener.handlers if isinstance(handler, urllib.request.HTTPRedirectHandler)]
check("requests refuse redirects", handlers and handlers[0].redirect_request(None, None, 302, "Found", {}, "https://elsewhere") is None)

# --------------------------------------------------------- pi/omp sessions


def write_session(path, lines, header=None):
  path.parent.mkdir(parents=True, exist_ok=True)
  with path.open("w") as handle:
    if header is not None:
      handle.write(json.dumps(header) + "\n")
    for line in lines:
      handle.write(json.dumps(line) + "\n")


def reply(provider, tokens, message_id=None, timestamp=stamp, model="m", usage=None):
  line = {"type": "message", "timestamp": timestamp, "message": {"role": "assistant", "provider": provider, "model": model, "usage": usage or {"input": tokens}}}
  if message_id:
    line["id"] = message_id
  return line


sessions = home / ".pi" / "agent" / "sessions"
moved = work / "moved"
alone = work / "alone"
(home / ".omp" / "profiles" / "work").mkdir(parents=True)
(home / ".pi" / "profiles").mkdir(parents=True)
# A profile linked into the default root sits inside it, so it is dropped.
(sessions / "nested").mkdir(parents=True)
(home / ".pi" / "profiles" / "nest").symlink_to(sessions / "nested")
os.environ["PI_CODING_AGENT_DIR"] = str(moved)
os.environ["PI_CODING_AGENT_SESSION_DIR"] = str(alone)
roots = collectors.pi_session_roots()
check(
  "session roots are the defaults, each profile, and both overrides, nested ones dropped",
  roots == [
    sessions.resolve(),
    (home / ".omp" / "agent" / "sessions").resolve(),
    (home / ".omp" / "profiles" / "work" / "agent" / "sessions").resolve(),
    (moved / "sessions").resolve(),
    alone.resolve(),
  ],
  "\n".join(map(str, roots)),
)
os.environ["PI_CODING_AGENT_DIR"] = str(home / ".pi" / "agent")
check("an override that aliases a default root is read once", collectors.pi_session_roots().count(sessions.resolve()) == 1)
os.environ.pop("PI_CODING_AGENT_DIR")

parent = sessions / "p" / "parent.jsonl"
write_session(parent, [
  reply("demo", 100, "m1"),
  reply("demo", 1),
  reply("demo", 1),
  reply("other", 5000, "o1"),
  reply("demo", 7, "z", timestamp=0),
  reply("demo", 0, "t", usage={"input": 0, "totalTokens": 40}),
  reply("demo", 0, "r", usage={"input": 2, "output": 3, "reasoning": 4, "cacheRead": 5, "cache_write": 6}),
])
# The fork is read first by name, and repeats the parent's message.
write_session(sessions / "a" / "fork.jsonl", [reply("demo", 100, "m1"), reply("demo", 10, "m2")], header={"type": "session", "parentSession": str(parent)})
write_session(sessions / "a" / "copy-only.jsonl", [reply("demo", 100, "m1")], header={"type": "session", "parentSession": str(parent)})
write_session(alone / "x.jsonl", [reply("demo", 1000, "m3")])
# A $HOME that is a git checkout ignoring everything still gets read.
(home / ".git").mkdir()
(home / ".gitignore").write_text("*\n")

rows, complete = collectors.scan_pi_sessions(r'"provider"\s*:\s*"(demo|other)"', lambda provider, model, entry: provider == "demo")
by_tokens = sorted(row.input_tokens + row.output_tokens + row.cache_read + row.cache_write for row in rows)
check("a scan that read everything says so", complete)
check(
  "pi replies count once by (id, timestamp), id-less lines always, with totals, thinking, and garbage handled",
  by_tokens == [1, 1, 10, 20, 40, 100, 1000],
  json.dumps([row._asdict() for row in rows]),
)
reasoning = next(row for row in rows if row.input_tokens == 2)
check("thinking tokens count as output", (reasoning.output_tokens, reasoning.cache_read, reasoning.cache_write) == (7, 5, 6))
check("a forked message counts toward the session it was forked from", next(row for row in rows if row.input_tokens == 100).session == os.path.realpath(parent))
check("a fork that only copied its parent is no session of its own", os.path.realpath(sessions / "a" / "copy-only.jsonl") not in {row.session for row in rows})
check("the provider filter is the caller's", all(row.provider == "demo" for row in rows))

# --------------------------------------------------------------- opencode

db = home / ".local" / "share" / "opencode" / "opencode.db"
db.parent.mkdir(parents=True)
now_ms = int(time.time() * 1000) - 1000
fork_ms = now_ms - 60_000


def v1(provider, tokens, created=now_ms):
  return json.dumps({"role": "assistant", "providerID": provider, "modelID": "v1-model", "tokens": tokens, "time": {"created": created}})


def v2(provider, tokens):
  return json.dumps({"model": {"providerID": provider, "id": "v2-model"}, "tokens": tokens, "time": {"created": now_ms}})


conn = sqlite3.connect(db)
conn.execute("CREATE TABLE message (id text PRIMARY KEY, session_id text, time_created integer, time_updated integer, data text)")
conn.execute("CREATE TABLE session_message (id text PRIMARY KEY, session_id text, type text, time_created integer, data text)")
conn.execute("CREATE TABLE session_v2 (id text PRIMARY KEY, fork_session_id text, time_created integer)")
conn.execute("INSERT INTO session_v2 VALUES ('ses_fork', 'ses_v2', ?)", (fork_ms,))
conn.executemany("INSERT INTO message VALUES (?, ?, ?, ?, ?)", [
  ("msg_v1", "ses_v1", now_ms, now_ms, v1("demo", {"input": 10, "output": 5, "reasoning": 2, "cache": {"read": 3, "write": 1}})),
  ("msg_both", "ses_v1", now_ms, now_ms, v1("demo", {"input": 40})),
  ("msg_zero", "ses_v1", now_ms, now_ms, v1("demo", {"input": 8000}, created=0)),
  ("msg_lookalike", "ses_v1", now_ms, now_ms, v1("demo-proxy", {"input": 9000})),
  ("msg_other", "ses_v1", now_ms, now_ms, v1("other", {"input": 9000})),
])
conn.executemany("INSERT INTO session_message VALUES (?, ?, ?, ?, ?)", [
  ("msg_compact", "ses_v2", "compaction", now_ms, v2("demo", {"input": 30})),
  ("msg_both", "ses_v1", "assistant", now_ms, v2("demo", {"input": 40})),
  ("msg_copy", "ses_fork", "assistant", fork_ms - 5_000, v2("demo", {"input": 7000})),
  ("msg_forked", "ses_fork", "assistant", now_ms, v2("demo", {"input": 50})),
  ("msg_bad", "ses_v2", "assistant", now_ms, '{"model":{"providerID":"demo"'),
])
conn.commit()
conn.close()

accept_demo = lambda provider, model, entry: provider == "demo"  # noqa: E731
rows, complete = collectors.scan_opencode(["demo"], accept_demo)
check(
  "opencode rows come from both stores once each, compactions in, fork copies and untrusted times out",
  complete and sorted(row.input_tokens + row.output_tokens for row in rows) == [17, 30, 40, 50],
  json.dumps([row._asdict() for row in rows]),
)
check("the V2 store is read first", next(row for row in rows if row.input_tokens == 40).model == "v2-model")
check("opencode rows count toward their session", {row.session for row in rows} == {"opencode:ses_v1", "opencode:ses_v2", "opencode:ses_fork"})
check("a closing quote keeps a look-alike provider out of the prefilter", collectors.scan_opencode(['demo"'], lambda *_: True)[0] == collectors.scan_opencode(["demo"], accept_demo)[0])

db.rename(db.parent / "elsewhere.db")
os.environ["OPENCODE_DB"] = "elsewhere.db"
check("OPENCODE_DB names the database, a relative name beside the default", len(collectors.scan_opencode(["demo"], accept_demo)[0]) == 4)
os.environ.pop("OPENCODE_DB")
(db.parent / "elsewhere.db").rename(db.parent / "opencode-v2.db")
check("opencode-v2.db is read when opencode.db is absent", len(collectors.scan_opencode(["demo"], accept_demo)[0]) == 4)

before = (db.parent / "opencode-v2.db").read_bytes()
collectors.scan_opencode(["demo"], accept_demo)
check("the database is opened read-only", (db.parent / "opencode-v2.db").read_bytes() == before)

(db.parent / "opencode-v2.db").write_bytes(b"not a database at all, just bytes" * 200)
rows, complete = collectors.scan_opencode(["demo"], accept_demo)
check("a database error marks the scan incomplete", not complete and rows == [])
PY
