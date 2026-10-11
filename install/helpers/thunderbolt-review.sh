# Session-side notification and terminal dialog functions.

tb_requests() {
  TB_REQUESTS="$HOME/.local/state/omarchy/thunderbolt-authorization/requests"
  mkdir -p -m 700 "$TB_REQUESTS"
  chmod 700 "${TB_REQUESTS%/*}" "$TB_REQUESTS"
}

tb_safe_text() {
  jq -r 'gsub("[\u0000-\u001f\u007f-\u009f\u202a-\u202e\u2066-\u2069]"; "?")'
}

tb_notify() {
  local token=$1 retry=${2:-false} title='Thunderbolt accessory blocked' description
  description='Click to review it. Keep it blocked unless you recognize the device.'
  if [[ $retry == "true" ]]; then
    title='Thunderbolt approval needs retry'
    description='The last approval could not be confirmed. Click to retry it.'
  fi
  omarchy-notification-wait 1 >/dev/null || return 1
  timeout 10 omarchy-notification-send --app-name omarchy-action --urgency critical --glyph '󱐋' \
    "$title" "$description" --exec omarchy-launch-floating-terminal-with-presentation \
    omarchy-thunderbolt-authorization-review "$token"
}

tb_attention() {
  omarchy-notification-wait 1 >/dev/null || return 1
  timeout 10 omarchy-notification-send --app-name omarchy-action --urgency critical \
    'Thunderbolt protection needs attention' 'The approval or firmware policy could not be confirmed. Click for details.' \
    --exec omarchy-launch-floating-terminal-with-presentation omarchy-setup-security-thunderbolt-authorization status
}

tb_setup_notice() {
  omarchy-notification-wait 1 >/dev/null || return 1
  timeout 10 omarchy-notification-send --app-name omarchy-action --urgency critical \
    'Finish Thunderbolt protection setup' 'A connected accessory needs secure enrollment. Protection is not enabled. Click to finish safely.' \
    --exec omarchy-launch-floating-terminal-with-presentation omarchy-setup-security-thunderbolt-authorization
}

tb_token() {
  local digest
  digest=$(jq -cS --arg watch "$2" '{watch:$watch,identity:.}' <<< "$1" | sha256sum) || return 1
  printf 'request-%s\n' "${digest%% *}"
}

tb_request_read() {
  [[ -f $1 && ! -L $1 ]] || return 1
  jq -ce 'select(.identity | type == "object")' "$1"
}

tb_deliver() {
  local path=$1 request token
  request=$(tb_request_read "$path") || return 1
  if ! jq -e '.notified // false' <<< "$request" >/dev/null; then
    token=${path##*/}
    if tb_notify "${token%.json}" "$(jq -r '.approval != null' <<< "$request")"; then
      jq '.notified=true' <<< "$request" | tb_json_write "$path"
    else
      return 1
    fi
  fi
}

tb_request_apply() {
  # The watcher has no terminal. Polkit permits this one fixed helper for an
  # active local administrator; it cannot dispatch general setup operations.
  pkexec --disable-internal-agent /usr/bin/omarchy-thunderbolt-authorization-approve "$1" "$2"
}

tb_request_process() {
  local path=$1 request identity permanent result error_file error
  request=$(tb_request_read "$path") || return 1
  if jq -e '.pending // false' <<< "$request" >/dev/null; then
    identity=$(jq -c .identity <<< "$request")
    permanent=$(jq -r '.approval == "Always allow this device"' <<< "$request")
    error_file=$(mktemp "$TB_REQUESTS/.error.XXXXXX") || return 1
    if result=$(tb_request_apply "$permanent" "$identity" 2> "$error_file") &&
      jq -e --argjson identity "$identity" --argjson permanent "$permanent" \
        'any(.devices[]; .identity==$identity and (.status | IN("authorized","authorized-newkey","authorized-secure")) and
          ($permanent == false or .trusted))' <<< "$result" >/dev/null; then
      jq --argjson result "$result" '.pending=false | .result=$result | del(.error)' <<< "$request" |
        tb_json_write "$path" || return 1
    else
      error=$(cat "$error_file")
      [[ -n $error ]] || error='Could not confirm approval. Click the retry notification.'
      jq --arg error "$error" '.pending=false | .notified=false | .error=$error' <<< "$request" |
        tb_json_write "$path" || return 1
    fi
    rm -f -- "$error_file"
  fi
  tb_deliver "$path"
}

