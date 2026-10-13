#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

# --- Catalog completeness, placeholder parity, and menu translation logic ---

run_node_test <<'JS'
const fs = require('fs')
const MenuModel = requireFromRoot('shell/plugins/menu/MenuModel.js')

const i18nDir = path.join(root, 'default/i18n')
const readJson = (rel) => JSON.parse(fs.readFileSync(path.join(i18nDir, rel), 'utf8'))

const registry = readJson('locales.json')
const codes = Object.keys(registry)
assertEqual(codes.length, 50, 'i18n registry holds 50 languages')
assert(codes[0] === 'en', 'i18n registry lists English first (the default)')
const badRegistry = codes.filter((code) => !/^[a-z]{2,3}(-[A-Za-z]{2})?$/.test(code)
  || ['name', 'englishName', 'formatLocale', 'locale'].some((f) => typeof registry[code][f] !== 'string' || registry[code][f].length === 0)
  || !/\.UTF-8$/.test(registry[code].locale))
assert(badRegistry.length === 0, 'every registry entry is complete with a UTF-8 locale', JSON.stringify(badRegistry))

// The English menu catalog must mirror the shipped menu definition, so a
// relabeled row cannot leave translations pointing at stale English.
const enMenu = readJson('en/menu.json')
const menuItems = MenuModel.parseMenuJsonc(fs.readFileSync(path.join(root, 'default/omarchy/omarchy-menu.jsonc'), 'utf8'))
assertEqual(enMenu.root.label, 'Go', 'English menu catalog carries the injected root label')
assert(menuItems.some((item) => item.id === 'setup.language' && item.provider === 'languages'), 'Setup > Language row uses the languages provider')
const staleMenu = menuItems.filter((item) => !enMenu[item.id] || enMenu[item.id].label !== item.label || (item.title && enMenu[item.id].title !== item.title) || (item.description && enMenu[item.id].description !== item.description))
assert(staleMenu.length === 0, 'English menu catalog mirrors the menu definition', JSON.stringify(staleMenu.map((i) => i.id)))
const orphanMenu = Object.keys(enMenu).filter((id) => id !== 'root' && !menuItems.some((item) => item.id === id))
assert(orphanMenu.length === 0, 'English menu catalog has no orphan ids', JSON.stringify(orphanMenu))

// I18N_STRUCTURAL=1 is the pull-request gate: individual PRs only add the
// English side, so missing translations are pending work for the sync
// workflow rather than failures. Structure must still hold either way.
const structural = process.env.I18N_STRUCTURAL === '1'
const placeholders = (value) => (String(value).match(/%(\d|s|%)/g) || []).sort().join(' ')
function assertCatalogMirrors(kind, english, catalog, code) {
  const problems = []
  const enKeys = Object.keys(english).sort()
  if (!structural && JSON.stringify(Object.keys(catalog).sort()) !== JSON.stringify(enKeys)) problems.push('key set differs')
  for (const key of Object.keys(catalog))
    if (!Object.hasOwn(english, key)) problems.push(`${key}: not in the English catalog`)
  for (const key of enKeys) {
    if (!Object.hasOwn(catalog, key)) continue
    if (kind === 'menu') {
      if (!structural && JSON.stringify(Object.keys(catalog[key]).sort()) !== JSON.stringify(Object.keys(english[key]).sort())) problems.push(`${key}: fields differ`)
      else if (Object.keys(catalog[key]).some((f) => !Object.hasOwn(english[key], f) || typeof catalog[key][f] !== 'string' || catalog[key][f].length === 0)) problems.push(`${key}: invalid field`)
      else if (!structural && Object.keys(english[key]).some((f) => typeof catalog[key][f] !== 'string' || catalog[key][f].length === 0)) problems.push(`${key}: untranslated field`)
    } else if (typeof catalog[key] !== 'string' || catalog[key].length === 0) problems.push(`${key}: untranslated`)
    else if (placeholders(catalog[key]) !== placeholders(english[key])) problems.push(`${key}: placeholders differ`)
    if (problems.length > 5) break
  }
  assert(problems.length === 0, `${code}/${kind}.json ${structural ? 'is structurally sound' : 'mirrors the English catalog'}`, JSON.stringify(problems))
}

