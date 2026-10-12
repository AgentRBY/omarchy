echo "Remove approval for new USB and Thunderbolt devices"

# Approval for new accessories (#11874) shipped briefly to edge and dev. The
# package update has already removed its commands, units and Polkit rules; this
# undoes what they left on the machine so devices connect as they did before.

usb_state=$HOME/.local/state/omarchy/usb-authorization
tb_dir=/var/lib/omarchy/thunderbolt-authorization
usb_boot_drop_in=/etc/limine-entry-tool.d/usb-authorization.conf
usbguard_added=1791573373 # when usbguard joined the default packages

# The approval watchers. Their unit files are gone, so systemctl disable can't
# find them; drop the enablement links directly.
for unit in omarchy-usb-authorization.service omarchy-thunderbolt-authorization.service; do
  systemctl --user stop "$unit" 2>/dev/null || true
  rm -f "$HOME"/.config/systemd/user/*.wants/"$unit"
done
rm -f "$HOME/.config/systemd/user/omarchy-usb-authorization.service"
systemctl --user daemon-reload

if [[ -d $tb_dir || -e /etc/omarchy/thunderbolt-authorization.enabled || -e /etc/omarchy/thunderbolt-authorization.pending ]]; then
  sudo systemctl stop omarchy-thunderbolt-authorization.service 2>/dev/null || true
  sudo rm -f /etc/systemd/system/multi-user.target.wants/omarchy-thunderbolt-authorization.service \
    /etc/omarchy/thunderbolt-authorization.enabled /etc/omarchy/thunderbolt-authorization.pending
  sudo systemctl daemon-reload

  state=$(sudo cat "$tb_dir/policy.json" 2>/dev/null || echo '{}')

  bolt_get() {
    sudo busctl --system --json=short get-property org.freedesktop.bolt "/org/freedesktop/bolt/$1/${2//-/_}" "org.freedesktop.bolt1.$3" "$4" 2>/dev/null | jq -r .data
  }

  # Thunderbolt Boot replaced device policies and emptied the firmware boot
  # allowlists; put back what it saved. Accessories and controllers that are
  # no longer known to Bolt have nothing to restore.
  while read -r uid policy; do
    if [[ -n $(bolt_get devices "$uid" Device Policy) ]]; then
      sudo boltctl config device.policy "$uid" "$policy"
    fi
  done < <(jq -r '.boot_original.policies // {} | to_entries[] | "\(.key) \(.value)"' <<<"$state")
  while read -r uid; do
    if [[ -n $(bolt_get domains "$uid" Domain BootACL) ]]; then
      mapfile -t acl < <(jq -r --arg uid "$uid" '.boot_original.acls[$uid][]' <<<"$state")
      sudo busctl --system set-property org.freedesktop.bolt "/org/freedesktop/bolt/domains/${uid//-/_}" \
        org.freedesktop.bolt1.Domain BootACL as "${#acl[@]}" "${acl[@]}"
    else
      echo "Thunderbolt controller $uid is not connected; its firmware boot allowlist stays as it is."
    fi
  done < <(jq -r '.boot_original.acls // {} | keys[]' <<<"$state")

  # Accessories approved here were stored with Bolt's manual policy, which
  # Bolt won't authorize on its own. Hand back the ones Omarchy stored, as the
  # removal command did, never a manual policy somebody else set.
  while read -r uid store_time; do
    if [[ $(bolt_get devices "$uid" Device Policy) == "manual" && $(bolt_get devices "$uid" Device StoreTime) == "$store_time" ]]; then
      sudo boltctl config device.policy "$uid" auto
    fi
  done < <(jq -r '(.trusted // {}) as $trusted | .enrolled // {} | to_entries[] | select($trusted[.key]) | "\(.key) \(.value.StoreTime)"' <<<"$state")

  sudo boltctl config global.auth-mode "$(jq -r '.original_authmode // "enabled"' <<<"$state")"
  sudo rm -rf "$tb_dir" /run/omarchy-thunderbolt-authorization
fi

# The opt-in USB at Boot setting: usbcore.authorized_default=0 on the kernel
# command line, for new boot entries and new snapshots.
if [[ -e $usb_boot_drop_in ]] || grep -Fqx '# Omarchy USB authorization begin' /etc/default/limine 2>/dev/null; then
  sudo rm -f "$usb_boot_drop_in"
  sudo sed -i '/^# Omarchy USB authorization begin$/,/^# Omarchy USB authorization end$/d' /etc/default/limine
  sudo limine-mkinitcpio
fi

# Leave a USBGuard the user set up before Omarchy shipped it.
if omarchy-pkg-present usbguard; then
  installed=$(awk '/^%INSTALLDATE%/ { getline; print }' /var/lib/pacman/local/usbguard-[0-9]*/desc)
  if [[ -f $usb_state/policy-generated-by-omarchy ]] || (( installed >= usbguard_added )); then
    sudo systemctl disable --now usbguard.service
    # USBGuard leaves the root hubs denying new devices when it exits, until
    # the next boot. Restore the kernel default and authorize what it blocked.
    shopt -s nullglob
    echo 1 | sudo tee /sys/bus/usb/devices/usb*/authorized_default /sys/bus/usb/devices/*/authorized >/dev/null
    shopt -u nullglob
    omarchy-pkg-drop usbguard
  fi
fi

for action in /usr/share/polkit-1/actions/org.omarchy.usb.policy /usr/share/polkit-1/actions/org.omarchy.thunderbolt.policy; do
  if [[ -e $action ]] && ! pacman -Qo "$action" &>/dev/null; then
    sudo rm -f "$action"
  fi
done

rm -rf "$usb_state"
