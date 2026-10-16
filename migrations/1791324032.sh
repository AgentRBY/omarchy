echo "Cap MacBook10,1 package power at 4.5W/7W and CPU turbo at 3GHz"

unit_path=${OMARCHY_MACBOOK10_ENVELOPE_UNIT:-/etc/systemd/system/omarchy-macbook10-power-envelope.service}

# Migrations run once per user; a unit already on disk means another user installed it.
if omarchy-hw-macbook10 && [[ ! -f $unit_path ]]; then
  source "$OMARCHY_PATH/install/hardware/apple/fix-macbook10-power-envelope.sh"
  sudo /usr/bin/omarchy-hw-macbook10-power-envelope
fi
