#!/bin/bash

# An idle shell must not start processes. The shell runs all day, once per
# session, and a Timer that starts a Process costs that process every tick for
# as long as the machine is up (see "Keeping state current without polling" in
# agents/skills/shell-dev.md). This starts a second shell on the default config,
# lets its startup work finish, then watches it sit idle and fails naming every
# command it ran.
#
# Spawns are logged from inside the shell: a preloaded shim records every exec
# the shell or any of its descendants makes, so a probe that lives a few
# milliseconds is caught as surely as a long one, and nothing outside the
# shell's own process tree (this test included) can be mistaken for it.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

# Long enough to catch any poll at 30s or faster, the slowest interval a
# widget has been seen polling at; override to look for slower ones.
IDLE_WINDOW=${OMARCHY_IDLE_SPAWN_WINDOW:-30}

# Commands an idle shell may legitimately run, as extended regexes matched
# against the logged command line. Each one names why it is not polling.
ALLOWED=(
  # wl-paste runs the capture script for each clipboard change, which another
  # program on the desktop can make while the test shell sits idle.
  '/shell/plugins/clipboard/capture\.sh '
  # The keyboard layout widget asks every 10s while the seat has more than one
  # keyboard: Hyprland raises no event when a keyboard arrives or leaves, so
  # which one the label describes can only be learned by asking. A udev input
  # monitor shared by every bar would let it stop.
  '(^|/)hyprctl -j devices$'
  # While a remote session is active its end has to be polled for: Hyprland
  # reports the screencast stopped whenever frames pause, and nothing at all
  # when the server exits.
  '/shell/plugins/services/remote-session/probe\.sh$'
  # A connected Wi-Fi network NetworkManager reports no strength for is read
  # from the access point list instead, which raises no change signal.
  '(^|/)nmcli -t -f IN-USE,SIGNAL device wifi list ifname '
)

TMPDIR=""
QS_PID=""