tb_scan() {
  local watch=$1 snapshot path request device identity token existing
  snapshot=$(tb_public_snapshot) || return 1
  (
    flock -x 9
    for path in "$TB_REQUESTS"/request-*.json; do
      [[ -e $path || -L $path ]] || continue
      if ! request=$(tb_request_read "$path"); then
        rm -f -- "$path"
        continue
      fi
      identity=$(jq -c .identity <<< "$request")
      device=$(jq -c --argjson identity "$identity" '.devices[] | select(.identity==$identity)' <<< "$snapshot") || exit 1
      if [[ -z $device ]] || { ! jq -e '.status | IN("connected","auth-error")' <<< "$device" >/dev/null &&
        ! jq -e '.approval != null' <<< "$request" >/dev/null; }; then
        rm -- "$path"
        continue
      fi
      if [[ $(jq -r .watch <<< "$request") != "$watch" ]]; then
        rm -- "$path"
        # Resume an interrupted attempt only for the same exact connection.
        jq -e '.approval != null and .result == null' <<< "$request" >/dev/null || continue
        token=$(tb_token "$identity" "$watch") || exit 1
        path="$TB_REQUESTS/$token.json"
        request=$(jq -c --arg watch "$watch" '.watch=$watch | .notified=false' <<< "$request") || exit 1
        tb_json_write "$path" <<< "$request" || exit 1
      fi
      tb_request_process "$path" || true
    done
    snapshot=$(tb_public_snapshot) || exit 1
    while IFS= read -r device; do
      identity=$(jq -c .identity <<< "$device")
      token=$(tb_token "$identity" "$watch") || exit 1
      path="$TB_REQUESTS/$token.json"
      if [[ ! -f $path ]]; then
        jq -cn --argjson identity "$identity" --arg watch "$watch" \
          '{identity:$identity,watch:$watch,notified:false}' | tb_json_write "$path" || exit 1
        if ! tb_deliver "$path"; then
          rm -f -- "$path"
        fi
      fi
    done < <(jq -c '.devices[] | select((.trusted | not) and (.status | IN("connected","auth-error")) and
      (.flags | contains("nopcie") | not))' <<< "$snapshot")
  ) 9> "$TB_REQUESTS/.lock" || return 1
  printf '%s\n' "$snapshot"
}

