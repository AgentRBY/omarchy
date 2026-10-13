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
for (const code of codes) {
  const entry = registry[code]
  assert(/^[a-z]{2,3}(-[A-Za-z]{2})?$/.test(code), `registry code ${code} is a language tag`)
  for (const field of ['name', 'englishName', 'formatLocale', 'locale'])
    assert(typeof entry[field] === 'string' && entry[field].length > 0, `registry ${code} has ${field}`)
  assert(/\.UTF-8$/.test(entry.locale), `registry ${code} locale is UTF-8`)
}

// The English menu catalog must mirror the shipped menu definition, so a
// relabeled row cannot leave translations pointing at stale English.
const enMenu = readJson('en/menu.json')
const menuItems = MenuModel.parseMenuJsonc(fs.readFileSync(path.join(root, 'default/omarchy/omarchy-menu.jsonc'), 'utf8'))
assertEqual(enMenu.root.label, 'Go', 'English menu catalog carries the injected root label')
assert(menuItems.some((item) => item.id === 'setup.language' && item.provider === 'languages'), 'Setup > Language row uses the languages provider')
for (const item of menuItems) {
  const source = enMenu[item.id]
  assert(source, `English menu catalog has ${item.id}`)
  assertEqual(source.label, item.label, `English menu catalog label for ${item.id} matches the menu`)
  if (item.title) assertEqual(source.title, item.title, `English menu catalog title for ${item.id} matches the menu`)
}
for (const id of Object.keys(enMenu))
  assert(id === 'root' || menuItems.some((item) => item.id === id), `English menu catalog has no orphan id ${id}`)

const placeholders = (value) => (String(value).match(/%(\d|s|%)/g) || []).sort().join(' ')
function assertCatalogMirrors(kind, english, catalog, code) {
  const enKeys = Object.keys(english).sort()
  assertDeepEqual(Object.keys(catalog).sort(), enKeys, `${code}/${kind}.json has exactly the English keys`)
  for (const key of enKeys) {
    if (kind === 'menu') {
      assertDeepEqual(Object.keys(catalog[key]).sort(), Object.keys(english[key]).sort(), `${code}/menu.json ${key} has the English fields`)
      for (const field of Object.keys(english[key]))
        assert(typeof catalog[key][field] === 'string' && catalog[key][field].length > 0, `${code}/menu.json ${key}.${field} is translated`)
    } else {
      assert(typeof catalog[key] === 'string' && catalog[key].length > 0, `${code}/${kind}.json ${key} is translated`)
      assertEqual(placeholders(catalog[key]), placeholders(english[key]), `${code}/${kind}.json ${key} keeps the English placeholders`)
    }
  }
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
const shellKeys = collectKeys(path.join(root, 'shell'), ['.qml', '.js'], /(?:I18n\.t|t)\("([a-z][a-zA-Z0-9]*(?:\.[a-zA-Z0-9]+)+)"/g)
for (const key of Object.keys(enShell)) assert(shellKeys.has(key), `shell key ${key} is referenced`)
for (const key of shellKeys) assert(Object.hasOwn(enShell, key), `referenced shell key ${key} exists in the English catalog`)

const cliKeys = collectKeys(path.join(root, 'bin'), [''], /omarchy-i18n ([a-z][a-zA-Z0-9]*(?:\.[a-zA-Z0-9]+)+)/g)
for (const key of Object.keys(enCli)) assert(cliKeys.has(key), `cli key ${key} is referenced`)
for (const key of cliKeys) assert(Object.hasOwn(enCli, key), `referenced cli key ${key} exists in the English catalog`)

// applyTranslations: translated labels win, English stays searchable,
// untranslated rows pass through, and nothing mutates the source items.
const defaults = MenuModel.parseMenuJsonc(JSON.stringify({
  setup: { label: 'Setup', aliases: ['settings'] },
  'setup.language': { label: 'Language', provider: 'languages' }
}))
const translated = MenuModel.applyTranslations(defaults, { setup: { label: 'Opsætning' } })
assertEqual(translated[0].label, 'Opsætning', 'applyTranslations replaces the label')
assert(translated[0].aliases.includes('Setup') && translated[0].aliases.includes('settings'), 'applyTranslations keeps English searchable')
assertEqual(translated[1].label, 'Language', 'applyTranslations leaves untranslated rows in English')
assertEqual(defaults[0].label, 'Setup', 'applyTranslations does not mutate its input')
const merged = MenuModel.mergeMenuSources(translated, MenuModel.parseMenuJsonc(JSON.stringify({ setup: { label: 'My Setup' } })))
assertEqual(merged.items.setup.label, 'My Setup', 'a user retitle wins over the translation')
assertDeepEqual(MenuModel.applyTranslations(defaults, null), defaults, 'a missing catalog degrades to English')

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
  assert(fs.existsSync(dir), `manual/${code} exists`)
  assertDeepEqual(fs.readdirSync(dir).filter((name) => name.endsWith('.md')).sort(), englishManual, `manual/${code} has every English chapter`)
  for (const file of englishManual)
    assert(fs.readFileSync(path.join(dir, file), 'utf8').trim().length > 0, `manual/${code}/${file} is translated`)
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

da_changed=$(jq -r '."language.changed"' "$ROOT/default/i18n/da/cli.json" | sed 's/%s/Dansk/')
assert_bash_equal "$(omarchy-i18n language.changed Dansk)" "$da_changed" "omarchy-i18n prints the current language with substitution"
assert_bash_equal "$(omarchy-i18n missing.key)" "missing.key" "omarchy-i18n passes unknown keys through"

grep -q "$da_changed" "$NOTIFY_LOG" && pass "the language-change notification arrives in the new language" || fail "the language-change notification arrives in the new language" "notify log: $(cat "$NOTIFY_LOG")"
