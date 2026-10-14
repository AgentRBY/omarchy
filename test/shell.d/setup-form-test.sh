#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

tmp_dir=$(mktemp -d)
trap 'rm -r "$tmp_dir"' EXIT

export OMARCHY_PATH=$ROOT TMPDIR=$tmp_dir

# gum reads its scripted answers from GUM_SCRIPT, one "status:output" line per
# invocation, so a test spells out exactly what the human did at each screen:
# "0:dhh" answers, "1:" is Esc, "130:" is Ctrl+C. Only the widgets that take a
# list drain stdin, matching the real ones, so the piped layouts and timezones
# can be asserted.
cat >"$tmp_dir/gum" <<'EOF'
#!/bin/bash
count=$(($(cat "$GUM_COUNT") + 1))
printf '%s' "$count" >"$GUM_COUNT"
printf '%s\n' "$*" >>"$GUM_ARGS"

case $1 in
  choose | filter) cat >"$GUM_DIR/stdin.$count" ;;
esac

line=$(sed -n "${count}p" "$GUM_SCRIPT")
printf '%s\n' "${line#*:}"
exit "${line%%:*}"
EOF

cat >"$tmp_dir/tzupdate" <<'EOF'
#!/bin/bash
[[ -n ${TZ_GUESS:-} ]] || exit 1
printf '%s\n' "$TZ_GUESS"
EOF

cat >"$tmp_dir/timedatectl" <<'EOF'
#!/bin/bash
printf '%s\n' UTC Europe/Copenhagen America/Chicago
EOF

# Calls one prompt bare under `set -euo pipefail` — the shape that makes the
# status capture load-bearing. A cancelled prompt is a failing assignment, so a
# regression to a plain `status=$?` kills the shell before the function can
# return; both cases exit with the same status, and this marker is the only
# thing that tells them apart.
cat >"$tmp_dir/driver" <<'EOF'
#!/bin/bash

set -euo pipefail
set -T

source "$ROOT/install/provisioning/setup-form.sh"

notice() { printf '%s\n' "$1" >>"$NOTICES"; }

if [[ -n ${TAKEN_USERS:-} ]]; then
  omarchy_username_taken() { [[ " $TAKEN_USERS " == *" $1 "* ]]; }
fi

trap 'if [[ ${FUNCNAME[0]:-} == "$PROMPT_FN" ]]; then printf "returned\n" >>"$MARKER"; fi' RETURN

[[ -z ${LANGUAGE:-} ]] || language=$LANGUAGE
[[ -z ${KEYBOARD_LABEL:-} ]] || keyboard_label=$KEYBOARD_LABEL

"$PROMPT_FN"

printf 'language=%s\n' "${language:-}"
printf 'language_locale=%s\n' "${language_locale:-}"
printf 'language_file=%s\n' "${OMARCHY_LANGUAGE_FILE:-}"
if [[ -n ${AFTER:-} ]]; then printf 'after=%s\n' "$(eval "$AFTER")"; fi
printf 'keyboard=%s\n' "${keyboard:-}"
printf 'keyboard_label=%s\n' "${keyboard_label:-}"
printf 'keyboard_input_method=%s\n' "${keyboard_input_method:-}"
printf 'keyboard_xkb_layout=%s\n' "${keyboard_xkb_layout:-}"
printf 'username=%s\n' "${username:-}"
printf 'password=%s\n' "${password:-}"
printf 'password_confirmation=%s\n' "${password_confirmation:-}"
printf 'full_name=%s\n' "${full_name:-}"
printf 'email_address=%s\n' "${email_address:-}"
printf 'hostname=%s\n' "${hostname:-}"
printf 'timezone=%s\n' "${timezone:-}"
EOF

chmod +x "$tmp_dir/gum" "$tmp_dir/tzupdate" "$tmp_dir/timedatectl" "$tmp_dir/driver"
export PATH="$tmp_dir:$PATH"
export GUM_DIR="$tmp_dir" GUM_SCRIPT="$tmp_dir/script" GUM_ARGS="$tmp_dir/args" GUM_COUNT="$tmp_dir/count"
export NOTICES="$tmp_dir/notices" MARKER="$tmp_dir/marker"

