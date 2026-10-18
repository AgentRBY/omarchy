echo "Keep the disk passphrase typeable at boot with a non-Latin keyboard layout"

# Since 26.134.222-3, plymouth's install hook bundles /etc/vconsole.conf, and its
# passphrase prompt then types in the first keyboard layout. A layout that cannot
# type Latin letters rejects the right passphrase at every boot (#15802).
# omarchy_hooks.conf now runs omarchy-latin-passphrase after plymouth for those
# layouts, which takes the file back out. The package has written that by the
# time this runs, but the boot image built during the update may still hold the
# file, so it is rebuilt now, before the next boot.

conf="${OMARCHY_VCONSOLE_CONF:-/etc/vconsole.conf}"
plymouth_hook="${OMARCHY_PLYMOUTH_INSTALL_HOOK:-/usr/lib/initcpio/install/plymouth}"
rebuild_marker="${OMARCHY_LIMINE_REBUILD_MARKER:-/var/lib/omarchy/migrations/1792312401}"

omarchy-cmd-present limine-mkinitcpio || exit 0
[[ -f $conf ]] || exit 0

# Keep in sync with the list in etc/mkinitcpio.conf.d/omarchy_hooks.conf.
case $(. "$conf" && echo "${XKBLAYOUT%%,*}") in
  af | am | ara | bd | bg | by | et | ge | gr | il | in | iq | ir | kg | kh | kz | la | lk | mk | mm | mn | mv | np | rs | ru | sy | th | tj | ua) ;;
  *) exit 0 ;;
esac

# An older plymouth leaves the file out by itself; the rebuild that comes with
# its update runs the new hook.
grep -q 'vconsole.conf' "$plymouth_hook" 2>/dev/null || exit 0

# The rebuild is machine-wide, so a marker keeps another user's run of this
# migration from repeating it.
[[ ! -e $rebuild_marker ]] || exit 0

sudo limine-mkinitcpio
sudo install -Dm644 /dev/null "$rebuild_marker"
