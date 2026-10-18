#!/bin/bash

# A first keyboard layout that cannot type Latin letters must not reach
# Plymouth's passphrase prompt (#15802): omarchy_hooks.conf adds
# omarchy-latin-passphrase after plymouth for such layouts, the hook takes
# /etc/vconsole.conf out of the image, and a migration rebuilds the image once.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

test_tmp=$(mktemp -d)
trap 'rm -rf "$test_tmp"' EXIT

vconsole="$test_tmp/vconsole.conf"
sed "s|/etc/vconsole.conf|$vconsole|g" "$ROOT/etc/mkinitcpio.conf.d/omarchy_hooks.conf" >"$test_tmp/omarchy_hooks.conf"

compose() { # compose <hooks...>: prints the HOOKS and FILES the drop-in leaves
  (
    HOOKS=("$@") MODULES=() FILES=()
    source "$test_tmp/omarchy_hooks.conf"
    printf 'HOOKS=%s\nFILES=%s\n' "${HOOKS[*]}" "${FILES[*]}"
  )
}

x86=(base udev plymouth keyboard autodetect microcode modconf kms keymap consolefont block encrypt filesystems fsck btrfs-overlayfs)
mac=(base systemd plymouth autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)

printf 'KEYMAP=ru\nXKBLAYOUT=ru,us\n' >"$vconsole"
out=$(compose "${x86[@]}")
grep -qx "HOOKS=${x86[*]} omarchy-latin-passphrase" <<<"$out" || fail "a Cyrillic first layout runs the hook last, after plymouth" "$out"
grep -qx "FILES=" <<<"$out" || fail "a Cyrillic first layout bundles no vconsole.conf" "$out"
out=$(compose "${mac[@]}")
grep -qx "HOOKS=${mac[*]}" <<<"$out" || fail "a Mac's sd-vconsole hooks are left alone" "$out"
out=$(compose base udev keyboard autodetect block encrypt filesystems fsck)
grep -qx "HOOKS=base udev keyboard autodetect block encrypt filesystems fsck" <<<"$out" || fail "no plymouth, no hook" "$out"
printf 'KEYMAP=us\nXKBLAYOUT=us\n' >"$vconsole"
out=$(compose "${x86[@]}")
grep -qx "HOOKS=${x86[*]}" <<<"$out" && grep -qx "FILES=$vconsole" <<<"$out" ||
  fail "a Latin layout keeps bundling vconsole.conf for Plymouth" "$out"
printf 'KEYMAP=de\nXKBLAYOUT=de,ru\n' >"$vconsole"
out=$(compose "${x86[@]}")
grep -qx "HOOKS=${x86[*]}" <<<"$out" || fail "only the first layout counts" "$out"
pass "the hook runs after plymouth only for a first layout that cannot type Latin letters"

# The hook itself, the way mkinitcpio runs it: build() with BUILDROOT set.
BUILDROOT="$test_tmp/root"
mkdir -p "$BUILDROOT/etc"
printf 'KEYMAP=ru\n' >"$BUILDROOT/etc/vconsole.conf"
(
  source "$ROOT/etc/initcpio/install/omarchy-latin-passphrase"
  build
  help | grep -q 'US layout'
) || fail "the hook builds and has help"
[[ ! -e $BUILDROOT/etc/vconsole.conf ]] || fail "the hook takes vconsole.conf out of the image"
( source "$ROOT/etc/initcpio/install/omarchy-latin-passphrase"; build ) || fail "the hook is fine with no vconsole.conf in the image"
pass "the hook takes vconsole.conf out of the image"

# The migration rebuilds once, only where it matters.
migration=$(grep -l 'omarchy-latin-passphrase' "$ROOT"/migrations/*.sh)
[[ $(wc -l <<<"$migration") == 1 ]] || fail "one migration rebuilds the image" "$migration"
mock_bin="$test_tmp/bin"
mkdir -p "$mock_bin"
printf '#!/bin/bash\n[[ $1 == limine-mkinitcpio ]]\n' >"$mock_bin/omarchy-cmd-present"
printf '#!/bin/bash\nprintf "%%s\\n" "$*" >>"%s"\n"$@"\n' "$test_tmp/sudo.log" >"$mock_bin/sudo"
printf '#!/bin/bash\n' >"$mock_bin/limine-mkinitcpio"
chmod +x "$mock_bin"/*
plymouth_new="$test_tmp/plymouth-new" plymouth_old="$test_tmp/plymouth-old"
printf 'if [[ -s /etc/vconsole.conf ]]; then add_file /etc/vconsole.conf; fi\n' >"$plymouth_new"
printf 'add_file /usr/share/fonts/Plymouth.ttf\n' >"$plymouth_old"
marker="$test_tmp/marker"
migrate() {
  : >"$test_tmp/sudo.log"
  PATH="$mock_bin:$PATH" OMARCHY_VCONSOLE_CONF="$vconsole" OMARCHY_PLYMOUTH_INSTALL_HOOK="$1" \
    OMARCHY_LIMINE_REBUILD_MARKER="$marker" bash -euo pipefail "$migration" >/dev/null
}
rebuilt() { grep -qx limine-mkinitcpio "$test_tmp/sudo.log"; }

printf 'KEYMAP=ru\nXKBLAYOUT=ru,us\n' >"$vconsole"
migrate "$plymouth_new" || fail "the migration finishes"
rebuilt && [[ -e $marker ]] || fail "a Cyrillic layout with the new plymouth rebuilds the image"
migrate "$plymouth_new" && ! rebuilt || fail "the rebuild happens once per machine"
rm -f "$marker"
migrate "$plymouth_old" && ! rebuilt && [[ ! -e $marker ]] || fail "an older plymouth needs no rebuild yet"
printf 'KEYMAP=us\nXKBLAYOUT=us\n' >"$vconsole"
migrate "$plymouth_new" && ! rebuilt || fail "a Latin layout needs no rebuild"
rm -f "$vconsole"
migrate "$plymouth_new" && ! rebuilt || fail "no vconsole.conf needs no rebuild"
pass "the migration rebuilds the image once, for a non-Latin layout with a plymouth that bundles vconsole.conf"

hooks_layouts=$(awk -F')' '/\) ;;$/ { gsub(/[[:space:]|]+/, "\n", $1); print $1 }' "$ROOT/etc/mkinitcpio.conf.d/omarchy_hooks.conf" | grep '^[a-z]\+$' | sort)
migration_layouts=$(awk -F')' '/\) ;;$/ { gsub(/[[:space:]|]+/, "\n", $1); print $1 }' "$migration" | grep '^[a-z]\+$' | sort)
[[ -n $hooks_layouts && $hooks_layouts == "$migration_layouts" ]] ||
  fail "the migration's layout list stays in sync with omarchy_hooks.conf" "$(diff <(echo "$hooks_layouts") <(echo "$migration_layouts"))"
pass "the migration's non-Latin layouts are the ones omarchy_hooks.conf leaves out"