status=0

# run_prompt <function> <status:output>... — each response answers one gum screen
run_prompt() {
  local prompt=$1
  shift

  printf '%s\n' "$@" >"$GUM_SCRIPT"
  printf '0' >"$GUM_COUNT"
  : >"$GUM_ARGS"
  : >"$NOTICES"
  : >"$MARKER"
  rm -f "$tmp_dir"/stdin.*

  PROMPT_FN="$prompt" "$tmp_dir/driver" >"$tmp_dir/out" 2>"$tmp_dir/err" && status=0 || status=$?
}

field() { sed -n "s/^$1=//p" "$tmp_dir/out"; }

assert_returned() {
  grep -qx returned "$MARKER" ||
    fail "$1" "$(printf 'the prompt never returned; the shell died inside it:\n%s' "$(<"$tmp_dir/err")")"
}

assert_status() {
  ((status == $1)) || fail "$2" "expected status: $1
actual status:   $status"
}

assert_notices() {
  local description=$1 expected=$2
  local actual
  actual=$(<"$NOTICES")
  [[ $actual == "$expected" ]] || fail "$description" "expected notices: $expected
actual notices:   $actual"
}

# The contract both callers read, and the ordering the shared list exists to keep
source "$ROOT/install/provisioning/setup-form.sh"

((OMARCHY_FORM_BACK == 1)) || fail "Esc reports status 1"
((OMARCHY_FORM_SIGNAL == 130)) || fail "Ctrl+C reports status 130"
[[ $(printf '%s\n' "$OMARCHY_KEYBOARD_LAYOUTS" | head -n 1) == "English (US)|us" ]] ||
  fail "English (US) leads the keyboard layouts so gum choose opens on the default"
pass "the form publishes the 0/1/130 status contract and leads with English (US)"

# Language

run_prompt omarchy_prompt_language "0:Dansk (Danish)"
assert_status 0 "language prompt succeeds"
[[ $(field language) == "da" && $(field language_locale) == "da_DK.UTF-8" ]] ||
  fail "language prompt sets the registry code and its glibc locale"
[[ $(sed -n 1p "$tmp_dir/stdin.1") == "English" && $(sed -n 2p "$tmp_dir/stdin.1") == "Arabic" && $(sed -n 4p "$tmp_dir/stdin.1") == "Български (Bulgarian)" ]] || fail "language prompt lists English first, then by English name" "$(head -3 "$tmp_dir/stdin.1")"
(( $(wc -l <"$tmp_dir/stdin.1") == 50 )) || fail "language prompt offers all 50 languages"
grep -qx 'Dansk (Danish)' "$tmp_dir/stdin.1" && grep -qx 'Русский (Russian)' "$tmp_dir/stdin.1" ||
  fail "a language the console draws shows its native name with the English one" "$(cat "$tmp_dir/stdin.1")"
grep -qx 'Japanese' "$tmp_dir/stdin.1" && grep -qx 'Arabic' "$tmp_dir/stdin.1" && ! grep -q '日本語' "$tmp_dir/stdin.1" ||
  fail "a language the console can't draw shows only its English name" "$(cat "$tmp_dir/stdin.1")"
grep -qF -- '--selected English' "$GUM_ARGS" || fail "language prompt preselects English"
language_file=$(field language_file)
[[ $language_file == "$tmp_dir"/omarchy-setup-language.* && $(<"$language_file") == "da" ]] ||
  fail "language prompt points OMARCHY_LANGUAGE_FILE at its choice" "$language_file"
pass "language prompt offers the registry, sets the code and locale, and speaks the choice"

