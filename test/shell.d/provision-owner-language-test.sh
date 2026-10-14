#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

# The language picked at install reaches the installed system. First-boot
# setup (configure_language, as omarchy-provision-owner defines it) generates
# its locale, sets LANG in /etc/locale.conf and records it in
# /etc/omarchy/language; user finalization (install/user/language.sh) then
# applies it to the user through `omarchy-language --no-session`. Both run
# against a fixture root, with locale-gen, locale and the session tools faked.

tmp=$(cd -- "$(mktemp -d)" && pwd -P)
trap 'rm -rf "$tmp"' EXIT

root=$tmp/root
stub_bin=$tmp/bin
calls=$tmp/calls
mkdir -p "$stub_bin"

cat >"$stub_bin/locale-gen" <<SH
#!/bin/bash
echo "locale-gen \$*" >>"$calls"
[[ ! -e "$tmp/locale-gen-fails" ]]
SH
cat >"$stub_bin/locale" <<SH
#!/bin/bash
[[ \$1 == -a ]] && cat "$tmp/generated" 2>/dev/null
exit 0
SH
for tool in dbus-update-activation-environment omarchy-notification-send sudo pkexec; do
  printf '#!/bin/bash\necho "%s $*" >>"%s"\n' "$tool" "$calls" >"$stub_bin/$tool"
