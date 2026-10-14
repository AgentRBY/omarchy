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
// workflow rather than failures. So are translations the manifest marks
// stale (their English changed since) and orphans awaiting pruning —
// an English-only edit must never wedge on 49 other languages. Structure
// of what IS current must still hold either way.
const structural = process.env.I18N_STRUCTURAL === '1'
const crypto = require('crypto')
const manifest = readJson('translation-manifest.json')
const sourceHash = (value) => crypto.createHash('sha256').update(value, 'utf8').digest('hex').slice(0, 12)
const isStale = (code, unit, englishValue) => !manifest[code] || manifest[code][unit] !== sourceHash(englishValue)
// Only %1-style tokens count, as in scripts/i18n-sync.py: nothing escapes a
// percent sign, and Turkish writes it before the number ("%%2" shows "%80").
const placeholders = (value) => (String(value).match(/%\d/g) || []).sort().join(' ')
function assertCatalogMirrors(kind, english, catalog, code) {
  const problems = []
  const enKeys = Object.keys(english).sort()
  if (!structural && JSON.stringify(Object.keys(catalog).sort()) !== JSON.stringify(enKeys)) problems.push('key set differs')
  if (!structural)
    for (const key of Object.keys(catalog))
      if (!Object.hasOwn(english, key)) problems.push(`${key}: not in the English catalog`)
  for (const key of enKeys) {
    if (!Object.hasOwn(catalog, key)) continue
    if (kind === 'menu') {
      const staleField = (f) => structural && Object.hasOwn(english[key], f) && isStale(code, `menu:${key}.${f}`, english[key][f])
      if (!structural && JSON.stringify(Object.keys(catalog[key]).sort()) !== JSON.stringify(Object.keys(english[key]).sort())) problems.push(`${key}: fields differ`)
      else if (Object.keys(catalog[key]).some((f) => (Object.hasOwn(english[key], f) || !structural) && (typeof catalog[key][f] !== 'string' || catalog[key][f].length === 0))) problems.push(`${key}: invalid field`)
      else if (Object.keys(catalog[key]).some((f) => Object.hasOwn(english[key], f) && placeholders(catalog[key][f]) !== placeholders(english[key][f]) && !staleField(f))) problems.push(`${key}: placeholders differ`)
      else if (!structural && Object.keys(english[key]).some((f) => typeof catalog[key][f] !== 'string' || catalog[key][f].length === 0)) problems.push(`${key}: untranslated field`)
    } else if (typeof catalog[key] !== 'string' || catalog[key].length === 0) problems.push(`${key}: untranslated`)
    else if (placeholders(catalog[key]) !== placeholders(english[key]) && !(structural && isStale(code, `${kind}:${key}`, english[key]))) problems.push(`${key}: placeholders differ`)
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
      if (entry.isDirectory()) { if (entry.name !== '__pycache__') walk(full) }
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
const customRoot = MenuModel.mergeMenuSources(translated, MenuModel.parseMenuJsonc(JSON.stringify({ root: { label: 'My Menu' } })), 'Gå')
assertEqual(customRoot.items.root.label, 'My Menu', 'a user-supplied root heading wins over the catalog label')
const injectedRoot = MenuModel.mergeMenuSources(translated, [], 'Gå')
assertEqual(injectedRoot.items.root.label, 'Gå', 'the injected root heading uses the catalog label')
assertEqual(MenuModel.mergeMenuSources(translated, []).items.root.label, 'Go', 'the injected root heading defaults to Go without a catalog')
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

// The manual ships whole per language: same files as English, none empty,
// and the machine-significant parts of every chapter preserved — code block
// contents, URLs, relative link destinations, and commands or paths in
// inline code. Prose, link text, and synopsis placeholders in <...> or
// [...] may be localized. In structural mode, chapters the manifest marks
// stale are exempt: their repair is pending sync work, not corruption.
const manualDir = path.join(root, 'manual')
const englishManual = fs.readdirSync(manualDir).filter((name) => name.endsWith('.md')).sort()
assert(englishManual.length > 0, 'English manual exists')
const englishTexts = {}
for (const file of englishManual) englishTexts[file] = fs.readFileSync(path.join(manualDir, file), 'utf8')
const bagOf = (items) => JSON.stringify([...items].sort())
const fencesOf = (text) => [...text.matchAll(/```[^\n]*\n([\s\S]*?)```/g)].map((m) => m[1])
const urlsOf = (text) => text.match(/https?:\/\/[^\s)]+/g) || []
const relDestsOf = (text) => [...text.matchAll(/\]\((?!<?https?:\/\/)([^)\s]+)/g)].map((m) => m[1])
const protectedInlineOf = (text) => [...text.matchAll(/`([^`\n]+)`/g)].map((m) => m[1])
  .filter((span) => /[/~$]/.test(span) || span.startsWith('omarchy ') || span.startsWith('omarchy-'))
  .map((span) => span.replace(/<[^>]+>/g, '<>').replace(/\[[^\]]+\]/g, '[]'))
function manualProblems(english, translatedText) {
  const problems = []
  if ((english.match(/^#{1,6} /gm) || []).length !== (translatedText.match(/^#{1,6} /gm) || []).length) problems.push('heading count changed')
  if (bagOf(urlsOf(english)) !== bagOf(urlsOf(translatedText))) problems.push('URLs changed')
  if (bagOf(fencesOf(english)) !== bagOf(fencesOf(translatedText))) problems.push('code block contents changed')
  if (bagOf(relDestsOf(english)) !== bagOf(relDestsOf(translatedText))) problems.push('relative link destinations changed')
  if (bagOf(protectedInlineOf(english)) !== bagOf(protectedInlineOf(translatedText))) problems.push('commands or paths in inline code changed')
  return problems
}
const fencedChapter = englishManual.find((file) => englishTexts[file].includes('```'))
assert(manualProblems(englishTexts[fencedChapter], englishTexts[fencedChapter].replace(/```[^\n]*\n/, '$&echo tampered\n')).length > 0, 'the manual integrity check catches a changed code block')
const linkedChapter = englishManual.find((file) => /\]\(\d\d-[a-z0-9-]+\.md\)/.test(englishTexts[file]))
assert(manualProblems(englishTexts[linkedChapter], englishTexts[linkedChapter].replace(/\]\(\d\d-[a-z0-9-]+\.md\)/, '](99-missing.md)')).length > 0, 'the manual integrity check catches a broken chapter link')
for (const code of codes) {
  if (code === 'en') continue
  const dir = path.join(manualDir, code)
  if (!fs.existsSync(dir)) {
    assert(structural, `manual/${code} exists`)
    continue
  }
  const chapters = fs.readdirSync(dir).filter((name) => name.endsWith('.md')).sort()
  const texts = {}
  for (const file of chapters) texts[file] = fs.readFileSync(path.join(dir, file), 'utf8')
  const extra = chapters.filter((file) => !englishManual.includes(file))
  const empty = chapters.filter((file) => texts[file].trim().length === 0)
  const broken = []
  for (const file of chapters) {
    if (!Object.hasOwn(englishTexts, file)) continue
    if (structural && isStale(code, `manual:${file}`, englishTexts[file])) continue
    for (const problem of manualProblems(englishTexts[file], texts[file])) broken.push(`${file}: ${problem}`)
    if (broken.length > 5) break
  }
  assert(broken.length === 0, `manual/${code} preserves commands, links, and code blocks`, JSON.stringify(broken.slice(0, 5)))
  if (structural) {
    // Extra chapters are prune-pending (their English was deleted or renamed).
    assert(empty.length === 0, `manual/${code} chapters present are translated`, JSON.stringify(empty))
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
# sudo and pkexec record which one elevated, then run the command as-is.
for elevator in sudo pkexec; do
  cat >"$work/stubs/$elevator" <<STUB
#!/bin/bash
echo "$elevator \$1" >>"\$ELEVATE_LOG"
exec "\$@"
STUB
done
chmod +x "$work/stubs/"*
export PATH="$work/stubs:$PATH"
export LOCALE_GEN_LOG=$work/locale-gen.log NOTIFY_LOG=$work/notify.log ELEVATE_LOG=$work/elevate.log
: >"$LOCALE_GEN_LOG"; : >"$NOTIFY_LOG"; : >"$ELEVATE_LOG"

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

# stdin is not a tty here, as when picked from the menu, so the privileged
# half goes through polkit rather than a terminal sudo prompt.
omarchy-language da </dev/null
assert_bash_equal "$(cat "$ELEVATE_LOG")" "pkexec /bin/bash" "omarchy-language elevates through pkexec without a terminal"
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

da_changed_raw=$(jq -r '."language.changed"' "$ROOT/default/i18n/da/cli.json")
assert_bash_equal "$(omarchy-i18n language.changed 'Research & Development')" "${da_changed_raw//%1/"Research & Development"}" "omarchy-i18n keeps ampersands in arguments literal"

# With the locale already generated and LANG already set, picking the
# language needs no privilege at all: no password prompt, no locale-gen.
cat >"$work/stubs/locale" <<'STUB'
#!/bin/bash
if [[ $1 == "-a" ]]; then printf 'en_US.utf8\nda_DK.utf8\n'; else echo "LANG=da_DK.UTF-8"; fi
STUB
chmod +x "$work/stubs/locale"
: >"$LOCALE_GEN_LOG"; : >"$ELEVATE_LOG"
printf 'LANG=da_DK.UTF-8\nLC_TIME=C\n' >"$OMARCHY_LOCALE_CONF"
rm -f "$OMARCHY_LANGUAGE_FILE"
omarchy-language da </dev/null
assert_bash_equal "$(cat "$OMARCHY_LANGUAGE_FILE")" "da" "already-applied locale switches without elevating"
assert_bash_equal "$(cat "$LOCALE_GEN_LOG")" "" "already-generated locale is not regenerated"
assert_bash_equal "$(cat "$ELEVATE_LOG")" "" "no password prompt when nothing privileged is needed"

# A generated locale with LANG still to change elevates once, only to set LANG.
printf 'LANG=en_US.UTF-8\nLC_TIME=C\n' >"$OMARCHY_LOCALE_CONF"
omarchy-language da </dev/null
assert_bash_equal "$(grep '^LANG=' "$OMARCHY_LOCALE_CONF")" "LANG=da_DK.UTF-8" "a generated locale still gets LANG set"
assert_bash_equal "$(cat "$LOCALE_GEN_LOG")" "" "setting LANG alone does not run locale-gen"

# A cancelled polkit prompt must not persist the choice, or the interface
# would switch with LANG left behind.
cat >"$work/stubs/pkexec" <<'STUB'
#!/bin/bash
exit 126
STUB
printf 'LANG=en_US.UTF-8\nLC_TIME=C\n' >"$OMARCHY_LOCALE_CONF"
rm -f "$OMARCHY_LANGUAGE_FILE"
if omarchy-language da </dev/null 2>/dev/null; then
  fail "a cancelled password prompt fails the switch"
else
  pass "a cancelled password prompt fails the switch"
fi
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

# Any display-text property name counts, both arms of a ternary count, and a
# bare list item counts; identifiers and lines marked "i18n: ignore" do not.
cat >"$fix/shell/Panel.qml" <<'QML'
Item {
  activeTooltipText: "Allow notifications"
  leftLabel: busy ? "Working" : "Ready now"
  readonly property var phrases: [
    "Hoarding joules",
    "Braiding packets"
  ]
  colorRole: "bar.text"
  property string statusText: "Checking…"  // i18n: ignore
}
QML
scan_strings=$(python3 "$ROOT/scripts/i18n-sync.py" --root "$fix" extract-scan | jq -c '[.candidates[].string]')
assert_bash_equal "$scan_strings" '["Allow notifications","Working","Ready now","Hoarding joules","Braiding packets"]' "extract-scan catches any display property, ternaries, and phrase lists"

# Collect trusts nothing from a runner: a sidecar naming another locale is
# rejected, while an empty patch with a truthful sidecar still advances
# the manifest (an English edit may need no change in a language).
git -C "$fix" init -q
git -C "$fix" config user.email test@example.com
git -C "$fix" config user.name Test
git -C "$fix" add -A && git -C "$fix" commit -qm fixture
mkdir -p "$work/artifacts"
: >"$work/artifacts/da.patch"
printf '{"fr": ["shell:a.two"]}\n' >"$work/artifacts/da.done.json"
if python3 "$ROOT/scripts/i18n-sync.py" --root "$fix" collect "$work/artifacts" --expected da >/dev/null 2>&1; then
  fail "collect rejects a sidecar naming another locale"
else
  pass "collect rejects a sidecar naming another locale"
fi
printf '{"da": ["shell:a.two"]}\n' >"$work/artifacts/da.done.json"
if python3 "$ROOT/scripts/i18n-sync.py" --root "$fix" collect "$work/artifacts" --expected da >/dev/null 2>&1; then
  pass "collect accepts an empty patch with a truthful sidecar"
else
  fail "collect accepts an empty patch with a truthful sidecar"
fi
printf '{"da": ["shell:a.missing"]}\n' >"$work/artifacts/da.done.json"
if python3 "$ROOT/scripts/i18n-sync.py" --root "$fix" collect "$work/artifacts" --expected da >/dev/null 2>&1; then
  fail "collect rejects completion for units not in the tree"
else
  pass "collect rejects completion for units not in the tree"
fi

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