LANGUAGE=ja run_prompt omarchy_prompt_language "0:Japanese"
grep -qF -- '--selected Japanese' "$GUM_ARGS" || fail "language prompt preselects the language already chosen"
[[ $(field language) == "ja" && $(field language_locale) == "ja_JP.UTF-8" ]] || fail "an undrawable language is still the chosen language"
[[ $(<"$(field language_file)") == "en" ]] || fail "a language the console can't draw keeps the form in English"
pass "a language the console can't draw is chosen, while the form stays in English"

run_prompt omarchy_prompt_language "1:"
assert_status "$OMARCHY_FORM_BACK" "language prompt reports Esc as back"
assert_returned "language prompt survives Esc under set -e"
run_prompt omarchy_prompt_language "130:"
assert_status "$OMARCHY_FORM_SIGNAL" "language prompt reports Ctrl+C as the caller's signal"
assert_returned "language prompt survives Ctrl+C under set -e"
[[ -z $(field language) ]] || fail "a cancelled language prompt sets nothing"
pass "language prompt propagates Esc and Ctrl+C without dying under set -e"

# Every later string comes through omarchy-i18n in the chosen language. A
# fixture catalog stands in for a Danish translation of the keyboard header.
fixture=$tmp_dir/omarchy
mkdir -p "$fixture/bin" "$fixture/default/i18n/en" "$fixture/default/i18n/da"
cp "$ROOT/bin/omarchy-i18n" "$fixture/bin/"
cp "$ROOT/default/i18n/locales.json" "$ROOT/default/i18n/plural.jq" "$fixture/default/i18n/"
cp "$ROOT/default/i18n/en/cli.json" "$fixture/default/i18n/en/"
printf '{"setup.keyboardHeader": "Vælg tastaturlayout"}\n' >"$fixture/default/i18n/da/cli.json"
OMARCHY_PATH=$fixture AFTER=omarchy_prompt_keyboard run_prompt omarchy_prompt_language "0:Dansk (Danish)" "0:Danish"
grep -qF -- '--header Select language' "$GUM_ARGS" || fail "the language prompt asks in English before a language is chosen"
grep -qF -- '--header Vælg tastaturlayout' "$GUM_ARGS" || fail "the keyboard prompt asks in the chosen language" "$(cat "$GUM_ARGS")"
OMARCHY_PATH=$fixture AFTER=omarchy_prompt_keyboard run_prompt omarchy_prompt_language "0:Japanese" "0:Japanese"
grep -qF -- '--header Select keyboard layout' "$GUM_ARGS" || fail "an undrawable language keeps the keyboard prompt in English" "$(cat "$GUM_ARGS")"
pass "the prompts after the language speak it"

# The registry's suggested layout for every language is one the form offers.
while IFS=$'\t' read -r code label console; do
  printf '%s\n' "$OMARCHY_KEYBOARD_LAYOUTS" | cut -d'|' -f1 | grep -qxF -- "$label" ||
    fail "$code suggests a keyboard layout the form offers" "$label"
  [[ $console == "true" || $console == "false" ]] || fail "$code marks console as false or leaves it out"
done < <(jq -r 'to_entries[] | [.key, .value.keyboard, (if has("console") then .value.console else true end | tostring)] | @tsv' "$ROOT/default/i18n/locales.json")
pass "every language suggests a keyboard layout the form offers"

# Keyboard

run_prompt omarchy_prompt_keyboard "0:German"
assert_status 0 "keyboard prompt succeeds"
[[ $(field keyboard) == "de" ]] || fail "keyboard prompt resolves the label to a keymap"
[[ $(field keyboard_label) == "German" ]] || fail "keyboard prompt keeps the label for the summary"
[[ $(head -n 1 "$tmp_dir/stdin.1") == "English (US)" ]] || fail "keyboard prompt offers English (US) first"
grep -qF -- '--selected English (US)' "$GUM_ARGS" || fail "keyboard prompt preselects English (US)"
pass "keyboard prompt maps the chosen label to its keymap"