done
chmod +x "$stub_bin"/*
export PATH="$stub_bin:$ROOT/bin:$PATH" OMARCHY_PATH="$ROOT"

{
  sed -n '/^configure_language() {/,/^}/p' "$ROOT/bin/omarchy-provision-owner"
  sed -n '/^omarchy_persist_language() {/,/^}/p' "$ROOT/install/provisioning/setup-form.sh"
} | sed "s|/etc/|$root/etc/|g" >"$tmp/language.sh"
grep -q '^configure_language() {' "$tmp/language.sh" || fail "omarchy-provision-owner defines configure_language"

fresh_root() {
  rm -rf "$root" "$calls" "$tmp/locale-gen-fails" "$tmp/log"
  mkdir -p "$root/etc"
  printf '#da_DK.UTF-8 UTF-8\n#de_DE.UTF-8 UTF-8\n#hi_IN UTF-8\nen_US.UTF-8 UTF-8\n' >"$root/etc/locale.gen"
  printf 'LANG=en_US.UTF-8\nLC_TIME=en_DK.UTF-8\n' >"$root/etc/locale.conf"
  : >"$calls"
}

configure() {
  LANGUAGE=$1 bash -c "
    set -euo pipefail
    source '$tmp/language.sh'
    log_step() { echo \"\$1\" >>'$tmp/log'; }
    language=\$LANGUAGE
    configure_language
  "
}

fresh_root
configure da || fail "configure_language succeeds"
grep -qx 'da_DK.UTF-8 UTF-8' "$root/etc/locale.gen" || fail "the language's locale is enabled in locale.gen" "$(cat "$root/etc/locale.gen")"
grep -qx '#de_DE.UTF-8 UTF-8' "$root/etc/locale.gen" || fail "other locales stay commented"
grep -q '^locale-gen' "$calls" || fail "the locale is generated"
[[ $(<"$root/etc/locale.conf") == $'LANG=da_DK.UTF-8\nLC_TIME=en_DK.UTF-8' ]] ||
  fail "LANG names the language's locale and other settings stay" "$(cat "$root/etc/locale.conf")"
[[ $(<"$root/etc/omarchy/language") == "da" ]] || fail "the language is recorded for user finalization"
pass "first-boot setup generates the locale, sets LANG and records the language"

fresh_root
configure hi || fail "a locale.gen entry without a codeset"
grep -qx 'hi_IN UTF-8' "$root/etc/locale.gen" || fail "an entry spelled without the codeset is enabled" "$(cat "$root/etc/locale.gen")"
fresh_root
configure fil || fail "a locale missing from locale.gen"
grep -qx 'fil_PH.UTF-8 UTF-8' "$root/etc/locale.gen" || fail "a missing entry is added" "$(cat "$root/etc/locale.gen")"
fresh_root
rm "$root/etc/locale.conf"
configure de || fail "no locale.conf yet"
[[ $(<"$root/etc/locale.conf") == "LANG=de_DE.UTF-8" ]] || fail "a missing locale.conf is created" "$(cat "$root/etc/locale.conf")"
pass "locale.gen spellings and a missing locale.conf are handled"

fresh_root
configure xx || fail "an unknown language does not fail setup"
[[ ! -e $root/etc/omarchy/language && ! -s $calls ]] || fail "an unknown language changes nothing"
grep -qx 'LANG=en_US.UTF-8' "$root/etc/locale.conf" || fail "an unknown language keeps LANG"
grep -q 'unknown language xx' "$tmp/log" || fail "an unknown language is logged"
fresh_root
touch "$tmp/locale-gen-fails"
configure da || fail "a failed locale-gen does not fail setup"
grep -qx 'LANG=en_US.UTF-8' "$root/etc/locale.conf" || fail "LANG never names a locale that failed to generate"
pass "an unknown language or a failed locale-gen leaves the system locale alone"

provision_owner=$ROOT/bin/omarchy-provision-owner
run_provisioning=$(sed -n '/^run_provisioning() {/,/^}/p' "$provision_owner")
(( $(grep -n '^  configure_language$' <<<"$run_provisioning" | cut -d: -f1) < $(grep -n '^  if ! finalize_user; then' <<<"$run_provisioning" | cut -d: -f1) )) ||
  fail "the language is configured before user finalization applies it"
sed -n '/^finalize_user() {/,/^}/p' "$provision_owner" | grep -q 'env -u OMARCHY_LANGUAGE_FILE' ||
  fail "user finalization does not inherit the setup form's language file"
grep -q '^run_logged "$OMARCHY_INSTALL/user/language.sh"$' "$ROOT/install/user/all.sh" ||
  fail "user finalization runs the language step"
pass "first-boot setup records the language before user finalization, which applies it"

# install/user/language.sh, as run_logged sources it, for a user with no
# session yet.
home=$tmp/home
sed "s|/etc/|$root/etc/|g" "$ROOT/install/user/language.sh" >"$tmp/user-language.sh"

user_step() {
  HOME=$home XDG_CONFIG_HOME= bash -eE -c 'source "$1"' bash "$tmp/user-language.sh" 2>"$tmp/user-err"
}

fresh_user() {
  fresh_root
  rm -rf "$home"
  mkdir -p "$home" "$root/etc/omarchy"
  printf 'da_DK.utf8\nen_US.utf8\n' >"$tmp/generated"
}

fresh_user
echo da >"$root/etc/omarchy/language"
user_step || fail "the language step succeeds" "$(cat "$tmp/user-err")"
[[ $(<"$home/.config/omarchy/language") == "da" ]] || fail "the install language becomes the user's"
grep -qx 'export LANG=da_DK.UTF-8' "$home/.config/uwsm/env.d/50-omarchy-language" || fail "the first login gets the language's LANG"
[[ ! -s $calls ]] || fail "no notification, session update or password prompt for a user with no session" "$(cat "$calls")"
pass "the install language becomes the user's, with no session to notify"

fresh_user
echo da >"$root/etc/omarchy/language"
mkdir -p "$home/.config/omarchy"
echo de >"$home/.config/omarchy/language"
user_step || fail "the language step with a language already chosen"
[[ $(<"$home/.config/omarchy/language") == "de" && ! -e $home/.config/uwsm ]] || fail "a language the user chose stays"
pass "a language the user already chose stays"

fresh_user
echo pl >"$root/etc/omarchy/language"
user_step || fail "an ungenerated locale does not fail the install"
[[ ! -e $home/.config/omarchy/language && ! -e $home/.config/uwsm ]] || fail "an ungenerated locale applies nothing"
[[ ! -s $calls ]] || fail "an ungenerated locale never asks for a password" "$(cat "$calls")"
grep -q 'pl_PL.UTF-8 locale is not generated' "$tmp/user-err" || fail "an ungenerated locale is reported" "$(cat "$tmp/user-err")"
pass "a locale the install did not generate is reported, not elevated for"

fresh_user
user_step || fail "the language step without an install language"
[[ ! -e $home/.config ]] || fail "without an install language nothing is written"
pass "without an install language the user keeps the default"

if omarchy-language --no-session 2>/dev/null; then fail "--no-session needs a language code"; fi
if omarchy-language --no-session list 2>/dev/null; then fail "--no-session only sets a language"; fi
pass "--no-session only sets a language"
