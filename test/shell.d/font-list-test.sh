#!/bin/bash

set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/stubs"

# fontconfig answers by spacing: 100 for single-width monospace, 90 for dual
# width, where CJK glyphs take two cells. Maple Mono NF CN reports 90.
cat >"$work/stubs/fc-list" <<'SH'
#!/bin/bash
case $1 in
:spacing=100) printf '%s\n' "JetBrainsMono Nerd Font" "Noto Color Emoji" "Omarchy" "Liberation Mono" ;;
:spacing=90) printf '%s\n' "Maple Mono NF CN" "Maple Mono NF CN" ;;
esac
SH
chmod +x "$work/stubs/fc-list"

fonts=$(PATH="$work/stubs:$PATH" "$ROOT/bin/omarchy-font-list")
expected=$'JetBrainsMono Nerd Font\nLiberation Mono\nMaple Mono NF CN'
[[ $fonts == "$expected" ]] || fail "the font list offers single and dual width monospace fonts once each" "$fonts"
pass "the font list offers single and dual width monospace fonts once each"

grep -qx 'maplemono-nf-cn' "$ROOT/install/omarchy-base.packages" || fail "Maple Mono NF CN is installed by default"
grep -lx 'omarchy-pkg-add maplemono-nf-cn' "$ROOT"/migrations/*.sh >/dev/null || fail "existing installs get Maple Mono NF CN"
pass "Maple Mono NF CN is installed on new and existing installs"
