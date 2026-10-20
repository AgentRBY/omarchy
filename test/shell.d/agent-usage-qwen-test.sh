#!/bin/bash

# The Qwen Code collector's own sources: its chat transcripts, read the way
# Qwen Code's own statistics read them, where QWEN_HOME, QWEN_RUNTIME_DIR and
# settings.json put them, and the per-transcript index. The unused-machine
# record is held by the partition test, and the scan cache by the contract
# check. Qwen Code publishes no limits, so there is no limits contract to
# hold.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"
source "$SHELL_TEST_DIR/agent-usage-helpers.sh"

agent_sandbox

python3 - <<'PY'
from agent_usage_fixtures import *

NOW = datetime.now(timezone.utc).isoformat(timespec="milliseconds").replace("+00:00", "Z")
TWO_DAYS_AGO = (datetime.now(timezone.utc) - timedelta(days=2)).isoformat(timespec="milliseconds").replace("+00:00", "Z")


def qwen(*args):
  return collect("qwen", *(args or ("--force",)))


def prompt(uuid, session, timestamp, subtype=None):
  line = {"uuid": uuid, "parentUuid": None, "sessionId": session, "timestamp": timestamp, "type": "user", "message": {"role": "user", "parts": [{"text": "hi"}]}}
  if subtype:
    line["subtype"] = subtype
  return line


# One billed answer, as Qwen Code logs it: a ui_telemetry api_response event.
def response(uuid, session, timestamp, model, auth, input, output, cached, thoughts, response_id=""):
  event = {"event.name": "qwen-code.api_response", "event.timestamp": timestamp, "response_id": response_id, "model": model, "auth_type": auth,
           "input_token_count": input, "output_token_count": output, "cached_content_token_count": cached, "thoughts_token_count": thoughts, "total_token_count": 0}
  return {"uuid": uuid, "sessionId": session, "timestamp": timestamp, "type": "system", "subtype": "ui_telemetry", "systemPayload": {"uiEvent": event}}


def transcript(path, lines, mode="w"):
  path = Path(path)
  path.parent.mkdir(parents=True, exist_ok=True)
  with path.open(mode) as handle:
    for line in lines:
      handle.write((line if isinstance(line, str) else json.dumps(line)) + "\n")
  return path


def chats(project="p"):
  return home() / ".qwen" / "projects" / project / "chats"


# ------------------------------------------------------------- transcripts

sandbox()
transcript(chats("-home-me-app") / "s1.jsonl", [
  prompt("u1", "s1", NOW),
  response("r1", "s1", NOW, "qwen3-coder-plus", "qwen-oauth", 1000, 200, 600, 50, "resp-1"),
  prompt("u2", "s1", NOW, "mid_turn_user_message"),
  # Goal and notification records are not typed prompts.
  prompt("u3", "s1", NOW, "goal_runtime"),
  # Gemini leaves thinking out of the output count.
  response("r2", "s1", NOW, "gemini-2.5-pro", "gemini-api-key", 300, 40, 0, 10, "resp-2"),
  # A provider that reports only the cached part reported a fully cached prompt.
  response("r3", "s1", NOW, "qwen3-coder-plus", "openai", 0, 5, 80, 0, "resp-3"),
  {"uuid": "x", "type": "system", "subtype": "ui_telemetry", "systemPayload": {"uiEvent": {"event.name": "qwen-code.tool_call", "model": "m"}}},
  {"uuid": "y", "type": "assistant", "model": "qwen3-coder-plus", "usageMetadata": {"promptTokenCount": 999}},
])
earlier = [prompt("u4", "s2", TWO_DAYS_AGO), response("r4", "s2", TWO_DAYS_AGO, "qwen3-coder-plus", "openai", 70, 7, 0, 3, "resp-4")]
transcript(chats("-home-me-app") / "s2.jsonl", earlier)
# A branched session carries the records it was branched from.
transcript(chats("-home-me-app") / "s3.jsonl", earlier)
transcript(chats("-home-me-app") / "s1.ledger.jsonl", [{"uuid": "l", "type": "user", "sessionId": "s1", "timestamp": NOW}])

record = qwen()
two_days_ago = (datetime.now() - timedelta(days=2)).strftime("%Y-%m-%d")
expect("Qwen counts typed prompts and billed responses once each, booked on the day each arrived", {
  "name": record["name"],
  "counts": {key: record[key] for key in ("ready", "hasPromptStats", "todayPrompts", "todaySessions", "todayTotalTokens", "totalPrompts", "totalSessions", "activeDays")},
  "two days ago": next(day["messageCount"] for day in record["recentDays"] if day["date"] == two_days_ago),
}, {
  "name": "Qwen Code",
  "counts": {"ready": True, "hasPromptStats": True, "todayPrompts": 2, "todaySessions": 1, "todayTotalTokens": 1635, "totalPrompts": 3, "totalSessions": 2, "activeDays": 2},
  "two days ago": 77,
}, record)
expect("Qwen reads tokens the way Qwen Code's own statistics do", record["modelUsage"], {
  "qwen3-coder-plus": {"inputTokens": 470, "outputTokens": 212, "cacheReadInputTokens": 680, "cacheCreationInputTokens": 0},
  "gemini-2.5-pro": {"inputTokens": 300, "outputTokens": 50, "cacheReadInputTokens": 0, "cacheCreationInputTokens": 0},
}, record)

