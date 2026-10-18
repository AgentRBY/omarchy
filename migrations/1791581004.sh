echo "Stop the boot from waiting on a black screen for the console to answer"

# systemd asks the console for its size when PID 1 starts and waits for the
# reply. With Plymouth holding the screen the reply sometimes never comes, and
# about 1 boot in 10 sits on a black screen until a key is pressed.
# omarchy-defaults.conf now carries systemd.tty.term.console=dumb, which makes
# systemd skip the query. The package has already written that file by the
# time this runs; the boot image still holds the old command line until it is
# rebuilt.

defaults_conf="${OMARCHY_LIMINE_DEFAULTS_CONF:-/etc/limine-entry-tool.d/omarchy-defaults.conf}"
running_cmdline="${OMARCHY_RUNNING_CMDLINE:-/proc/cmdline}"
rebuild_marker="${OMARCHY_LIMINE_REBUILD_MARKER:-/var/lib/omarchy/migrations/1791581004}"
param="systemd.tty.term.console=dumb"

omarchy-cmd-present limine-mkinitcpio || exit 0
[[ -f $defaults_conf && -r $running_cmdline ]] || exit 0

# The running kernel keeps its old command line until reboot, so a marker
# records the machine-wide rebuild: another user's migration must not repeat
# it before then, while a missing marker still retries an interrupted rebuild.
[[ ! -e $rebuild_marker ]] || exit 0

# A machine that boots with it already, or whose defaults were edited to leave
# it out, has nothing to rebuild.
[[ " $(<"$running_cmdline") " != *" $param "* ]] || exit 0
grep -Eq "^KERNEL_CMDLINE\[default\]\+=\".*${param//./\\.}.*\"" "$defaults_conf" || exit 0

# Nor does one whose own limine configuration leaves it out of every kernel's
# command line. A plain KERNEL_CMDLINE in /etc/default/limine, which limine
# reads last, replaces the drop-in: installs from before 3.5 and Apple Silicon
# Macs have one, and so may a kernel's own KERNEL_CMDLINE[<kernel>]. No rebuild
# can add the parameter there, and the check after it would stop every update.
# limine-entry-tool merges those layers itself, so ask it for each kernel
# limine-mkinitcpio builds. An answer that isn't a command line, a usage text
# from another version for one, counts as having it, so the rebuild and its
# check go ahead as before. A fallback entry, built only where
# MKINITCPIO_FALLBACK asks for one, isn't asked about: skipping it only delays
# the parameter until the next kernel update rebuilds every entry, while
# rebuilding for one that isn't built would stop every update.
modules_dir="${OMARCHY_KERNEL_MODULES_DIR:-/usr/lib/modules}"
kernels=0 configured=0
for builtin in "$modules_dir"/*/modules.builtin; do
  [[ -f $builtin ]] || continue
  kernel=$(pacman -Qqo "$builtin" 2>/dev/null) || continue
  kernels=$((kernels + 1))
  answer=$(sudo limine-entry-tool --get-cmdline "$kernel" --no-mutex --no-hooks)
  if [[ $answer == *Usage:* || " $(tail -n 1 <<<"$answer") " =~ [[:space:]]${param//./\\.}[[:space:]] ]]; then
    configured=1
  fi
done
if ((kernels > 0 && configured == 0)); then
  echo "This machine's limine configuration leaves $param out of its kernel command lines; nothing to rebuild"
  exit 0
fi

echo "The booted kernel is missing $param; rebuilding the boot image"
sudo limine-mkinitcpio

# The boot menu is on the ESP, which /etc/default/limine names; /boot when it
# does not, or is not there.
limine_conf="${OMARCHY_LIMINE_CONF:-}"
if [[ -z $limine_conf ]]; then
  esp=""
  if [[ -r /etc/default/limine ]]; then
    esp=$(sed -n 's/^ESP_PATH=["'\'']\?\([^"'\'']*\).*/\1/p' /etc/default/limine | tail -n 1)
  fi
  limine_conf="${esp:-/boot}/limine.conf"
fi

# limine-mkinitcpio carries on past a kernel it could not build, a full boot
# partition for one, and still exits 0. Done means a boot entry has the
# parameter: without that the migration stays pending and the next update
# tries again. A menu with no command lines in it (they are inside the boot
# images then) has nothing to look at, and is taken at its word.
if sudo grep -Eq '^[[:space:]]*cmdline:' "$limine_conf" 2>/dev/null &&
  ! sudo grep -Eq "^[[:space:]]*cmdline:.*[[:space:]]${param//./\\.}([[:space:]]|\$)" "$limine_conf"; then
  echo "The boot menu still has no entry with $param after the rebuild" >&2
  exit 1
fi

sudo install -Dm644 /dev/null "$rebuild_marker"
