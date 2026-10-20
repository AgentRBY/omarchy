#!/bin/bash

set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
export HOME=$work/home OMARCHY_PATH=$ROOT RESTART_LOG=$work/restarts
mkdir -p "$work/stubs" "$HOME/.config/alacritty"
printf '#!/bin/bash\necho "Maple Mono NF CN:style=Regular"\necho "JetBrainsMono Nerd Font:style=Regular"\n' >"$work/stubs/fc-list"
printf '#!/bin/bash\necho restart >>"$RESTART_LOG"\n' >"$work/stubs/omarchy-restart-shell"
for command in omarchy-hook omarchy-notification-send pkill; do
  printf '#!/bin/bash\n' >"$work/stubs/$command"
done
printf '#!/bin/bash\nexit 1\n' >"$work/stubs/pgrep"
chmod +x "$work/stubs/"*
export PATH="$work/stubs:$ROOT/bin:$PATH"
fontconfig=$HOME/.config/fontconfig/fonts.conf
alacritty=$HOME/.config/alacritty/alacritty.toml
printf 'normal = { family = "JetBrainsMono Nerd Font", style = "Regular" }\n' >"$alacritty"

omarchy-font-set --seed "Maple Mono NF CN"
grep -q '<string>Maple Mono NF CN</string>' "$fontconfig" || fail "a seed sets the font for someone still on the default"
grep -q 'family = "Maple Mono NF CN"' "$alacritty" || fail "a seed reaches the terminals"
[[ ! -e $RESTART_LOG ]] || fail "a seed leaves the shell restart to its caller"
pass "a seed sets the font everywhere without restarting the shell"

omarchy-font-set "JetBrainsMono Nerd Font"
[[ $(cat "$RESTART_LOG") == "restart" ]] || fail "choosing a font restarts the shell"
omarchy-font-set --seed "Maple Mono NF CN"
grep -q '<string>JetBrainsMono Nerd Font</string>' "$fontconfig" || fail "a seed keeps a chosen font" "$(cat "$fontconfig")"
grep -q 'family = "JetBrainsMono Nerd Font"' "$alacritty" || fail "a seed leaves the terminals of a chosen font alone"
pass "a seed never replaces a font the user chose"

rm "$fontconfig"
if omarchy-font-set --seed "Missing Font" >/dev/null; then
  fail "a font that is not installed is refused"
fi
[[ ! -e $fontconfig ]] || fail "a refused font writes nothing"
pass "a font that is not installed is refused"
