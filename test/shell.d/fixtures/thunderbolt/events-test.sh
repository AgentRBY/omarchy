#!/bin/bash

# Exercises the real wake-up plumbing both loops sleep on: a source's lines wake
# a wait, a burst counts once, an ended source is closed, and the watcher's
# inotify filter wakes only for the files a scan reads.
set -euo pipefail
source "$ROOT/test/shell.d/base-test.sh"
source "$ROOT/install/helpers/thunderbolt-policy.sh"
source "$ROOT/install/helpers/thunderbolt-review.sh"

T=$(mktemp -d)
trap 'tb_events_close; rm -rf -- "$T"' EXIT

burst() { printf 'one\ntwo\nthree\n'; sleep 1; printf 'four\n'; exec sleep 60; }
tb_events_open burst
tb_events_wait 5 || fail "a source's lines did not wake the wait"
tb_events_wait 5 || fail "a later line did not wake the wait"
start=$EPOCHREALTIME
if tb_events_wait 1; then fail "a burst woke the wait more than once"; fi
[[ -n $TB_EVENTS ]] || fail "a timeout closed the source"
pid=$TB_EVENTS_PID
tb_events_close
for (( attempt = 0; attempt < 50; attempt++ )); do
  [[ -e /proc/$pid ]] || break
  sleep 0.1
done
[[ ! -e /proc/$pid ]] || fail "closing did not stop the source"
pass "Thunderbolt wake-ups drain a burst and time out"

tb_events_open true
if tb_events_wait 5; then fail "an ended source woke the wait"; fi
[[ -z $TB_EVENTS ]] || fail "an ended source was not closed"
pass "Thunderbolt wake-ups close an ended source"

if ! command -v inotifywait >/dev/null; then
  skip "the watcher's wake-ups need inotifywait"
  exit 0
fi
TB_RUNTIME="$T/runtime" TB_REQUESTS="$T/requests" TB_MARKER="$T/etc/thunderbolt-authorization.enabled"
TB_PENDING="$T/etc/thunderbolt-authorization.pending"
mkdir -p "$TB_RUNTIME" "$TB_REQUESTS" "$T/etc"
woke() {
  sleep 0.3
  "$@"
  tb_events_wait 3
}
tb_events_open tb_watch_events
sleep 0.5
woke : && fail "the watcher woke without a change"
woke cp /dev/null "$TB_RUNTIME/error" && fail "the daemon's error file woke the watcher"
woke cp /dev/null "$TB_REQUESTS/.lock" && fail "the request lock woke the watcher"
woke touch "$T/etc/unrelated" && fail "an unrelated setting woke the watcher"
woke tb_json_write "$TB_RUNTIME/snapshot.json" 644 <<< '{}' || fail "a published snapshot did not wake the watcher"
woke tb_json_write "$TB_REQUESTS/request-a.json" <<< '{}' || fail "a request did not wake the watcher"
woke rm "$TB_REQUESTS/request-a.json" || fail "a removed request did not wake the watcher"
woke touch "$TB_MARKER" || fail "enabling protection did not wake the watcher"
woke touch "$TB_PENDING" || fail "deferring protection did not wake the watcher"
woke rm -r "$TB_RUNTIME" || fail "the daemon stopping did not wake the watcher"
tb_events_close
pass "Thunderbolt watcher wakes only for the files it reads"
