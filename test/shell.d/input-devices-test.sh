#!/bin/bash

# Hyprland raises no event when a keyboard arrives or leaves, so the shell
# learns of it from /dev/input instead: a change signal once a device's burst of
# nodes settles and one more a few seconds on, for a device udev is slow to
# finish with, and none while nothing changes. The keyboard layout
# widget reads the seat again on that signal rather than asking on a timer.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"
require_compositor "input device change signal"
require_command quickshell
require_command inotifywait

stage=$(mktemp -d)
QS_PID=""
# Quickshell restarts a watcher killed under it, and leaves one running when it
# is stopped itself, so stop the shell first and then what it had started.
cleanup() {
  local children=()

  if [[ -n $QS_PID ]]; then
    mapfile -t children < <(pgrep -P "$QS_PID" 2>/dev/null || true)
    kill "$QS_PID" 2>/dev/null || true
    for _ in {1..30}; do
      kill -0 "$QS_PID" 2>/dev/null || break
      sleep 0.1
    done
    kill -KILL "$QS_PID" 2>/dev/null || true
    wait "$QS_PID" 2>/dev/null || true
    (( ${#children[@]} == 0 )) || kill "${children[@]}" 2>/dev/null || true
  fi
  rm -rf "$stage"
}
trap cleanup EXIT

mkdir -p "$stage/root/dev/input"
ln -s "$ROOT/shell/Commons" "$stage/Commons"
cp "$SHELL_TEST_DIR/fixtures/input-devices/shell.qml" "$stage/shell.qml"

OMARCHY_DEV_ROOT="$stage/root" quickshell -p "$stage" --no-color >"$stage/log" 2>&1 &
QS_PID=$!

watching=0
for _ in {1..100}; do
  if pgrep -P "$QS_PID" -f "inotifywait .*$stage/root/dev/input" >/dev/null; then
    watching=1
    break
  fi
  kill -0 "$QS_PID" 2>/dev/null || fail "the fixture shell starts" "$(cat "$stage/log")"
  sleep 0.1
done
(( watching )) || fail "the shell watches /dev/input" "$(cat "$stage/log")"
# inotifywait reports its watch set up only on stderr, which -q silences.
sleep 0.5

changes() {
  grep -c 'CHANGED' "$stage/log" || true
}

sleep 1
(( $(changes) == 0 )) || fail "a seat that does not change raises no signal" "$(cat "$stage/log")"
pass "a seat that does not change raises no signal"

# A keyboard arrives as an event node and its handler links, closer together
# than the settle delay, so a signal only lands once the last of them has.
touch "$stage/root/dev/input/event40"
sleep 0.3
touch "$stage/root/dev/input/event41"
sleep 0.3
mkdir "$stage/root/dev/input/js9"
sleep 0.3
(( $(changes) == 0 )) || fail "a device's burst of nodes raises nothing until it settles" "$(cat "$stage/log")"
sleep 1.2
(( $(changes) == 1 )) || fail "a device arriving raises one change signal once it settles" "$(cat "$stage/log")"
sleep 2.2
(( $(changes) == 2 )) || fail "a device arriving raises one more change signal a few seconds on" "$(cat "$stage/log")"
pass "a device arriving raises a change signal as it settles and once more after"

rm -rf "$stage/root/dev/input/event40" "$stage/root/dev/input/event41" "$stage/root/dev/input/js9"
sleep 4
(( $(changes) == 4 )) || fail "a device leaving raises the same two change signals" "$(cat "$stage/log")"
pass "a device leaving raises the same two change signals"

# The last device going can take /dev/input with it. A device coming back
# brings a new directory, which has to be watched again.
rm -rf "$stage/root/dev/input"
sleep 4
mkdir "$stage/root/dev/input"
# Past both signals for the directory itself, so only the node can count.
sleep 4.5
before=$(changes)
touch "$stage/root/dev/input/event42"
sleep 1.5
(( $(changes) > before )) || fail "a recreated /dev/input is watched again" "$(cat "$stage/log")"
pass "a recreated /dev/input is watched again"
