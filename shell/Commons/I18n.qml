pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Display-language strings for the shell. The selected code lives in
// ~/.config/omarchy/language (omarchy-language owns it); a missing file
// means English. Strings come from default/i18n/<code>/shell.json layered
// over the English catalog, so a missing translation falls back to English
// per string. Use as I18n.t("common.search"), with .arg(...) for %1 holes.
// The language file is watched, so switching language under Setup
// re-renders the shell without a restart.
QtObject {
  id: root

  readonly property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  readonly property string configHome: Quickshell.env("XDG_CONFIG_HOME") || (Quickshell.env("HOME") + "/.config")

  property string language: "en"
  property string formatLocale: "en-US"
  property string direction: "ltr"

  // Merged English + current-language strings. Reassigned whole on every
  // catalog load (never mutated in place) so bindings that called t()
  // re-evaluate when the language changes.
  property var strings: ({})
  property var englishStrings: ({})
  property var languageStrings: ({})

  function t(key) {
    var value = root.strings[key]
    return (typeof value === "string" && value.length > 0) ? value : key
  }

  function parseCatalog(raw) {
    try {
      var parsed = JSON.parse(raw || "{}")
      return (parsed && typeof parsed === "object" && !Array.isArray(parsed)) ? parsed : ({})
    } catch (e) {
      return ({})
    }
  }

  function rebuildStrings() {
    var merged = ({})
    for (var k in root.englishStrings) merged[k] = root.englishStrings[k]
    for (var k2 in root.languageStrings) merged[k2] = root.languageStrings[k2]
    root.strings = merged
  }

  function applyRegistry(raw) {
    var entry = parseCatalog(raw)[root.language] || ({})
    root.formatLocale = entry.formatLocale || "en-US"
    root.direction = entry.direction || "ltr"
  }

  function setLanguage(raw) {
    var code = String(raw || "").trim()
    if (!/^[a-z]{2,3}(-[A-Za-z]{2})?$/.test(code)) code = "en"
    if (root.language === code) return
    root.language = code
    languageCatalogFile.reload()
    registryFile.reload()
  }

  property FileView languageFile: FileView {
    path: root.configHome + "/omarchy/language"
    watchChanges: true
    printErrors: false
    onLoaded: root.setLanguage(text())
    onLoadFailed: root.setLanguage("")
    onFileChanged: reload()
  }

  property FileView englishCatalogFile: FileView {
    path: root.omarchyPath + "/default/i18n/en/shell.json"
    watchChanges: true
    printErrors: false
    onLoaded: { root.englishStrings = root.parseCatalog(text()); root.rebuildStrings() }
    onFileChanged: reload()
  }

  property FileView languageCatalogFile: FileView {
    id: languageCatalogFile
    path: root.omarchyPath + "/default/i18n/" + root.language + "/shell.json"
    watchChanges: true
    printErrors: false
    onLoaded: { root.languageStrings = root.parseCatalog(text()); root.rebuildStrings() }
    onLoadFailed: { root.languageStrings = ({}); root.rebuildStrings() }
    onFileChanged: reload()
  }

  property FileView registryFile: FileView {
    id: registryFile
    path: root.omarchyPath + "/default/i18n/locales.json"
    watchChanges: true
    printErrors: false
    onLoaded: root.applyRegistry(text())
    onFileChanged: reload()
  }
}
