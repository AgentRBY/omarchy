#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

require_compositor "keyboard panel owner close runtime test"
require_command quickshell

stage=$(mktemp -d)
trap 'rm -rf -- "$stage"' EXIT
ln -s "$ROOT/shell/Ui" "$stage/Ui"
ln -s "$ROOT/shell/Commons" "$stage/Commons"
cp "$SHELL_TEST_DIR/fixtures/keyboard-panel-owner-throws/shell.qml" "$stage/shell.qml"

output=$(HOME="$stage" OMARCHY_PATH="$ROOT" timeout 30 quickshell -p "$stage" --no-color 2>&1) || fail "keyboard panel owner fixture exits cleanly" "$output"
[[ $output == *"RESULT pass"* ]] || fail "keyboard panel owner close assertions pass" "$output"
# The owner's own exception is expected, and close() reports it.
if rg -v 'owner close\(\) threw' <<< "$output" | rg -q 'RESULT fail|ReferenceError|TypeError|Error:|Unable to assign|Binding loop'; then
  fail "keyboard panel owner fixture has no QML errors" "$output"
fi
pass "a keyboard panel closes even when its owner's close() throws"
