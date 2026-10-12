#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

migration="$ROOT/migrations/1791839875.sh"
work=$(mktemp -d)
trap 'rm -rf -- "$work"' EXIT
mkdir -p "$work/bin"

cat >"$work/bin/systemctl" <<EOF
#!/bin/bash
printf '%s\n' "\$*" >>"$work/systemctl.log"
exit "\${SYSTEMCTL_STATUS:-0}"
EOF
chmod +x "$work/bin/systemctl"

HOME="$work" PATH="$work/bin:$PATH" bash -euo pipefail "$migration" >/dev/null
[[ $(<"$work/systemctl.log") == "--user try-restart omarchy-sleep-lock.service" ]] ||
  fail "a running sleep monitor is restarted onto the new script" "$(<"$work/systemctl.log")"
pass "a running sleep monitor is restarted onto the new script"

SYSTEMCTL_STATUS=1 HOME="$work" PATH="$work/bin:$PATH" bash -euo pipefail "$migration" >/dev/null ||
  fail "a session without the user manager still completes the migration"
pass "a session without the user manager still completes the migration"
