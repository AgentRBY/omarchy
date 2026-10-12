#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

# Hyprland announces DPMS changes on no event, so every command that wakes the
# panels directly tells a locked video wallpaper to look again.

work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT
mkdir -p "$work/bin" "$work/home"
calls="$work/calls"

for command in hyprctl omarchy-shell omarchy-notification-send; do
  printf '#!/bin/bash\nprintf "%%s %%s\\n" "%s" "$*" >>"%s"\n' "$command" "$calls" >"$work/bin/$command"
done
printf '#!/bin/bash\necho eDP-1\n' >"$work/bin/omarchy-hyprland-monitor-laptop"
printf '#!/bin/bash\nexit 1\n' >"$work/bin/omarchy-hyprland-toggle-enabled"
chmod +x "$work/bin"/*

: >"$calls"
HOME="$work/home" PATH="$work/bin:$ROOT/bin:$PATH" "$ROOT/bin/omarchy-hyprland-monitor-internal" on

grep -q '^hyprctl dispatch .*action = "enable"' "$calls" || fail "the laptop display wakes" "$(<"$calls")"
dispatch_line=$(grep -n '^hyprctl dispatch' "$calls" | cut -d: -f1)
refresh_line=$(grep -nx 'omarchy-shell -q lock refreshDisplays' "$calls" | cut -d: -f1)
[[ -n $refresh_line ]] && (( refresh_line > dispatch_line )) || fail "waking the laptop display tells the lock afterwards" "$(<"$calls")"
pass "waking the laptop display tells the lock afterwards"
