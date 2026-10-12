#!/bin/bash

# Hyprland raises no event when a keyboard arrives or leaves, so the shell
# learns of it from /dev/input instead: one change signal per device, however
# many nodes it brings, and none while nothing changes. The keyboard layout
# widget reads the seat again on that signal rather than asking on a timer.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"
require_compositor "input device change signal"
require_command quickshell
require_command inotifywait

stage=$(mktemp -d)
QS_PID=""
cleanup() {
  if [[ -n $QS_PID ]]; then
    pkill -P "$QS_PID" 2>/dev/null || true
    kill "$QS_PID" 2>/dev/null || true
    wait "$QS_PID" 2>/dev/null || true
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

# A keyboard arrives as an event node and its handler links in one burst.
touch "$stage/root/dev/input/event40" "$stage/root/dev/input/event41"
mkdir "$stage/root/dev/input/js9"
sleep 1.5
(( $(changes) == 1 )) || fail "a device arriving raises one change signal" "$(cat "$stage/log")"
pass "a device arriving raises one change signal"

rm -rf "$stage/root/dev/input/event40" "$stage/root/dev/input/event41" "$stage/root/dev/input/js9"
sleep 1.5
(( $(changes) == 2 )) || fail "a device leaving raises one change signal" "$(cat "$stage/log")"
pass "a device leaving raises one change signal"