# --------------------------------------------------------- untrusted fields

sandbox()
transcript(chats() / "s.jsonl", [
  prompt("bad1", "s", "yesterday-ish"),
  prompt("bad2", "s", "2999-01-01T00:00:00Z"),
  response("bad3", "s", NOW, "m", "openai", "100", True, float("nan"), -5, "a"),
  response("bad4", "s", NOW, "m", "openai", 1e30, 0, 0, 0, "b"),
  response("ok1", "s", NOW, "m", "openai", 10, 2, 0, 0, "c"),
])
with (chats() / "s.jsonl").open("a") as torn:
  torn.write('{"uuid":"z","type":"user","timestamp":')
record = qwen()
expect("Qwen skips bad times, bad token fields, and a torn last line", [record["todayPrompts"], record["todayTotalTokens"]], [0, 12], record)

# ---------------------------------------------------------------- locations

sandbox()
transcript(home() / "runtime" / "projects" / "p" / "chats" / "s.jsonl", [response("a", "s", NOW, "m", "openai", 1, 0, 0, 0, "ra")])
transcript(home() / "qhome" / "projects" / "p" / "chats" / "s.jsonl", [response("b", "s", NOW, "m", "openai", 10, 0, 0, 0, "rb")])
transcript(chats() / "s.jsonl", [response("c", "s", NOW, "m", "openai", 100, 0, 0, 0, "rc")])
os.environ.update(QWEN_HOME=str(home() / "qhome"), QWEN_RUNTIME_DIR=str(home() / "runtime"))
record = qwen()
del os.environ["QWEN_HOME"], os.environ["QWEN_RUNTIME_DIR"]
expect("Qwen honors QWEN_HOME and QWEN_RUNTIME_DIR", record["todayTotalTokens"], 11, record)

write_json(home() / ".qwen" / "settings.json", {"advanced": {"runtimeOutputDir": "~/out"}})
transcript(home() / "out" / "projects" / "p" / "chats" / "s.jsonl", [response("d", "s", NOW, "m", "openai", 1000, 0, 0, 0, "rd")])
record = qwen()
expect("Qwen reads the runtimeOutputDir from settings.json", record["todayTotalTokens"], 1100, record)

# ---------------------------------------------------------------- contract

sandbox()


def add_response():
  add_response.count = getattr(add_response, "count", 0) + 1
  transcript(chats() / "s.jsonl", [response(f"g{add_response.count}", "s", iso_in(0), "m", "openai", 5, 0, 0, 0, f"rg{add_response.count}")], mode="a")


check_scan_cache(Adapter("qwen", grow=add_response))

# The transcript index reads only what was appended, and starts over when the
# file is replaced, even by a longer one.
others = qwen()["todayTotalTokens"]
transcript(chats() / "t.jsonl", [response("a", "t", NOW, "m", "openai", 10, 0, 0, 0, "ra"), response("b", "t", NOW, "m", "openai", 5, 0, 0, 0, "rb")])
expect("Qwen reads a new transcript", qwen()["todayTotalTokens"] - others, 15)
transcript(chats() / "t.jsonl", [response("c", "t", NOW, "m", "openai", 20, 0, 0, 0, "rc")], mode="a")
expect("Qwen picks up lines appended to a transcript", qwen()["todayTotalTokens"] - others, 35)
replacement = transcript(chats() / "t.new", [response(name, "t", NOW, "m", "openai", tokens, 0, 0, 0, f"r{name}") for name, tokens in zip("defg", (1, 2, 3, 4))])
replacement.rename(chats() / "t.jsonl")
expect("Qwen rereads a transcript that was replaced", qwen()["todayTotalTokens"] - others, 10)

# A scan that couldn't read every transcript isn't cached.
transcript(chats() / "s.jsonl", [response("h", "s", NOW, "m", "openai", 5, 0, 0, 0, "rh")], mode="a")
(chats() / "s.jsonl").chmod(0)
try:
  if os.access(chats() / "s.jsonl", os.R_OK):
    print("ok - Qwen does not cache a scan that could not read every transcript # SKIP running as root")
  else:
    for path in scan_cache_files("qwen"):
      path.unlink()
    with contextlib.redirect_stderr(io.StringIO()):
      qwen()
    check("Qwen does not cache a scan that could not read every transcript", not scan_cache_files("qwen"),
          ", ".join(path.name for path in scan_cache_files("qwen")))
finally:
  (chats() / "s.jsonl").chmod(0o644)
PY
