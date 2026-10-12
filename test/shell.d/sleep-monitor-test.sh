#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

sleep_monitor="$ROOT/bin/omarchy-system-sleep-monitor"
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

mock_bin="$tmpdir/bin"
mock_omarchy="$tmpdir/omarchy"
producer_pid_file="$tmpdir/producer-pid"
lock_log="$tmpdir/lock-log"
mkdir -p "$mock_bin" "$mock_omarchy/bin"

cat >"$mock_bin/systemd-inhibit" <<'SH'
#!/bin/bash

while [[ $1 == --* ]]; do
  shift
done

exec "$@"
SH

cat >"$mock_bin/dbus-monitor" <<'SH'
#!/bin/bash

echo "$$" >"$PRODUCER_PID_FILE"
printf '   boolean true\n'
exec sleep 30
SH

# Never arm a real timer on the machine running the suite.
cat >"$mock_bin/systemd-run" <<'SH'
#!/bin/bash

printf '%s\n' "$*" >>"${RUN_LOG:-/dev/null}"
SH

cat >"$mock_omarchy/bin/omarchy-system-sleep-lock" <<'SH'
#!/bin/bash

echo locked >>"$LOCK_LOG"
SH

chmod +x \
  "$mock_bin/systemd-inhibit" \
  "$mock_bin/systemd-run" \
  "$mock_bin/dbus-monitor" \
  "$mock_omarchy/bin/omarchy-system-sleep-lock"
ln -s "$sleep_monitor" "$mock_omarchy/bin/omarchy-system-sleep-monitor"

start_us=${EPOCHREALTIME//[!0-9]/}
OMARCHY_PATH="$mock_omarchy" \
  PATH="$mock_bin:$PATH" \
  PRODUCER_PID_FILE="$producer_pid_file" \
  LOCK_LOG="$lock_log" \
  "$sleep_monitor"
elapsed_us=$((10#${EPOCHREALTIME//[!0-9]/} - 10#$start_us))

[[ $(<"$lock_log") == "locked" ]] ||
  fail "sleep monitor invokes the lock helper for a sleep event"
pass "sleep monitor invokes the lock helper for a sleep event"

(( elapsed_us < 2000000 )) ||
  fail "sleep monitor releases the inhibitor after locking" "elapsed: ${elapsed_us}us"
pass "sleep monitor releases the inhibitor after locking"

producer_pid=$(<"$producer_pid_file")
if kill -0 "$producer_pid" 2>/dev/null; then
  fail "sleep monitor reaps its event producer" "producer still running: $producer_pid"
fi
pass "sleep monitor reaps its event producer"

# Terminating the monitor must also clean up the producer instead of orphaning
# it under the user systemd instance.
cat >"$mock_bin/dbus-monitor" <<'SH'
#!/bin/bash

sleep 0.1
echo "$$" >"$PRODUCER_PID_FILE"
exec sleep 30
SH
chmod +x "$mock_bin/dbus-monitor"
rm -f "$producer_pid_file"

OMARCHY_PATH="$mock_omarchy" \
  PATH="$mock_bin:$PATH" \
  PRODUCER_PID_FILE="$producer_pid_file" \
  LOCK_LOG="$lock_log" \
  "$sleep_monitor" &
monitor_pid=$!

for _ in {1..100}; do
  [[ -s $producer_pid_file ]] && break
  sleep 0.01
done
if [[ ! -s $producer_pid_file ]]; then
  kill "$monitor_pid" 2>/dev/null || true
  wait "$monitor_pid" 2>/dev/null || true
  fail "sleep monitor starts its event producer"
fi

producer_pid=$(<"$producer_pid_file")
kill "$monitor_pid"
wait "$monitor_pid" 2>/dev/null || true

if kill -0 "$producer_pid" 2>/dev/null; then
  kill "$producer_pid" 2>/dev/null || true
  fail "sleep monitor cleans up its producer when terminated" "producer still running: $producer_pid"
fi
pass "sleep monitor cleans up its producer when terminated"

# A resume can light the panels behind the lock with nothing the lock hears.
# The monitor exits to release the inhibitor, so a sleep starts a watcher of
# its own outside the service, which waits for the wake and asks the lock.
cat >"$mock_bin/dbus-monitor" <<'SH'
#!/bin/bash

# The bus's greeting comes first, once the match rules are in place.
printf 'signal sender=org.freedesktop.DBus member=NameAcquired\n'
printf '   boolean %s\n' "${SLEEP_SIGNAL:-true}"
exec sleep 30
SH
cat >"$mock_bin/systemd-notify" <<'SH'
#!/bin/bash

printf 'systemd-notify %s\n' "$*" >>"$SHELL_LOG"
SH
cat >"$mock_omarchy/bin/omarchy-shell" <<'SH'
#!/bin/bash

printf 'omarchy-shell %s\n' "$*" >>"$SHELL_LOG"
SH
chmod +x "$mock_bin/dbus-monitor" "$mock_bin/systemd-notify" "$mock_omarchy/bin/omarchy-shell"
run_log="$tmpdir/run-log"
shell_log="$tmpdir/shell-log"
: >"$lock_log"

OMARCHY_PATH="$mock_omarchy" \
  PATH="$mock_bin:$PATH" \
  LOCK_LOG="$lock_log" \
  RUN_LOG="$run_log" \
  SHELL_LOG="$shell_log" \
  "$sleep_monitor"

[[ $(<"$lock_log") == "locked" ]] || fail "the sleep still locks before starting the resume watcher"
[[ $(<"$run_log") == "--user --quiet --collect --property=Type=notify --property=NotifyAccess=all --property=RuntimeMaxSec=1d $mock_omarchy/bin/omarchy-system-sleep-monitor --resume" ]] ||
  fail "a sleep starts a resume watcher outside the service and waits for it to listen" "$(cat "$run_log" 2>/dev/null)"
[[ ! -e $shell_log ]] || fail "the sleep itself does not ask the lock" "$(<"$shell_log")"
pass "a sleep starts a resume watcher outside the service and waits for it to listen"

SLEEP_SIGNAL=false \
  OMARCHY_PATH="$mock_omarchy" \
  PATH="$mock_bin:$PATH" \
  SHELL_LOG="$shell_log" \
  timeout 5 "$sleep_monitor" --resume || fail "the resume watcher exits once the machine wakes"
[[ $(<"$shell_log") == $'systemd-notify --ready\nomarchy-shell -q lock refreshDisplays' ]] ||
  fail "the resume watcher reports it is listening, then asks the lock once the machine wakes" "$(cat "$shell_log" 2>/dev/null)"
pass "the resume watcher reports it is listening, then asks the lock once the machine wakes"