for pick in 'da|Danish' 'de|German' 'nl|English (US)' 'ca|Spanish' 'ja|Japanese' 'ar|English (US)' 'ru|Russian' 'pt-BR|Portuguese (Brazil)'; do
  LANGUAGE=${pick%%|*} run_prompt omarchy_prompt_keyboard "0:${pick#*|}"
  grep -qF -- "--selected ${pick#*|} --header" "$GUM_ARGS" || fail "${pick%%|*} preselects the ${pick#*|} keyboard" "$(cat "$GUM_ARGS")"
done
LANGUAGE=de KEYBOARD_LABEL=Swedish run_prompt omarchy_prompt_keyboard "0:Swedish"
grep -qF -- '--selected Swedish --header' "$GUM_ARGS" || fail "a layout already picked wins over the language's suggestion"
LANGUAGE=xx run_prompt omarchy_prompt_keyboard "0:English (US)"
grep -qF -- '--selected English (US) --header' "$GUM_ARGS" || fail "an unknown language suggests English (US)"
pass "keyboard prompt preselects the layout picked, else the language's, else English (US)"

for selection in 'Japanese|jp106|mozc|' 'Japanese (US keyboard)|us|mozc|' 'Korean|us|hangul|kr' 'Lao|us|none|la' 'Chinese (Simplified, Pinyin)|us|pinyin|' 'Chinese (Traditional, Zhuyin)|us|chewing|'; do
  IFS='|' read -r label keymap method layout <<< "$selection"
  run_prompt omarchy_prompt_keyboard "0:$label"
  assert_status 0 "$label can be selected at install"
  [[ $(field keyboard) == "$keymap" && $(field keyboard_input_method) == "$method" && $(field keyboard_xkb_layout) == "$layout" ]] ||
    fail "$label carries a real console keymap and a separate input preference"
done
pass "language keyboard choices carry their keymap, input method, and desktop override"

language=da omarchy_persist_language "$tmp_dir/target" || fail "a registry language persists"
[[ $(<"$tmp_dir/target/etc/omarchy/language") == "da" ]] || fail "the language is persisted for the installed system"
for bad in "" xx "../da" "da/../en" "en us"; do
  if language=$bad omarchy_persist_language "$tmp_dir/bad"; then fail "an invalid language ($bad) is refused"; fi
done
[[ ! -e $tmp_dir/bad ]] || fail "an invalid language writes nothing"
pass "only a registry language is persisted for the installed system"

keyboard_input_method=hangul keyboard_xkb_layout=kr omarchy_persist_input_selection "$tmp_dir/target"
[[ $(<"$tmp_dir/target/etc/omarchy/input-method") == $'INPUT_METHOD=hangul\nXKB_LAYOUT=kr' ]] || fail "first-boot setup persists the selection for user finalization"
pass "first-boot setup persists the selection for user finalization"

run_prompt omarchy_prompt_keyboard "1:"
assert_status "$OMARCHY_FORM_BACK" "keyboard prompt reports Esc as back"
assert_returned "keyboard prompt survives Esc under set -e"

run_prompt omarchy_prompt_keyboard "130:"
assert_status "$OMARCHY_FORM_SIGNAL" "keyboard prompt reports Ctrl+C as the caller's signal"
assert_returned "keyboard prompt survives Ctrl+C under set -e"
pass "keyboard prompt propagates Esc and Ctrl+C without dying under set -e"

# Username

TAKEN_USERS=dhh run_prompt omarchy_prompt_username "0:Not A Username" "0:root" "0:cups-browsed" "0:dhh" "0:david"
assert_status 0 "username prompt accepts a valid name"
[[ $(field username) == "david" ]] || fail "username prompt keeps re-asking until the name is valid"
assert_notices "username prompt explains each rejection" "Username must be alphanumeric with no spaces
Username is reserved for system
Username is reserved for system
That username already exists on this machine"
pass "username prompt rejects malformed, reserved, and taken names"

run_prompt omarchy_prompt_username "1:"
assert_status "$OMARCHY_FORM_BACK" "username prompt reports Esc as back"
assert_returned "username prompt survives Esc under set -e"

