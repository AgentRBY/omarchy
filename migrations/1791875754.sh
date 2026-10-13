echo "Name web app windows in launchers that run their own command"

# A web app installed with its own Exec, such as HEY with its mailto handler,
# got no StartupWMClass, so nothing tied its window to its launcher: the dock
# left it out and titlebars showed the page title. Its window class follows
# from the URL it opens, as it does for every other web app.

applications=$HOME/.local/share/applications

for desktop_file in "$applications"/*.desktop; do
  [[ -f $desktop_file ]] || continue
  grep -q '^StartupWMClass=' "$desktop_file" && continue

  exec_line=$(grep -m1 '^Exec=' "$desktop_file")
  url=""

  if [[ $exec_line =~ ^Exec=omarchy-webapp-handler-hey ]]; then
    url="https://app.hey.com"
  elif [[ $exec_line =~ ^Exec=omarchy-launch-webapp[[:space:]]+\"?([^\"[:space:]]+) ]]; then
    url=${BASH_REMATCH[1]}
  fi

  [[ -n $url ]] || continue

  window_class=$(omarchy-webapp-window-class "$url") || continue
  [[ -n $window_class ]] && printf 'StartupWMClass=%s\n' "$window_class" >>"$desktop_file"
done