# Wakes the watcher when the daemon publishes, a request changes or protection
# is enabled or deferred. The runtime directory is watched only while it exists;
# systemd recreates it whenever the daemon restarts.
tb_watch_events() {
  local marker=${TB_MARKER##*/} pending=${TB_PENDING##*/}
  local -a paths=("$TB_REQUESTS" "${TB_MARKER%/*}")
  [[ ${TB_PENDING%/*} == "${TB_MARKER%/*}" ]] || paths+=("${TB_PENDING%/*}")
  [[ -d $TB_RUNTIME ]] && paths+=("$TB_RUNTIME")
  exec inotifywait -m -q -e close_write,moved_to,create,delete \
    --include "/(snapshot\.json|generation|request-[^/]*\.json|${marker//./\\.}|${pending//./\\.})\$" "${paths[@]}"
}

# Reads the given files into TB_WATCH_STATE without forking, to tell whether
# anything a scan acts on has changed.
tb_watch_state() {
  local path text
  TB_WATCH_STATE=''
  for path in "$@"; do
    text=''
    if [[ -f $path && ! -L $path && -r $path ]]; then
      IFS= read -r -d '' text < "$path" || true
    fi
    TB_WATCH_STATE+="$path ${#text}"$'\n'"$text"$'\n'
  done
}

# Whether a scan left nothing to retry: every blocked device has a delivered
# request and no approval is waiting to be submitted.
tb_watch_settled() {
  local path
  local -a requests=()
  for path in "$TB_REQUESTS"/request-*.json; do
    [[ -f $path && ! -L $path ]] && requests+=("$path")
  done
  jq -en --argjson snapshot "$1" '[inputs] as $requests |
    all($requests[]; .notified == true and (.pending // false | not)) and
    all($snapshot.devices[] | select((.trusted | not) and (.status | IN("connected","auth-error")) and
      (.flags | contains("nopcie") | not)) | .identity; . as $identity | any($requests[]; .identity == $identity))' \
    "${requests[@]}" < /dev/null >/dev/null 2>&1
}

tb_watch() {
  local watch snapshot warning warned='' failures=0 settled=false snapshot_time=0 scanned=0
  local published seen_published='' seen_requests='' runtime watched='' generation monitored='' started remaining
  tb_requests
  watch=$(cat /proc/sys/kernel/random/uuid)
  trap 'tb_events_close; trap - TERM; kill -TERM "$BASHPID"' TERM
  while true; do
    runtime=false
    [[ -d $TB_RUNTIME ]] && runtime=true
    generation=''
    [[ -r $TB_RUNTIME/generation ]] && IFS= read -r generation < "$TB_RUNTIME/generation" || true
    started=false
    # A new generation means a new runtime directory, which the old watch lost.
    if [[ -z ${TB_EVENTS:-} || $runtime != "$watched" || $generation != "$monitored" ]]; then
      tb_events_close
      tb_events_open tb_watch_events
      watched=$runtime monitored=$generation started=true
    fi
    if [[ -f $TB_PENDING && ! -f $TB_MARKER ]]; then
      if [[ $warned != "pending" ]] && tb_setup_notice; then warned=pending; fi
      seen_published=''
      if [[ $warned == "pending" && $started == false ]]; then
        tb_events_wait "$TB_REFRESH" || true
      else
        tb_events_wait 2 || true
      fi
      continue
    fi
    # Scan only when something a scan reads has changed, the last scan left
    # something to retry, or the snapshot it accepted is due to expire. After
    # the unavailable warning, a failure is retried only once something changes.
    tb_watch_state "$TB_RUNTIME/generation" "$TB_RUNTIME/snapshot.json"
    published=$TB_WATCH_STATE
    tb_watch_state "$TB_REQUESTS"/request-*.json
    if [[ $published != "$seen_published" || $TB_WATCH_STATE != "$seen_requests" ]] ||
      (( EPOCHSECONDS < scanned || EPOCHSECONDS - scanned >= TB_REFRESH )) ||
      { (( failures == 0 )) && { [[ $settled != true ]] ||
        (( EPOCHSECONDS < snapshot_time || EPOCHSECONDS - snapshot_time >= TB_SNAPSHOT_TTL )); }; } ||
      { (( failures > 0 )) && [[ $warned != "unavailable" ]]; }; then
      settled=false
      if snapshot=$(tb_scan "$watch"); then
        failures=0 settled=true
        warning=$(jq -c '[.generation,.warnings,.error]' <<< "$snapshot")
        if jq -e '(.warnings | length > 0) or .error != ""' <<< "$snapshot" >/dev/null; then
          if [[ $warning != "$warned" ]] && tb_attention; then
            warned=$warning
          fi
          # An undelivered warning is retried like an undelivered request.
          [[ $warned == "$warning" ]] || settled=false
        else
          warned=''
        fi
        snapshot_time=$(jq -r .time <<< "$snapshot")
        [[ $snapshot_time =~ ^[0-9]+$ ]] || snapshot_time=0
      else
        failures=$((failures + 1))
        if (( failures >= 3 )) && [[ $warned != "unavailable" ]] && tb_attention; then
          warned=unavailable
        fi
      fi
      scanned=$EPOCHSECONDS
      # Keep the published files as read before the scan, so a snapshot
      # published during it is scanned next. The requests are read after the
      # scan's own writes and before checking them, for the same reason.
      seen_published=$published
      tb_watch_state "$TB_REQUESTS"/request-*.json
      seen_requests=$TB_WATCH_STATE
      if [[ $settled == true ]] && ! tb_watch_settled "$snapshot"; then
        settled=false
      fi
    fi
    # Wait for the next change, but no longer than the accepted snapshot stays
    # valid. Retries, a monitor that is still starting and a daemon whose
    # runtime directory is gone are re-checked every 2 s instead.
    if [[ $started == true || $watched != true ]] || { (( failures == 0 )) && [[ $settled != true ]]; } ||
      { (( failures > 0 )) && [[ $warned != "unavailable" ]]; }; then
      tb_events_wait 2 || true
    elif (( failures == 0 )); then
      remaining=$(( snapshot_time + TB_SNAPSHOT_TTL - EPOCHSECONDS ))
      (( remaining < TB_REFRESH )) || remaining=$TB_REFRESH
      (( remaining > 2 )) || remaining=2
      tb_events_wait "$remaining" || true
    else
      tb_events_wait "$TB_REFRESH" || true
    fi
  done
}

tb_find_device() {
  local snapshot
  snapshot=$(tb_public_snapshot) || return 1
  jq -ce --argjson identity "$1" '.devices[] | select(.identity==$identity)' <<< "$snapshot" ||
    tb_fail 'That Thunderbolt device was removed or changed. Open its latest notification.'
}

tb_review() {
  local token=$1 path request identity device choice latest index
  [[ $token =~ ^request-[0-9a-f]{64}$ ]] || { tb_fail 'Invalid or expired Thunderbolt request'; return 1; }
  tb_requests
  path="$TB_REQUESTS/$token.json"
  request=$(tb_request_read "$path") || return 1
  identity=$(jq -c .identity <<< "$request")
  device=$(tb_find_device "$identity") || return 1
  choice=$(jq -r '.approval // empty' <<< "$request")
  if [[ -z $choice ]]; then
    jq -e '.status | IN("connected","auth-error")' <<< "$device" >/dev/null || { tb_fail 'This device is no longer blocked'; return 1; }
    gum style --foreground 212 --bold 'Blocked Thunderbolt accessory'
    printf '\nThese details come from the device and can be forged:\n'
    for index in Name Vendor Uid; do
      printf '%s: ' "$index"
      jq --arg key "$index" '.[$key]' <<< "$identity" | tb_safe_text
    done
    printf '\nApproval gives this accessory access to its PCIe drivers.\n\n'
    choice=$(gum choose 'Allow once' 'Always allow this device' 'Keep blocked') || return 0
  fi
  case "$choice" in
    'Allow once'|'Always allow this device'|'Keep blocked') ;;
    *) tb_fail 'Invalid approval choice'; return 1 ;;
  esac
  (
    flock -x 9
    latest=$(tb_request_read "$path") || exit 1
    [[ $latest == "$request" ]] || { tb_fail 'This request changed. Open the latest notification.'; exit 1; }
    device=$(tb_find_device "$identity") || exit 1
    if [[ $choice == "Keep blocked" ]]; then
      printf 'Thunderbolt accessory remains blocked.\n'
    else
      if ! jq -e '.approval != null' <<< "$request" >/dev/null; then
        jq -e '.status | IN("connected","auth-error")' <<< "$device" >/dev/null || exit 1
      fi
      jq --arg choice "$choice" '.approval=$choice | .pending=true | del(.error,.result)' <<< "$request" |
        tb_json_write "$path"
    fi
  ) 9> "$TB_REQUESTS/.lock" || return 1
  if [[ $choice != "Keep blocked" ]]; then
    for ((index=0; index<60; index++)); do
      latest=$(tb_request_read "$path") || return 1
      if jq -e '.result != null' <<< "$latest" >/dev/null; then
        rm -- "$path"
        if [[ $choice == "Always allow this device" ]]; then
          printf 'Thunderbolt accessory trusted.\n'
        else
          printf 'Thunderbolt accessory allowed for this connection.\n'
        fi
        return 0
      elif jq -e '.error != null' <<< "$latest" >/dev/null; then
        jq .error <<< "$latest" | tb_safe_text >&2
        return 1
      fi
      sleep 1
    done
    tb_fail 'Approval is still pending. The watcher will retain and retry the request.'
  fi
}

tb_status() {
  local snapshot
  if [[ -f $TB_PENDING && ! -f $TB_MARKER ]]; then
    printf 'Thunderbolt protection is deferred. Previous Bolt behavior remains active.\nKeep a keyboard/input device available independently of Thunderbolt. Safely disconnect the Thunderbolt accessories, then run Setup > Security > Thunderbolt. Reconnect each accessory and choose Always allow to save its secure key.\n'
    return 0
  fi
  snapshot=$(tb_public_snapshot) || return 1
  printf 'Thunderbolt device approval is enabled.\nTrusted accessories reconnect automatically; new accessories require approval.\n'
  if jq -e '.domains | length == 0' <<< "$snapshot" >/dev/null; then
    printf 'No Thunderbolt controller is currently visible. Its firmware policy will be checked when it appears.\n'
  fi
  jq '.warnings[], (.error | select(. != ""))' <<< "$snapshot" | while IFS= read -r warning; do
    printf 'Attention: '
    tb_safe_text <<< "$warning"
  done
  printf 'Firmware boot access is separate; see the Security manual before relying on pre-boot protection.\n'
}