run_prompt omarchy_prompt_username "130:"
assert_status "$OMARCHY_FORM_SIGNAL" "username prompt reports Ctrl+C as the caller's signal"
assert_returned "username prompt survives Ctrl+C under set -e"
pass "username prompt propagates Esc and Ctrl+C without dying under set -e"

# Password

run_prompt omarchy_prompt_password "0:one" "0:two" "0:" "0:" "0:s3cret" "0:s3cret"
assert_status 0 "password prompt accepts a confirmed password"
[[ $(field password) == "s3cret" ]] || fail "password prompt keeps the confirmed password"
assert_notices "password prompt explains each rejection" "Passwords didn't match!
Your password can't be blank!"
pass "password prompt rejects mismatched and blank passwords"

run_prompt omarchy_prompt_password "0:s3cret" "1:"
assert_status "$OMARCHY_FORM_BACK" "password prompt reports Esc on the confirmation as back"
assert_returned "password confirmation survives Esc under set -e"

run_prompt omarchy_prompt_password "0:s3cret" "130:"
assert_status "$OMARCHY_FORM_SIGNAL" "password prompt reports Ctrl+C on the confirmation as the caller's signal"
assert_returned "password confirmation survives Ctrl+C under set -e"
pass "password confirmation propagates Esc and Ctrl+C without dying under set -e"

# Identity — both fields are skippable, so empty is an answer and not a cancel

run_prompt omarchy_prompt_identity "0:" "0:"
assert_status 0 "identity prompt treats empty fields as answers"
[[ -z $(field full_name) && -z $(field email_address) ]] || fail "identity prompt leaves skipped fields empty"
pass "identity prompt accepts skipped fields"

run_prompt omarchy_prompt_identity "0:David" "1:"
assert_status "$OMARCHY_FORM_BACK" "identity prompt reports Esc on the email as back"
assert_returned "identity prompt survives Esc under set -e"
pass "identity prompt propagates Esc from its second field"

# Hostname

run_prompt omarchy_prompt_hostname "0:-nope-" "0:workshop"
assert_status 0 "hostname prompt accepts a valid hostname"
[[ $(field hostname) == "workshop" ]] || fail "hostname prompt keeps re-asking until the hostname is valid"
assert_notices "hostname prompt explains the rejection" "Hostname must be 1-63 letters, digits, or dashes, and cannot start or end with a dash"

run_prompt omarchy_prompt_hostname "0:"
assert_status 0 "hostname prompt accepts an empty hostname"
[[ $(field hostname) == "$OMARCHY_HOSTNAME_DEFAULT" ]] || fail "hostname prompt falls back to the default hostname"
pass "hostname prompt rejects malformed names and defaults an empty one"

run_prompt omarchy_prompt_hostname "1:"
assert_status "$OMARCHY_FORM_BACK" "hostname prompt reports Esc as back"
assert_returned "hostname prompt survives Esc under set -e"
pass "hostname prompt propagates Esc without dying under set -e"

# Timezone

TZ_GUESS=Europe/Copenhagen run_prompt omarchy_prompt_timezone "0:Europe/Copenhagen"
assert_status 0 "timezone prompt accepts the geo guess"
[[ $(field timezone) == "Europe/Copenhagen" ]] || fail "timezone prompt keeps the chosen timezone"
grep -qF -- '--selected Europe/Copenhagen' "$GUM_ARGS" || fail "timezone prompt preselects the geo guess"
grep -qF UTC "$tmp_dir/stdin.1" || fail "timezone prompt offers the system timezone list"
pass "timezone prompt preselects the geo guess when one is available"

# An unnetworked first boot has no guess, and the fallback has to survive `set -e`
run_prompt omarchy_prompt_timezone "0:America/Chicago"
assert_status 0 "timezone prompt survives a failed geo guess"
[[ $(field timezone) == "America/Chicago" ]] || fail "timezone prompt keeps the filtered timezone"
[[ $(head -n 1 "$GUM_ARGS") == filter* ]] || fail "timezone prompt filters when there is no geo guess"
pass "timezone prompt falls back to filtering when the geo guess fails"