const enShell = readJson('en/shell.json')
const enCli = readJson('en/cli.json')
for (const code of codes) {
  if (code === 'en') continue
  assertCatalogMirrors('menu', enMenu, readJson(`${code}/menu.json`), code)
  assertCatalogMirrors('shell', enShell, readJson(`${code}/shell.json`), code)
  assertCatalogMirrors('cli', enCli, readJson(`${code}/cli.json`), code)
}

// Every catalog key must be referenced by the code that displays it, and
// every referenced key must exist in the English catalog.
function collectKeys(dir, extensions, pattern) {
  const found = new Set()
  const walk = (current) => {
    for (const entry of fs.readdirSync(current, { withFileTypes: true })) {
      const full = path.join(current, entry.name)
      if (entry.isDirectory()) walk(full)
      else if (extensions.some((ext) => entry.name.endsWith(ext))) {
        for (const match of fs.readFileSync(full, 'utf8').matchAll(pattern)) found.add(match[1])
      }
    }
  }
  walk(dir)
  return found
}
const shellKeys = collectKeys(path.join(root, 'shell'), ['.qml', '.js'], /(?:I18n\.t|[^a-zA-Z_.]t|translator\(tr\))\("([a-z][a-zA-Z0-9]*(?:\.[a-zA-Z0-9]+)+)"/g)
const unreferencedShell = Object.keys(enShell).filter((key) => !shellKeys.has(key))
assert(unreferencedShell.length === 0, 'every shell catalog key is referenced', JSON.stringify(unreferencedShell))
const unknownShell = [...shellKeys].filter((key) => !Object.hasOwn(enShell, key))
assert(unknownShell.length === 0, 'every referenced shell key exists in the English catalog', JSON.stringify(unknownShell))

const cliKeys = collectKeys(path.join(root, 'bin'), [''], /omarchy-i18n ([a-z][a-zA-Z0-9]*(?:\.[a-zA-Z0-9]+)+)/g)
const unreferencedCli = Object.keys(enCli).filter((key) => !cliKeys.has(key))
assert(unreferencedCli.length === 0, 'every cli catalog key is referenced', JSON.stringify(unreferencedCli))
const unknownCli = [...cliKeys].filter((key) => !Object.hasOwn(enCli, key))
assert(unknownCli.length === 0, 'every referenced cli key exists in the English catalog', JSON.stringify(unknownCli))

// applyTranslations: translated labels win, English stays searchable,
// untranslated rows pass through, and nothing mutates the source items.
const defaults = MenuModel.parseMenuJsonc(JSON.stringify({
  setup: { label: 'Setup', aliases: ['settings'] },
  'setup.language': { label: 'Language', provider: 'languages' }
}))
const translated = MenuModel.applyTranslations(defaults, { setup: { label: 'Opsætning' } })
assertEqual(translated[0].label, 'Opsætning', 'applyTranslations replaces the label')
assert(translated[0].searchTerms.includes('Setup') && translated[0].aliases.includes('settings') && !translated[0].aliases.includes('Setup'), 'applyTranslations keeps English searchable but not routable')
assertEqual(translated[1].label, 'Language', 'applyTranslations leaves untranslated rows in English')
assertEqual(defaults[0].label, 'Setup', 'applyTranslations does not mutate its input')
const merged = MenuModel.mergeMenuSources(translated, MenuModel.parseMenuJsonc(JSON.stringify({ setup: { label: 'My Setup' } })))
assertEqual(merged.items.setup.label, 'My Setup', 'a user retitle wins over the translation')
assertDeepEqual(MenuModel.applyTranslations(defaults, null), defaults, 'a missing catalog degrades to English')

// Routing must not depend on the display language: English labels live in
// searchTerms, which resolveRoute never reads, so a word that is inert in
// English cannot become a command in another language.
const daMenu = readJson('da/menu.json')
const enMerged = MenuModel.mergeMenuSources(menuItems, [])
const daMerged = MenuModel.mergeMenuSources(MenuModel.applyTranslations(menuItems, daMenu), [])
for (const route of ['reboot', 'shutdown', 'logout', 'hibernate', 'lock', 'clock', 'danish', 'setup', 'settings', 'power-menu', 'language'])
  assertEqual(MenuModel.resolveRoute(daMerged.items, daMerged.itemOrder, route), MenuModel.resolveRoute(enMerged.items, enMerged.itemOrder, route), `route "${route}" resolves the same in Danish as in English`)
assert(MenuModel.nameSearchText(daMerged.items.setup).includes('setup'), 'English labels remain searchable in Danish')

// JS models translate through the optional tr argument and stay English
// without one (the audio/monitor/clipboard tests assert the same English).
const daShell = readJson('da/shell.json')
const tr = (key, english) => daShell[key] || english
const audio = requireFromRoot('shell/plugins/panels/audio/Model.js')
assertEqual(audio.outputVolumeName(0.5, true, tr), daShell['audio.level.muted'], 'audio levels translate through tr')
const clipboard = requireFromRoot('shell/plugins/clipboard/ClipboardHistory.js')
const daRow = clipboard.displayRows([{ type: 'image', path: '/tmp/a.png', mime: 'image/png', capturedAt: 'Friday 14:42' }], '', 50, tr)[0]
assertEqual(daRow.previewText, daShell['clipboard.screenshotFrom'].replace('%1', 'Friday 14:42'), 'clipboard previews translate through tr')

// The manual ships whole per language: same files as English, none empty.
const manualDir = path.join(root, 'manual')
const englishManual = fs.readdirSync(manualDir).filter((name) => name.endsWith('.md')).sort()
assert(englishManual.length > 0, 'English manual exists')
for (const code of codes) {
  if (code === 'en') continue
  const dir = path.join(manualDir, code)
  if (!fs.existsSync(dir)) {
    assert(structural, `manual/${code} exists`)
    continue
  }
  const chapters = fs.readdirSync(dir).filter((name) => name.endsWith('.md')).sort()
  const extra = chapters.filter((file) => !englishManual.includes(file))
  const empty = chapters.filter((file) => fs.readFileSync(path.join(dir, file), 'utf8').trim().length === 0)
  if (structural) {
    assert(extra.length === 0 && empty.length === 0, `manual/${code} chapters are a translated subset of English`, JSON.stringify([...extra, ...empty]))
  } else {
    const missing = englishManual.filter((file) => !chapters.includes(file))
    assert(JSON.stringify(chapters) === JSON.stringify(englishManual) && empty.length === 0, `manual/${code} has every English chapter translated`, JSON.stringify([...missing, ...empty]))
  }
}
JS

# --- omarchy-language and omarchy-i18n behavior ---

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
export OMARCHY_PATH=$ROOT
export PATH="$ROOT/bin:$PATH"
export OMARCHY_LANGUAGE_FILE=$work/language
export OMARCHY_LOCALE_CONF=$work/locale.conf
export OMARCHY_LOCALE_GEN=$work/locale.gen
printf 'LANG=en_US.UTF-8\nLC_TIME=C\n' >"$OMARCHY_LOCALE_CONF"
printf '#da_DK.UTF-8 UTF-8\n' >"$OMARCHY_LOCALE_GEN"

# Stub the outside world: locale-gen records its argument, notifications
# record their text, and omarchy-language itself is the real one via PATH.
mkdir -p "$work/stubs"
cat >"$work/stubs/locale-gen" <<'STUB'
#!/bin/bash
echo "$@" >>"$LOCALE_GEN_LOG"
STUB
cat >"$work/stubs/omarchy-notification-send" <<'STUB'
#!/bin/bash
echo "$@" >>"$NOTIFY_LOG"
STUB
cat >"$work/stubs/locale" <<'STUB'
#!/bin/bash
if [[ $1 == "-a" ]]; then echo "en_US.utf8"; else echo "LANG=en_US.UTF-8"; fi
STUB
chmod +x "$work/stubs/"*
export PATH="$work/stubs:$PATH"
export LOCALE_GEN_LOG=$work/locale-gen.log NOTIFY_LOG=$work/notify.log
: >"$LOCALE_GEN_LOG"; : >"$NOTIFY_LOG"

assert_bash_equal() {
  if [[ $1 != "$2" ]]; then
    fail "$3" "expected [$2], got [$1]"
  fi
  pass "$3"
}

assert_bash_equal "$(omarchy-language)" "en" "omarchy-language defaults to English with no language file"
echo "bogus" >"$OMARCHY_LANGUAGE_FILE"
assert_bash_equal "$(omarchy-language)" "en" "omarchy-language falls back to English for an unknown code"
rm -f "$OMARCHY_LANGUAGE_FILE"

list=$(omarchy-language list)
assert_bash_equal "$(printf '%s\n' "$list" | wc -l)" "50" "omarchy-language list prints 50 rows"
assert_bash_equal "$(printf '%s\n' "$list" | head -n 1 | cut -f2)" "en" "omarchy-language list puts English first"
assert_bash_equal "$(omarchy-language locale da)" "da_DK.UTF-8" "omarchy-language locale maps da to its glibc locale"

# stdin is not a tty here, but --apply is the in-terminal continuation, so
# exercise the full set path through it.
omarchy-language da --apply </dev/null
assert_bash_equal "$(cat "$OMARCHY_LANGUAGE_FILE")" "da" "omarchy-language persists the choice"
assert_bash_equal "$(omarchy-language)" "da" "omarchy-language reads the persisted choice"
assert_bash_equal "$(grep '^LANG=' "$OMARCHY_LOCALE_CONF")" "LANG=da_DK.UTF-8" "omarchy-language sets LANG in locale.conf"
assert_bash_equal "$(grep '^LC_TIME=' "$OMARCHY_LOCALE_CONF")" "LC_TIME=C" "omarchy-language leaves LC_* lines alone"
assert_bash_equal "$(grep '^da_DK.UTF-8' "$OMARCHY_LOCALE_GEN")" "da_DK.UTF-8 UTF-8" "omarchy-language enables the locale in locale.gen"
assert_bash_equal "$(cat "$LOCALE_GEN_LOG")" "da_DK.UTF-8" "omarchy-language generates the locale"

if omarchy-language xx </dev/null 2>/dev/null; then
  fail "omarchy-language rejects unknown codes"
else
  pass "omarchy-language rejects unknown codes"
fi

da_changed=$(jq -r '."language.changed"' "$ROOT/default/i18n/da/cli.json" | sed 's/%1/Dansk/')
assert_bash_equal "$(omarchy-i18n language.changed Dansk)" "$da_changed" "omarchy-i18n prints the current language with substitution"
assert_bash_equal "$(omarchy-i18n missing.key)" "missing.key" "omarchy-i18n passes unknown keys through"

grep -q "$da_changed" "$NOTIFY_LOG" && pass "the language-change notification arrives in the new language" || fail "the language-change notification arrives in the new language" "notify log: $(cat "$NOTIFY_LOG")"

da_battery=$(jq -r '."battery.lowBody"' "$ROOT/default/i18n/da/cli.json" | sed 's/%1/12/')
assert_bash_equal "$(omarchy-i18n battery.lowBody 12)" "$da_battery" "omarchy-i18n substitutes %1 and keeps a literal percent sign"

# With the locale already generated and LANG already set, picking the
# language needs no privilege at all: no terminal handoff, no locale-gen.
cat >"$work/stubs/locale" <<'STUB'
#!/bin/bash
if [[ $1 == "-a" ]]; then printf 'en_US.utf8\nda_DK.utf8\n'; else echo "LANG=da_DK.UTF-8"; fi
STUB
cat >"$work/stubs/omarchy-launch-floating-terminal-with-presentation" <<'STUB'
#!/bin/bash
echo "$@" >>"$LAUNCH_LOG"
STUB
chmod +x "$work/stubs/locale" "$work/stubs/omarchy-launch-floating-terminal-with-presentation"
export LAUNCH_LOG=$work/launch.log
: >"$LOCALE_GEN_LOG"; : >"$LAUNCH_LOG"
printf 'LANG=da_DK.UTF-8\nLC_TIME=C\n' >"$OMARCHY_LOCALE_CONF"
rm -f "$OMARCHY_LANGUAGE_FILE"
omarchy-language da </dev/null
assert_bash_equal "$(cat "$OMARCHY_LANGUAGE_FILE")" "da" "already-applied locale switches without a terminal"
assert_bash_equal "$(cat "$LOCALE_GEN_LOG")" "" "already-generated locale is not regenerated"
assert_bash_equal "$(cat "$LAUNCH_LOG")" "" "no terminal handoff when nothing privileged is needed"

# With LANG still to change, a launch without a terminal must hand off to
# one instead of running sudo blind — and must not persist the choice yet.
printf 'LANG=en_US.UTF-8\nLC_TIME=C\n' >"$OMARCHY_LOCALE_CONF"
rm -f "$OMARCHY_LANGUAGE_FILE"
omarchy-language da </dev/null
assert_bash_equal "$(cat "$LAUNCH_LOG")" "omarchy-language da --apply" "privileged locale work hands off to a terminal"
[[ ! -f $OMARCHY_LANGUAGE_FILE ]] && pass "the choice is not persisted before the locale applies" || fail "the choice is not persisted before the locale applies"

# --- Translation sync tooling (scripts/i18n-sync.py) ---

require_command python3

if [[ ${I18N_STRUCTURAL:-} == "1" ]]; then
  skip "no translations are pending (structural mode)"
else
  pending_locales=$(python3 "$ROOT/scripts/i18n-sync.py" pending | jq -c '.locales')
  assert_bash_equal "$pending_locales" "[]" "no translations are pending"
fi

extract_candidates=$(python3 "$ROOT/scripts/i18n-sync.py" extract-scan | jq -c '.candidates | length')
assert_bash_equal "$extract_candidates" "0" "no embedded English literals await extraction"

# A miniature tree exercises staleness: one key changed in English, one
# deleted from the translation, one manual chapter missing.
fix=$work/fixture
mkdir -p "$fix/default/i18n/en" "$fix/default/i18n/da" "$fix/default/omarchy" "$fix/manual" "$fix/shell" "$fix/bin"
cat >"$fix/default/i18n/locales.json" <<'FIXJSON'
{
  "en": {"name": "English", "englishName": "English", "formatLocale": "en-US", "locale": "en_US.UTF-8"},
  "da": {"name": "Dansk", "englishName": "Danish", "formatLocale": "da-DK", "locale": "da_DK.UTF-8"}
}
FIXJSON
printf '{\n  "a.one": "One",\n  "a.two": "Two"\n}\n' >"$fix/default/i18n/en/shell.json"
printf '{}\n' >"$fix/default/i18n/en/cli.json"
printf '{\n  "root": {\n    "label": "Go"\n  }\n}\n' >"$fix/default/i18n/en/menu.json"
printf '{}\n' >"$fix/default/omarchy/omarchy-menu.jsonc"
printf '{\n  "strings": [],\n  "files": []\n}\n' >"$fix/default/i18n/extract-allowlist.json"
printf '{\n  "a.one": "En",\n  "a.two": "To"\n}\n' >"$fix/default/i18n/da/shell.json"
printf '{}\n' >"$fix/default/i18n/da/cli.json"
printf '{\n  "root": {\n    "label": "Gaa"\n  }\n}\n' >"$fix/default/i18n/da/menu.json"
printf '# Hello\n\nWorld.\n' >"$fix/manual/01-hello.md"
mkdir -p "$fix/manual/da"
printf '# Hej\n\nVerden.\n' >"$fix/manual/da/01-hello.md"
python3 "$ROOT/scripts/i18n-sync.py" --root "$fix" manifest >/dev/null
assert_bash_equal "$(python3 "$ROOT/scripts/i18n-sync.py" --root "$fix" pending | jq -c '.locales')" "[]" "sync fixture starts with nothing pending"

printf '{\n  "a.one": "One changed",\n  "a.two": "Two"\n}\n' >"$fix/default/i18n/en/shell.json"
printf '{\n  "a.two": "To"\n}\n' >"$fix/default/i18n/da/shell.json"
printf '# New\n' >"$fix/manual/02-new.md"
pending_units=$(python3 "$ROOT/scripts/i18n-sync.py" --root "$fix" pending | jq -c '.jobs.da.pending | sort')
assert_bash_equal "$pending_units" '["manual:02-new.md","shell:a.one"]' "sync detects changed English and missing chapters"

printf 'Text {\n  text: "Brand new string"\n}\n' >"$fix/shell/Panel.qml"
scan_strings=$(python3 "$ROOT/scripts/i18n-sync.py" --root "$fix" extract-scan | jq -c '[.candidates[].string]')
assert_bash_equal "$scan_strings" '["Brand new string"]' "extract-scan finds embedded English literals"

# Every registry locale must be one glibc can actually generate.
if [[ -f /usr/share/i18n/SUPPORTED ]]; then
  unsupported=""
  while read -r loc; do
    grep -qE "^${loc%.UTF-8}(\.UTF-8)? UTF-8" /usr/share/i18n/SUPPORTED || unsupported="$unsupported $loc"
  done < <(jq -r '.[].locale' "$ROOT/default/i18n/locales.json")
  assert_bash_equal "$unsupported" "" "every registry locale exists in glibc SUPPORTED"
else
  skip "every registry locale exists in glibc SUPPORTED"
fi
