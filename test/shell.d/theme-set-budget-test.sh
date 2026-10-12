#!/bin/bash

# A theme switch returns once the desktop has its new colours; slow app
# retints run behind it or not at all. This runs the whole omarchy-theme-set
# against a scratch home in which every app is a stub, and gives the stubs the
# costs the real apps have: a running Hunk, VS Code with the theme's extension
# installed (answering --list-extensions after an Electron boot), a Framework 16
# keyboard and three tmux sessions. A switch that waits on any of them again,
# or that starts a client per value, blows the budget.

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

require_command jq

# The switch costs about 0.1s on a current laptop. Waiting on Hunk's settle
# nudge or on one VS Code boot costs a second more, so the budget leaves room
# for a machine five times slower and still catches either.
BUDGET_MS=${OMARCHY_THEME_SET_BUDGET_MS:-500}
STUB_COST=1

sandbox=$(mktemp -d)
trap 'rm -rf "$sandbox"' EXIT

test_home="$sandbox/home"
stub_bin="$sandbox/bin"
calls="$sandbox/calls.log"
mkdir -p "$test_home" "$stub_bin" "$sandbox/run" "$sandbox/tmux" "$sandbox/policy"

# Every stub logs its name and arguments, so the test can tell which apps the
# switch reached, and what it would have done to them.
stub() {
  local name="$1" body="${2:-}"

  cat >"$stub_bin/$name" <<SH
#!/bin/bash
printf '%s %s\n' "$name" "\$*" >>"$calls"
$body
exit 0
SH
  chmod +x "$stub_bin/$name"
}

# The switch sees no program of the host's but plain tools, so an app the host
# happens to have installed (an ASUS keyboard's asusctl, VSCodium, a browser)
# is absent rather than retinted for real. Everything it may reach on the
# desktop is a stub: the compositor, the shell, signals to running apps and
# privileged writes.
tools_bin="$sandbox/tools"
mkdir -p "$tools_bin"
for tool in awk base64 basename cat chmod cksum cmp cp cut date dirname env find flock \
  gawk grep head id jq ln ls md5sum mkdir mktemp mv ps readlink realpath rm rmdir sed \
  seq setsid sha256sum sleep sort stat tail tee timeout touch tr tty uname uniq wc xargs; do
  path=$(command -v "$tool") || fail "required command is available: $tool"
  ln -s "$path" "$tools_bin/$tool"
done

for name in hyprctl omarchy-shell pkill killall omarchy-theme-set-browser-policy \
  omarchy-theme-set-herdr-machines omarchy-theme-bg-cache omarchy-hook; do
  stub "$name"
done
# Never escalate: the browser policy hook would rewrite the system's policy.
stub sudo 'exit 1'
stub pkexec 'exit 1'
stub pgrep '[[ " $* " == *" hunk "* ]] || exit 1'
stub tmux '[[ $1 == "list-sessions" ]] && printf "%s\n" one two three'
stub code "[[ \$* == *--list-extensions* ]] && { sleep $STUB_COST; echo enkia.tokyo-night; }"
stub qmk_hid

# The app retints run under `bash -lc`, and a login shell resets PATH and
# OMARCHY_PATH from /etc/omarchy.conf, which would put the real commands back
# ahead of these stubs. Keep the login shell from rereading the profile.
cat >"$stub_bin/bash" <<'SH'
#!/bin/bash
[[ $1 == "-lc" ]] && shift && set -- -c "$@"
exec /bin/bash "$@"
SH
chmod +x "$stub_bin/bash"

# VS Code's own registry already lists the theme's extension.
mkdir -p "$test_home/.vscode/extensions/enkia.tokyo-night" "$test_home/.config/Code/User"
jq -n '[{identifier: {id: "enkia.tokyo-night"}, relativeLocation: "enkia.tokyo-night"}]' \
  >"$test_home/.vscode/extensions/extensions.json"
echo '{}' >"$test_home/.config/Code/User/settings.json"

# Cursor is the one editor the VS Code hook names by absolute path.
mkdir -p "$test_home/.local/state/omarchy/toggles"
touch "$test_home/.local/state/omarchy/toggles/skip-cursor-theme-changes"

run_theme_set() {
  env -i \
    HOME="$test_home" \
    USER="${USER:-omarchy}" \
    LANG=C.UTF-8 \
    OMARCHY_PATH="$ROOT" \
    PATH="$stub_bin:$ROOT/bin:$tools_bin" \
    XDG_RUNTIME_DIR="$sandbox/run" \
    TMUX_TMPDIR="$sandbox/tmux" \
    OMARCHY_THEME_SKIP_BACKGROUND=1 \
    OMARCHY_BROWSER_POLICY_DIRS="$sandbox/policy" \
    "$ROOT/bin/omarchy-theme-set" "$1" >"$sandbox/theme-set.log" 2>&1
}

# A first switch sets up the scratch home, so the timed ones change between two
# themes the way a user would.
run_theme_set "Catppuccin" || fail "theme set runs in a scratch home" "$(cat "$sandbox/theme-set.log")"

best=""
for theme in "Tokyo Night" "Catppuccin" "Tokyo Night"; do
  : >"$calls"
  start=$EPOCHREALTIME
  run_theme_set "$theme" || fail "theme set switches to $theme in a scratch home" "$(cat "$sandbox/theme-set.log")"
  end=$EPOCHREALTIME
  elapsed=$(( (${end/[.,]/} - ${start/[.,]/}) / 1000 ))
  if [[ -z $best ]] || (( elapsed < best )); then
    best=$elapsed
  fi
done

# The stubs only prove anything if the switch reached them.
for reached in "pgrep -x hunk" "qmk_hid via" "tmux list-sessions" "hyprctl reload" "omarchy-theme-set-browser-policy"; do
  grep -qF -- "$reached" "$calls" || fail "theme set reaches the stubbed apps ($reached)" "$(cut -c1-160 "$calls" | sort)"
done
pass "theme set reaches every stubbed app"

(( best <= BUDGET_MS )) || fail "theme set returns within ${BUDGET_MS}ms with slow apps running" "$(
  printf 'Fastest of three switches took %dms. Stubbed app calls in the last one:\n' "$best"
  cut -c1-160 "$calls" | sort | uniq -c | sort -rn | sed 's/^/  /' | head -30
)"
pass "theme set returns within ${BUDGET_MS}ms with slow apps running (${best}ms)"

# Every tmux client is a process start, so the count is the cost, and unlike
# the time it is the same on every machine. Before the theme went over as one
# source-file, every value took a client of its own: about 600 for these three sessions.
tmux_clients=$(grep -c '^tmux ' "$calls" || true)
(( tmux_clients <= 8 )) || fail "theme set syncs tmux with a handful of clients" "$(
  printf 'The last switch started %d tmux clients:\n' "$tmux_clients"
  grep '^tmux ' "$calls" | cut -c1-120 | sort | uniq -c | sort -rn | head -10
)"
pass "theme set syncs tmux with a handful of clients ($tmux_clients)"
