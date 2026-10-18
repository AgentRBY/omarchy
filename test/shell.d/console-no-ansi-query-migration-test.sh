#!/bin/bash
#
# The migration that puts systemd.tty.term.console=dumb into effect on an
# existing install: the package has already written the parameter into
# omarchy-defaults.conf, so what is left is rebuilding the boot image, once per
# machine, and only where it is needed.

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/base-test.sh"

migration="$ROOT/migrations/1791581004.sh"
test_dir=$(mktemp -d)
trap 'rm -rf "$test_dir"' EXIT
stub_bin="$test_dir/bin"
mkdir -p "$stub_bin"

# sudo just drops the prefix; limine-mkinitcpio records that it ran, and fails
# when told to.
printf '#!/bin/bash\nexec "$@"\n' >"$stub_bin/sudo"
# A rebuild writes the new command line into the boot menu, unless it is the
# kind that builds nothing and still exits 0.
cat >"$stub_bin/limine-mkinitcpio" <<'STUB'
#!/bin/bash
echo rebuilt >>"${REBUILDS:?}"
[[ -z ${REBUILD_FAILS:-} ]] || exit 1
[[ -n ${REBUILD_BUILDS_NOTHING:-} ]] || printf '  cmdline: %s\n' "${NEW_CMDLINE:?}" >"${LIMINE_CONF:?}"
STUB
# limine-entry-tool answers with the command line limine would build, which a
# case can set to one without the parameter or to a usage text; pacman names
# the kernel package that owns a modules directory.
cat >"$stub_bin/limine-entry-tool" <<'STUB'
#!/bin/bash
[[ $1 == --get-cmdline ]] || exit 1
echo get-cmdline >>"${QUERIES:?}"
printf '%s\n' "${LIMINE_CMDLINE:-${NEW_CMDLINE:?}}"
STUB
printf '#!/bin/bash\n[[ $1 == -Qqo ]] && echo linux-omarchy\n' >"$stub_bin/pacman"
chmod +x "$stub_bin"/*
mkdir -p "$test_dir/modules/7.2.8-9-omarchy"
: >"$test_dir/modules/7.2.8-9-omarchy/modules.builtin"

old_cmdline="root=PARTUUID=1 rw quiet splash initramfs_async=0"
new_cmdline="$old_cmdline systemd.tty.term.console=dumb"

run() { # booted cmdline, defaults conf
  : >"$test_dir/rebuilds"
  printf '%s\n' "$1" >"$test_dir/cmdline"
  printf '  cmdline: %s\n' "$1" >"$test_dir/limine.conf"
  PATH="$stub_bin:$ROOT/bin:$PATH" REBUILDS="$test_dir/rebuilds" \
    LIMINE_CONF="$test_dir/limine.conf" NEW_CMDLINE="$new_cmdline" OMARCHY_LIMINE_CONF="$test_dir/limine.conf" \
    QUERIES="$test_dir/queries" OMARCHY_KERNEL_MODULES_DIR="$test_dir/modules" \
    OMARCHY_RUNNING_CMDLINE="$test_dir/cmdline" OMARCHY_LIMINE_DEFAULTS_CONF="$2" \
    OMARCHY_LIMINE_REBUILD_MARKER="$test_dir/marker" bash -euo pipefail "$migration" >/dev/null
}
rebuilds() { wc -l <"$test_dir/rebuilds"; }

# omarchy-migrate runs a migration with bash -euo pipefail, and so does run:
# that is what stops a failed rebuild before the marker is written.
if REBUILD_FAILS=1 run "$old_cmdline" "$ROOT/etc/limine-entry-tool.d/omarchy-defaults.conf"; then
  fail "a rebuild that failed was reported as a success"
fi
[[ $(rebuilds) == 1 && ! -e $test_dir/marker ]] || fail "a failed rebuild was marked as done"
pass "a rebuild that fails stops the migration and leaves no marker"

# limine-mkinitcpio exits 0 past a kernel it could not build.
if REBUILD_BUILDS_NOTHING=1 run "$old_cmdline" "$ROOT/etc/limine-entry-tool.d/omarchy-defaults.conf"; then
  fail "a rebuild that changed nothing was reported as a success"
fi
[[ ! -e $test_dir/marker ]] || fail "a rebuild that changed nothing was marked as done"
pass "a rebuild that exits 0 without changing the boot menu leaves the migration pending"

run "$old_cmdline" "$ROOT/etc/limine-entry-tool.d/omarchy-defaults.conf"
[[ $(rebuilds) == 1 && -e $test_dir/marker ]] ||
  fail "a machine booted without the parameter did not get its boot image rebuilt"
pass "the next run rebuilds the boot image, with the packaged defaults, and marks it"

run "$old_cmdline" "$ROOT/etc/limine-entry-tool.d/omarchy-defaults.conf"
[[ $(rebuilds) == 0 ]] || fail "the rebuild ran a second time before a reboot"
pass "the rebuild runs once per machine, not once per user"

rm -f "$test_dir/marker"
run "$new_cmdline" "$ROOT/etc/limine-entry-tool.d/omarchy-defaults.conf"
[[ $(rebuilds) == 0 && ! -e $test_dir/marker ]] || fail "a machine that already boots with the parameter was rebuilt"
pass "a machine that already boots with the parameter is left alone"

grep -v "tty.term.console" "$ROOT/etc/limine-entry-tool.d/omarchy-defaults.conf" >"$test_dir/edited.conf"
run "$old_cmdline" "$test_dir/edited.conf"
[[ $(rebuilds) == 0 ]] || fail "a machine whose defaults leave the parameter out was rebuilt anyway"
pass "a machine whose defaults were edited to leave the parameter out is left alone"

# A plain KERNEL_CMDLINE in /etc/default/limine, which limine reads last,
# replaces the drop-in (installs from before 3.5, Apple Silicon Macs), and a
# kernel's own KERNEL_CMDLINE[<kernel>] can too. limine then builds every
# kernel without the parameter, so nothing is rebuilt and the update goes on.
LIMINE_CMDLINE="$old_cmdline" run "$old_cmdline" "$ROOT/etc/limine-entry-tool.d/omarchy-defaults.conf" ||
  fail "a machine whose limine configuration leaves the parameter out failed the migration"
[[ $(rebuilds) == 0 ]] || fail "a machine whose limine configuration leaves the parameter out was rebuilt anyway"
pass "a machine whose limine configuration replaces the drop-in is left alone, and its update goes on"

# A parameter limine would build keeps the rebuild and its check, and so does
# an answer that isn't a command line.
for answer in "$old_cmdline	systemd.tty.term.console=dumb" "Usage: limine-entry-tool [options]"; do
  rm -f "$test_dir/marker"
  LIMINE_CMDLINE=$(printf '%b' "$answer") run "$old_cmdline" "$ROOT/etc/limine-entry-tool.d/omarchy-defaults.conf"
  [[ $(rebuilds) == 1 && -e $test_dir/marker ]] || fail "an answer of '$answer' did not rebuild and mark"
done
pass "a configuration limine builds the parameter from, or an unclear answer, still rebuilds"
rm -f "$test_dir/marker"

# A refused sudo stays pending.
printf '#!/bin/bash\nexit 1\n' >"$stub_bin/sudo"
if run "$old_cmdline" "$ROOT/etc/limine-entry-tool.d/omarchy-defaults.conf"; then
  fail "a refused sudo let the migration finish"
fi
[[ $(rebuilds) == 0 && ! -e $test_dir/marker ]] || fail "a refused sudo rebuilt or marked the machine"
pass "a refused sudo leaves the migration pending"
printf '#!/bin/bash\nexec "$@"\n' >"$stub_bin/sudo"

# No Limine: the stand-in goes, and the PATH holds only what the migration
# needs, so a limine-mkinitcpio installed on the machine running this test is
# not found either.
rm "$stub_bin/limine-mkinitcpio"
mkdir -p "$test_dir/tools"
for tool in bash grep install cat sed tail; do ln -s "$(command -v "$tool")" "$test_dir/tools/$tool"; done
: >"$test_dir/rebuilds"
printf '%s\n' "$old_cmdline" >"$test_dir/cmdline"
PATH="$stub_bin:$ROOT/bin:$test_dir/tools" REBUILDS="$test_dir/rebuilds" \
  OMARCHY_RUNNING_CMDLINE="$test_dir/cmdline" OMARCHY_LIMINE_DEFAULTS_CONF="$ROOT/etc/limine-entry-tool.d/omarchy-defaults.conf" \
  OMARCHY_LIMINE_REBUILD_MARKER="$test_dir/marker" "$test_dir/tools/bash" -euo pipefail "$migration" >/dev/null
[[ ! -e $test_dir/marker ]] || fail "a machine without Limine was marked as rebuilt"
pass "a machine without Limine is left alone"
