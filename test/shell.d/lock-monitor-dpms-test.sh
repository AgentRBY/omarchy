#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

TMPDIR=""
QS_PID=""

cleanup() {
  if [[ -n $QS_PID ]] && kill -0 "$QS_PID" 2>/dev/null; then
    kill "$QS_PID" 2>/dev/null || true
    wait "$QS_PID" 2>/dev/null || true
  fi
  if [[ -n $TMPDIR && -d $TMPDIR ]]; then
    rm -rf "$TMPDIR"
  fi
}
trap cleanup EXIT

require_compositor "lock monitor DPMS test"
require_command quickshell
require_command jq

TMPDIR=$(mktemp -d)
result="$TMPDIR/result.json"
log="$TMPDIR/quickshell.log"
config_dir="$TMPDIR/lock-monitor-dpms"
stub_bin="$TMPDIR/bin"
home="$TMPDIR/home"
dpms_state="$TMPDIR/dpms"
blank_works="$TMPDIR/blank-works"

mkdir -p "$config_dir" "$stub_bin" "$home/.local/state/omarchy/current"
cp "$SHELL_TEST_DIR/fixtures/lock-monitor-dpms/shell.qml" "$config_dir/shell.qml"
ln -s "$ROOT/shell/Ui" "$config_dir/Ui"
ln -s "$ROOT/shell/Commons" "$config_dir/Commons"

# The wallpaper only has to look like a video; nothing decodes it.
: >"$TMPDIR/wallpaper.mp4"
ln -s "$TMPDIR/wallpaper.mp4" "$home/.local/state/omarchy/current/background"
printf 'on\n' >"$dpms_state"
printf 'yes\n' >"$blank_works"

# Hyprland answers from a state file the brightness stub flips, so the lock
# sees the panel do what it asked, or, with blank-works set to no, refuse.
cat >"$stub_bin/hyprctl" <<EOF
#!/bin/bash
if [[ \$1 == "monitors" ]]; then
  if [[ \$(<"$dpms_state") == "on" ]]; then dpms=true; else dpms=false; fi
  printf '[{"name":"TEST-1","disabled":false,"dpmsStatus":%s}]\n' "\$dpms"
fi
EOF

cat >"$stub_bin/omarchy-brightness-display" <<EOF
#!/bin/bash
if [[ \$1 == "on" ]]; then
  printf 'on\n' >"$dpms_state"
elif [[ \$1 == "off" && \$(<"$blank_works") == "yes" ]]; then
  printf 'off\n' >"$dpms_state"
fi
EOF

cat >"$stub_bin/omarchy-system-wake" <<'EOF'
#!/bin/bash
omarchy-brightness-display on
EOF

for stub in omarchy-brightness-keyboard omarchy-hyprland-session-lock-stranded ffmpegthumbnailer fprintd-list; do
  printf '#!/bin/bash\nexit 1\n' >"$stub_bin/$stub"
done
chmod +x "$stub_bin"/*

OMARCHY_PATH="$ROOT" \
OMARCHY_QML_TEST_RESULT="$result" \
LOCK_TEST_BLANK_WORKS="$blank_works" \
HOME="$home" \
XDG_CONFIG_HOME="$home/.config" \
XDG_CACHE_HOME="$home/.cache" \
XDG_STATE_HOME="$home/.local/state" \
PATH="$stub_bin:$ROOT/bin:$PATH" \
  quickshell -p "$config_dir" --no-color >"$log" 2>&1 &
QS_PID=$!

for _ in {1..300}; do
  [[ -s $result ]] && break
  if ! kill -0 "$QS_PID" 2>/dev/null; then
    sed -n '1,220p' "$log" >&2
    fail "lock monitor DPMS quickshell exited before writing result"
  fi
  sleep 0.1
done

[[ -s $result ]] || {
  sed -n '1,220p' "$log" >&2
  fail "lock monitor DPMS test timed out"
}

if ! jq -e '.ok == true' "$result" >/dev/null; then
  jq . "$result" >&2
  sed -n '1,220p' "$log" >&2
  fail "a locked video wallpaper follows the panels without polling Hyprland"
fi

pass "a locked video wallpaper follows the panels without polling Hyprland"