descendants() {
  local child

  for child in $(cat /proc/"$1"/task/*/children 2>/dev/null); do
    echo "$child"
    descendants "$child"
  done
}

# Quickshell leaves some of its children running when it is stopped, among
# them the inotifywait watching the plugin directory, and one that outlives the
# test holds on to whatever it inherited. Stop everything the test shell
# started: what is still below it, and whatever still carries this run's log
# in its environment, which finds the ones that were reparented.
cleanup() {
  local pid leftovers=()

  if [[ -n $QS_PID ]] && kill -0 "$QS_PID" 2>/dev/null; then
    mapfile -t leftovers < <(descendants "$QS_PID")
    kill "$QS_PID" 2>/dev/null || true
    wait "$QS_PID" 2>/dev/null || true
  fi
  if [[ -f ${exec_log:-} ]]; then
    for pid in $(cut -d' ' -f1 "$exec_log" | sort -u); do
      { tr '\0' '\n' <"/proc/$pid/environ"; } 2>/dev/null | grep -qxF "OMARCHY_EXEC_LOG=$exec_log" && leftovers+=("$pid")
    done
  fi
  (( ${#leftovers[@]} == 0 )) || kill "${leftovers[@]}" 2>/dev/null || true
  [[ -n ${test_root:-} ]] && rm -f "$(shell_ipc_socket "$test_root")"
  [[ -n $TMPDIR && -d $TMPDIR ]] && rm -rf "$TMPDIR"
  return 0
}
trap cleanup EXIT

require_compositor "idle shell spawn test"

if ! command -v quickshell >/dev/null 2>&1; then
  skip "quickshell not installed; skipping idle shell spawn test"
  exit 0
fi

if ! command -v cc >/dev/null 2>&1; then
  skip "no C compiler to build the exec logger; skipping idle shell spawn test"
  exit 0
fi

require_command jq

TMPDIR=$(mktemp -d)
test_root="$TMPDIR/omarchy"
test_home="$TMPDIR/home"
stub_bin="$TMPDIR/bin"
log="$TMPDIR/quickshell.log"
exec_log="$TMPDIR/exec.log"
mkdir -p "$test_root" "$test_home" "$stub_bin"

# Nobody touches the seat while the test watches, so a long enough window
# would reach the screensaver and the lock: actions on an event, not polling,
# and run against the session's desktop. Keep the test shell awake.
mkdir -p "$test_home/.local/state/omarchy/indicators"
touch "$test_home/.local/state/omarchy/indicators/stay-awake"

cc -shared -fPIC -O2 -o "$TMPDIR/exec-log.so" "$SHELL_TEST_DIR/fixtures/idle-shell/exec-log.c" -ldl ||
  fail "the exec logger builds"

# A copy, so the test shell gets its own IPC socket and never answers for, or
# replaces, the shell running the session.
cp -a "$ROOT/shell" "$test_root/shell"
ln -s "$ROOT/config" "$test_root/config"
ln -s "$ROOT/bin" "$test_root/bin"
ln -s "$ROOT/default" "$test_root/default"

# Keep startup off the network. These only shape what startup does; a poll
# still shows up as an exec whether or not its command is stubbed.
cat >"$stub_bin/omarchy-update-available" <<'SH'
#!/bin/bash
exit 1
SH
# A weather fetch that fails is retried, so answer it the way wttr.in does.
cat >"$stub_bin/curl" <<'SH'
#!/bin/bash
case "${*: -1}" in
  *'?format=j1') printf '{"current_condition":[{"weatherCode":"113","temp_F":"72"}]}\n' ;;
  *'?format=%l') printf 'Test City, Test Region\n' ;;
  *) exit 1 ;;
esac
SH
# The clipboard plugin clears stale watchers at startup with a pkill that
# matches the session shell's watchers too. Signal nothing from here.
cat >"$stub_bin/pkill" <<'SH'
#!/bin/bash
exit 1
SH
cp "$stub_bin/pkill" "$stub_bin/killall"
chmod +x "$stub_bin/omarchy-update-available" "$stub_bin/curl" "$stub_bin/pkill" "$stub_bin/killall"

fail_with_log() {
  sed -n '1,120p' "$log" >&2
  fail "$@"
}

exec_count() {
  if [[ -f $exec_log ]]; then
    wc -l <"$exec_log"
  else
    echo 0
  fi
}

OMARCHY_PATH="$test_root" \
HOME="$test_home" \
XDG_CONFIG_HOME="$test_home/.config" \
XDG_CACHE_HOME="$test_home/.cache" \
XDG_STATE_HOME="$test_home/.local/state" \
PATH="$stub_bin:$ROOT/bin:$PATH" \
OMARCHY_EXEC_LOG="$exec_log" \
LD_PRELOAD="$TMPDIR/exec-log.so" \
QS_DISABLE_FILE_WATCHER=1 \
QS_NO_RELOAD_POPUP=1 \
  quickshell -p "$test_root/shell" --no-color >"$log" 2>&1 &
QS_PID=$!

ready=0
for _ in {1..150}; do
  if OMARCHY_PATH="$test_root" "$ROOT/bin/omarchy-shell" shell listPlugins 2>/dev/null | jq -e 'length > 0' >/dev/null 2>&1; then
    ready=1
    break
  fi
  kill -0 "$QS_PID" 2>/dev/null || fail_with_log "test shell exited before it became ready"
  sleep 0.1
done
(( ready )) || fail_with_log "test shell answers IPC within 15 seconds"

# Startup runs its one-off probes (hardware, packages, config) for a few seconds
# after IPC answers, and ends by restoring the cursor once the startup cover has
# faded, which waits on the wallpaper. Idle starts once that has happened and
# everything has been quiet for a few seconds. A shell that never goes quiet
# fails below with the commands it kept running.
startup_done() {
  grep -q 'omarchy_startup_cursor_restore' "$exec_log" 2>/dev/null
}

settle_start=$SECONDS
quiet_since=$SECONDS
last=$(exec_count)
while (( SECONDS - settle_start < 40 )); do
  sleep 0.5
  now=$(exec_count)
  if (( now != last )); then
    last=$now
    quiet_since=$SECONDS
  elif (( SECONDS - quiet_since >= 4 )) && { startup_done || (( SECONDS - settle_start >= 20 )); }; then
    break
  fi
done

kill -0 "$QS_PID" 2>/dev/null || fail_with_log "test shell exited during startup"
(( $(exec_count) > 0 )) || fail_with_log "the exec logger records what the shell starts"

start=$(exec_count)
sleep "$IDLE_WINDOW"
kill -0 "$QS_PID" 2>/dev/null || fail_with_log "test shell exited while idle"

# Whatever an allowed command goes on to run is allowed with it, through any
# subshells in between. Ancestry is read from the whole log before anything is
# judged, since a process started before the window can still exec during it,
# and a posix_spawn child is only logged once the spawn returns, which can be
# after its own children.
declare -A parent=() matched=() execed=() running=() forked_from=()
while read -r pid ppid command; do
  [[ -n ${parent[$pid]:-} ]] || parent[$pid]=$ppid
  if [[ -z $command ]]; then
    forked_from[$pid]=${running[$ppid]:-process $ppid}
    continue
  fi
  execed[$pid]=1
  running[$pid]=$command
  for pattern in "${ALLOWED[@]}"; do
    if [[ $command =~ $pattern ]]; then
      matched[$pid]=1
      break
    fi
  done
done <"$exec_log"

allowed() {
  local pid="$1" depth=0

  while [[ -n $pid ]] && (( depth++ < 64 )); do
    [[ -n ${matched[$pid]:-} ]] && return 0
    pid=${parent[$pid]:-}
  done
  return 1
}

declare -A seen=()
unexpected=()
line_number=0
while read -r pid ppid command; do
  line_number=$(( line_number + 1 ))
  (( line_number > start )) || continue
  allowed "$pid" && continue

  if [[ -n $command ]]; then
    # A failed exec attempt is retried down PATH under the same pid and command
    # line, so count each attempt once.
    key="$pid $command"
  elif [[ -z ${execed[$pid]:-} ]]; then
    # A process forked to run only built-ins never execs, but it is a process.
    key="$pid"
    command="(subshell of ${forked_from[$pid]})"
  else
    continue
  fi
  if [[ -z ${seen[$key]:-} ]]; then
    seen[$key]=1
    unexpected+=("$command")
  fi
done <"$exec_log"

if (( ${#unexpected[@]} > 0 )); then
  fail "an idle shell starts no processes" "$(
    printf 'The shell started %d process(es) in %ds of idling:\n' "${#unexpected[@]}" "$IDLE_WINDOW"
    printf '%s\n' "${unexpected[@]}" | sort | uniq -c | sort -rn | sed 's/^/  /' | head -40
    printf 'Poll on an event instead (agents/skills/shell-dev.md), or allowlist it in %s with the reason.\n' "${BASH_SOURCE[0]}"
  )"
fi
pass "an idle shell starts no processes over ${IDLE_WINDOW}s"