run_prompt omarchy_prompt_timezone "0:"
assert_status 0 "timezone prompt accepts an empty selection"
[[ $(field timezone) == "UTC" ]] || fail "timezone prompt falls back to UTC"
pass "timezone prompt falls back to UTC when nothing is selected"

run_prompt omarchy_prompt_timezone "1:"
assert_status "$OMARCHY_FORM_BACK" "timezone prompt reports Esc as back"
assert_returned "timezone prompt survives Esc under set -e"

TZ_GUESS=Europe/Copenhagen run_prompt omarchy_prompt_timezone "130:"
assert_status "$OMARCHY_FORM_SIGNAL" "timezone prompt reports Ctrl+C as the caller's signal"
assert_returned "timezone prompt survives Ctrl+C under set -e"
pass "timezone prompt propagates Esc and Ctrl+C without dying under set -e"

# Console font: Terminus at the size whose rows land nearest ~48 while clearing
# the logo, kbd's fonts without Terminus, and nothing off a real VT. setfont
# records each font and fails for missing ones; stty reports the size that
# font gives on the fixture console.
font_bin=$tmp_dir/font-bin
mkdir -p "$font_bin"
cat >"$font_bin/setfont" <<'SH'
#!/bin/bash
[[ " $MISSING_FONTS " != *" $1 "* ]] || exit 1
printf '%s\n' "$1" >>"$FONT_CALLS"
printf '%s' "$1" >"$FONT_CURRENT"
SH
cat >"$font_bin/stty" <<'SH'
#!/bin/bash
font=$(<"$FONT_CURRENT")
awk -v f="$font" '$1 == f { print $2, $3 }' "$FONT_SIZES"
SH
cat >"$font_bin/tty" <<'SH'
#!/bin/bash
[[ -n ${ON_VT:-} ]] || { echo "not a tty"; exit 1; }
echo /dev/tty1
SH
chmod +x "$font_bin"/*
export FONT_CALLS=$tmp_dir/font-calls FONT_CURRENT=$tmp_dir/font-current FONT_SIZES=$tmp_dir/font-sizes

# A 2560x1600 panel at native resolution.
cat >"$FONT_SIZES" <<'SIZES'
ter-v16n 100 320
ter-v20n 80 256
ter-v24n 66 213
ter-v28n 57 182
ter-v32n 50 160
default8x16 100 320
sun12x22 72 213
latarcyrheb-sun32 50 160
SIZES

console_font() {
  : >"$FONT_CALLS"
  : >"$FONT_CURRENT"
  # script(1) gives the function a terminal, so stty can open /dev/tty.
  PATH="$font_bin:$PATH" script -qec "bash -c 'source \"$ROOT/install/provisioning/setup-form.sh\"; omarchy_console_font $*'" /dev/null >/dev/null
}

if command -v script >/dev/null; then
  ON_VT=1 console_font
  [[ $(tail -n 1 "$FONT_CALLS") == "ter-v32n" ]] || fail "the Terminus size nearest 48 rows is loaded" "$(cat "$FONT_CALLS")"
  ! grep -q default8x16 "$FONT_CALLS" || fail "kbd's fonts are not tried when Terminus loads"

  ON_VT=1 console_font 200
  [[ $(tail -n 1 "$FONT_CALLS") == "ter-v24n" ]] || fail "a size must clear the columns the caller needs" "$(cat "$FONT_CALLS")"

  ON_VT=1 MISSING_FONTS="ter-v16n ter-v20n ter-v24n ter-v28n ter-v32n" console_font
  [[ $(tail -n 1 "$FONT_CALLS") == "latarcyrheb-sun32" ]] || fail "without Terminus, kbd's fonts are sized the same way" "$(cat "$FONT_CALLS")"

  console_font
  [[ ! -s $FONT_CALLS ]] || fail "off a real VT the font is left alone" "$(cat "$FONT_CALLS")"
  pass "the console font is Terminus, sized to the installer's feel, and only on a real VT"
else
  skip "no script(1) to give the console font a terminal"
fi
