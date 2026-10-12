echo "Pause video wallpapers on battery"

# owe reads only ~/.config/owe/config.toml and keeps a video wallpaper playing
# on battery without one. A file that already exists is the user's own choice.
owe_config="$HOME/.config/owe/config.toml"

if [[ ! -e $owe_config ]]; then
  install -Dm644 "$OMARCHY_PATH/config/owe/config.toml" "$owe_config"
  owe reload-config >/dev/null 2>&1 || true
fi
