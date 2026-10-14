# Omarchy App Templates

Read this when starting an app from the omarchy-app skill. Replace `<name>`
with the app's name and `<Name>` with its display name. These come from
Omacut and Monologue (MIT, David Heinemeier Hansson); keep that attribution in
the LICENSE of any app that copies them.

## `<name>.pro`

Add `multimedia`, `concurrent`, or other modules only when the app uses them.

```qmake
QT += core gui qml quick quickcontrols2 dbus

CONFIG += c++17 release
TARGET = <name>
TEMPLATE = app

HEADERS += \
    src/backend.h \
    src/theme.h \
    src/translator.h

SOURCES += \
    src/main.cpp \
    src/backend.cpp \
    src/theme.cpp \
    src/translator.cpp

RESOURCES += src/resources.qrc
```

## `bin/build`

```sh
#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
mkdir -p "$ROOT/build"
cd "$ROOT/build"

qmake6 "$ROOT/<name>.pro"
make -j"$(nproc)"

echo "Built $ROOT/build/<name>"
```

## `bin/test`

```sh
#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
mkdir -p "$ROOT/build/tests"
cd "$ROOT/build/tests"

qmake6 "$ROOT/tests/<name>_tests.pro"
make -j"$(nproc)"
QT_QPA_PLATFORM=offscreen ./<name>_tests
```

## `bin/install`

```sh
#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
"$ROOT/bin/build"
cd "$ROOT/pkgbuild"
exec makepkg -fsi "$@"
```

## `src/main.cpp`

```cpp
// <name> — one line on what it does.

#include <QGuiApplication>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QUrl>

#include "backend.h"
#include "theme.h"
#include "translator.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);
    app.setApplicationName("<name>");
    app.setApplicationVersion("0.1.0");

    // Matches the window to <name>.desktop, so the compositor (Wayland app_id)
    // and the launcher pick up the installed icon.
    app.setDesktopFileName("<name>");
    app.setWindowIcon(QIcon::fromTheme("<name>"));

    QQuickStyle::setStyle("Material");

    // Installed before anything is translated, and every qsTr() binding is
    // re-evaluated when the Omarchy language changes.
    Translator translator;
    app.installTranslator(&translator);

    Theme theme;
    Backend backend;

    QQmlApplicationEngine engine;
    QObject::connect(&translator, &Translator::changed, &engine, &QQmlEngine::retranslate);
    engine.rootContext()->setContextProperty("translator", &translator);
    engine.rootContext()->setContextProperty("theme", &theme);
    engine.rootContext()->setContextProperty("backend", &backend);
    engine.load(QUrl("qrc:/Main.qml"));
    if (engine.rootObjects().isEmpty())
        return 1;

    return app.exec();
}
```

## `src/theme.h` and `src/theme.cpp`

Follows the Omarchy accent live, and hands QML a readable color to put on it.
Tests construct it with a temp directory.

```cpp
#pragma once

#include <QFileSystemWatcher>
#include <QObject>
#include <QTimer>

class Theme : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString accent READ accent NOTIFY changed)
    Q_PROPERTY(QString accentForeground READ accentForeground NOTIFY changed)

public:
    explicit Theme(const QString &currentDirectory = {}, QObject *parent = nullptr);

    QString accent() const { return m_accent; }
    QString accentForeground() const;

    static QString readAccent(const QString &path);

signals:
    void changed();

private:
    void reload();

    QString m_directory;
    QString m_accent = "#FFD60A";
    QFileSystemWatcher m_watcher;
    QTimer m_debounce;
};
```

```cpp
// Theme watching follows Omacut (MIT, David Heinemeier Hansson).
#include "theme.h"

#include <QColor>
#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QRegularExpression>
#include <cmath>

Theme::Theme(const QString &directory, QObject *parent)
    : QObject(parent),
      m_directory(directory.isEmpty() ? QDir::homePath() + "/.local/state/omarchy/current" : directory) {
    m_debounce.setSingleShot(true);
    m_debounce.setInterval(80);
    connect(&m_watcher, &QFileSystemWatcher::directoryChanged, this, [this] { m_debounce.start(); });
    connect(&m_watcher, &QFileSystemWatcher::fileChanged, this, [this] { m_debounce.start(); });
    connect(&m_debounce, &QTimer::timeout, this, &Theme::reload);
    reload();
}

QString Theme::readAccent(const QString &path) {
    QFile file(path);
    if (file.open(QIODevice::ReadOnly)) {
        const QRegularExpression expression(R"re(^\s*accent\s*=\s*["'](#[0-9a-fA-F]{6})["'])re",
                                            QRegularExpression::MultilineOption);
        const auto match = expression.match(QString::fromUtf8(file.readAll()));
        if (match.hasMatch())
            return match.captured(1);
    }
    return "#FFD60A";
}

// Black or white, whichever reads on the accent (WCAG relative luminance).
QString Theme::accentForeground() const {
    const QColor c(m_accent);
    auto linear = [](double v) { return v <= .04045 ? v / 12.92 : std::pow((v + .055) / 1.055, 2.4); };
    const double luminance = .2126 * linear(c.redF()) + .7152 * linear(c.greenF()) + .0722 * linear(c.blueF());
    return luminance > .179 ? "black" : "white";
}

void Theme::reload() {
    const auto paths = m_watcher.files() + m_watcher.directories();
    if (!paths.isEmpty())
        m_watcher.removePaths(paths);

    // A theme switch replaces symlinks and files, so watch the parents too and
    // re-arm after every change. Watching the nearest existing ancestor means
    // installing Omarchy later works without restarting the app.
    QString ancestor = m_directory;
    while (!QFileInfo::exists(ancestor) && ancestor != "/")
        ancestor = QFileInfo(ancestor).absolutePath();
    QStringList candidates{ancestor, QFileInfo(ancestor).absolutePath(), m_directory,
                           m_directory + "/theme", m_directory + "/theme/colors.toml"};
    candidates.removeDuplicates();
    for (const auto &path : candidates)
        if (QFileInfo::exists(path))
            m_watcher.addPath(path);

    const auto accent = readAccent(m_directory + "/theme/colors.toml");
    if (accent != m_accent) {
        m_accent = accent;
        emit changed();
    }
}
```

## `src/translator.h` and `src/translator.cpp`

Follows the language picked under Omarchy's Setup > Language, live. QML
writes `qsTr("Save")` and C++ writes `tr("Save")`; the English text is the
key, so an untranslated string simply shows in English. Tests construct it
with a temp language file and catalog directory.

```cpp
#pragma once

#include <QFileSystemWatcher>
#include <QHash>
#include <QTimer>
#include <QTranslator>

// Follows the language picked under Omarchy's Setup > Language. Catalogs are
// flat JSON objects from English source text to translation, one per Omarchy
// language code (i18n/da.json, i18n/pt-BR.json), so QML keeps plain
// qsTr("Save") and C++ keeps tr("Save").
class Translator : public QTranslator {
    Q_OBJECT
    Q_PROPERTY(QString language READ language NOTIFY changed)

public:
    explicit Translator(const QString &languageFile = {}, const QString &catalogDirectory = ":/i18n",
                        QObject *parent = nullptr);

    QString language() const { return m_language; }
    bool isEmpty() const override { return m_strings.isEmpty(); }
    QString translate(const char *context, const char *sourceText, const char *disambiguation = nullptr,
                      int n = -1) const override;

    static QString readLanguage(const QString &path);

signals:
    void changed();

private:
    void reload();

    QString m_languageFile;
    QString m_catalogDirectory;
    QString m_language = "en";
    QHash<QString, QString> m_strings;
    QFileSystemWatcher m_watcher;
    QTimer m_debounce;
};
```

```cpp
#include "translator.h"

#include <QDir>
#include <QFile>
#include <QFileInfo>
#include <QJsonDocument>
#include <QJsonObject>
#include <QLocale>
#include <QRegularExpression>

Translator::Translator(const QString &languageFile, const QString &catalogDirectory, QObject *parent)
    : QTranslator(parent),
      m_languageFile(languageFile.isEmpty() ? QDir::homePath() + "/.config/omarchy/language" : languageFile),
      m_catalogDirectory(catalogDirectory) {
    m_debounce.setSingleShot(true);
    m_debounce.setInterval(80);
    connect(&m_watcher, &QFileSystemWatcher::directoryChanged, this, [this] { m_debounce.start(); });
    connect(&m_watcher, &QFileSystemWatcher::fileChanged, this, [this] { m_debounce.start(); });
    connect(&m_debounce, &QTimer::timeout, this, &Translator::reload);
    reload();
}

// One registry code on the first line; anything else, or no file, is English.
QString Translator::readLanguage(const QString &path) {
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly))
        return "en";
    const QString code = QString::fromUtf8(file.readLine()).trimmed();
    static const QRegularExpression valid("^[a-z]{2,3}(-[A-Za-z]{2})?$");
    return valid.match(code).hasMatch() ? code : "en";
}

QString Translator::translate(const char *, const char *sourceText, const char *, int) const {
    // A null string tells Qt there is no translation, so it shows the English.
    return m_strings.value(QString::fromUtf8(sourceText));
}

void Translator::reload() {
    const auto paths = m_watcher.files() + m_watcher.directories();
    if (!paths.isEmpty())
        m_watcher.removePaths(paths);

    // omarchy-language replaces the file, which drops it from the watch, and a
    // first pick creates it; watch its directory too and re-arm every time.
    const QString directory = QFileInfo(m_languageFile).absolutePath();
    if (QFileInfo::exists(directory))
        m_watcher.addPath(directory);
    if (QFileInfo::exists(m_languageFile))
        m_watcher.addPath(m_languageFile);

    // Catalogs are compiled in, so only a different language needs a reload.
    const QString language = readLanguage(m_languageFile);
    if (language == m_language)
        return;

    // The base language first, then the regional file over it (pt, then
    // pt-BR), so a missing string falls back toward English one step at a time.
    QHash<QString, QString> strings;
    QStringList codes{language.section('-', 0, 0)};
    if (codes.first() != language)
        codes << language;
    for (const auto &code : codes) {
        if (code == "en")
            continue;
        QFile catalog(m_catalogDirectory + "/" + code + ".json");
        if (!catalog.open(QIODevice::ReadOnly))
            continue;
        const QJsonObject object = QJsonDocument::fromJson(catalog.readAll()).object();
        for (auto it = object.begin(); it != object.end(); ++it)
            if (it.value().isString() && !it.value().toString().isEmpty())
                strings.insert(it.key(), it.value().toString());
    }

    m_language = language;
    m_strings = strings;
    // Dates, numbers, and Qt's own day and month names follow the language too.
    QLocale::setDefault(QLocale(language));
    emit changed();
}
```

## `src/backend.h` and `src/backend.cpp`

The C++ side of the app's one job, exposed to QML as `backend`. Start with
the single action the Space shortcut runs, then grow it.

```cpp
#pragma once

#include <QObject>

class Backend : public QObject {
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    explicit Backend(QObject *parent = nullptr) : QObject(parent) {}

    int count() const { return m_count; }
    Q_INVOKABLE void primaryAction();

signals:
    void countChanged();

private:
    int m_count = 0;
};
```

```cpp
#include "backend.h"

void Backend::primaryAction()
{
    ++m_count;
    emit countChanged();
}
```

## `src/Main.qml`

```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

ApplicationWindow {
    id: win
    width: 960
    height: 680
    minimumWidth: 640
    minimumHeight: 460
    visible: true
    title: "<Name>"
    color: "#0e0e10"

    Material.theme: Material.Dark
    Material.accent: theme.accent

    property bool helpVisible: false

    Shortcut { sequence: "?"; context: Qt.ApplicationShortcut; onActivated: win.helpVisible = !win.helpVisible }
    Shortcut { sequence: "Q"; context: Qt.ApplicationShortcut; onActivated: Qt.quit() }
    Shortcut { sequence: "Space"; context: Qt.ApplicationShortcut; onActivated: backend.primaryAction() }

    // The app's one job goes here.
}
```

## `src/resources.qrc`

```xml
<RCC>
    <qresource prefix="/">
        <file alias="Main.qml">Main.qml</file>
        <file alias="i18n/da.json">i18n/da.json</file>
    </qresource>
</RCC>
```

List one `<file>` line per catalog in `src/i18n/`. English needs no file.

## `src/i18n/<code>.json`

One flat JSON object per language, keyed by the English exactly as it appears
in `qsTr()`, with Omarchy's language codes as file names
(`$OMARCHY_PATH/default/i18n/locales.json` lists all 50: `da`, `de`, `pt-BR`,
`zh-CN`, ...). Keep `%1` placeholders, which `.arg()` fills, so a translation
can reorder them.

```json
{
  "Save": "Gem",
  "%1 clips": "%1 klip"
}
```

## `tests/<name>_tests.pro`

```qmake
QT += core gui quick quickcontrols2 testlib dbus
CONFIG += c++17 testcase
TARGET = <name>_tests
TEMPLATE = app

INCLUDEPATH += ../src

HEADERS += ../src/backend.h ../src/theme.h ../src/translator.h
SOURCES += <name>_tests.cpp ../src/backend.cpp ../src/theme.cpp ../src/translator.cpp
```

## `tests/<name>_tests.cpp`

One `private slots:` case per behavior. These cover the backend, the theme
fallback and accent read, and the translator's language file and fallbacks,
so a broken theme or catalog shows up in `bin/test`.

```cpp
#include <QDir>
#include <QFile>
#include <QTemporaryDir>
#include <QtTest>

#include "backend.h"
#include "theme.h"
#include "translator.h"

class <Name>Tests : public QObject {
    Q_OBJECT

private slots:
    void primaryActionCounts()
    {
        Backend backend;
        backend.primaryAction();
        QCOMPARE(backend.count(), 1);
    }

    void themeFallsBack()
    {
        QTemporaryDir dir;
        Theme theme(dir.path());
        QCOMPARE(theme.accent(), QString("#FFD60A"));
        QCOMPARE(theme.accentForeground(), QString("black"));
    }

    void themeReadsAccent()
    {
        QTemporaryDir dir;
        QDir(dir.path()).mkpath("theme");
        QFile colors(dir.path() + "/theme/colors.toml");
        QVERIFY(colors.open(QIODevice::WriteOnly));
        colors.write("accent = \"#112233\"\n");
        colors.close();

        Theme theme(dir.path());
        QCOMPARE(theme.accent(), QString("#112233"));
        QCOMPARE(theme.accentForeground(), QString("white"));
    }

    void translatorFallsBackToEnglish()
    {
        QTemporaryDir dir;
        Translator translator(dir.path() + "/language", dir.path());
        QCOMPARE(translator.language(), QString("en"));
        QVERIFY(translator.translate("Main", "Save").isNull());
    }

    void translatorFollowsTheLanguageFile()
    {
        QTemporaryDir dir;
        write(dir.path() + "/language", "pt-BR\n");
        write(dir.path() + "/pt.json", R"({"Save": "Guardar", "Open": "Abrir"})");
        write(dir.path() + "/pt-BR.json", R"({"Save": "Salvar"})");

        Translator translator(dir.path() + "/language", dir.path());
        QCOMPARE(translator.language(), QString("pt-BR"));
        QCOMPARE(translator.translate("Main", "Save"), QString("Salvar"));
        QCOMPARE(translator.translate("Main", "Open"), QString("Abrir"));
        QVERIFY(translator.translate("Main", "Quit").isNull());
    }

private:
    static void write(const QString &path, const QByteArray &contents)
    {
        QFile file(path);
        QVERIFY(file.open(QIODevice::WriteOnly));
        file.write(contents);
    }
};

QTEST_MAIN(<Name>Tests)
#include "<name>_tests.moc"
```

## `pkgbuild/PKGBUILD`

```sh
pkgname=<name>
pkgver=0.1.0
pkgrel=1
pkgdesc='One line on what it does'
arch=('x86_64' 'aarch64')
license=('MIT')
depends=('qt6-base' 'qt6-declarative' 'qt6-wayland' 'xdg-desktop-portal')
makedepends=('gcc' 'make')
source=()
sha256sums=()

build() {
  cd "$startdir/.."
  ./bin/build
}

package() {
  cd "$startdir/.."
  install -Dm755 build/<name> "$pkgdir/usr/bin/<name>"
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
  install -Dm644 "$startdir/<name>.svg" "$pkgdir/usr/share/icons/hicolor/scalable/apps/<name>.svg"
  install -Dm644 "$startdir/<name>.desktop" "$pkgdir/usr/share/applications/<name>.desktop"
}
```

Add `ffmpeg`, `qt6-multimedia`, or `qt6-svg` to `depends` when the app uses
them. Omarchy installs all three, but the package should still say what it
needs. `package()` also installs `LICENSE` from the project root (the MIT text
with the user's name and year) and the icon below, so both must exist.

## `pkgbuild/<name>.desktop`

```ini
[Desktop Entry]
Type=Application
Name=<Name>
Comment=One line on what it does
Exec=<name> %f
Icon=<name>
Terminal=false
Categories=Utility;
StartupWMClass=<name>
```

Add `Name[<code>]=` and `Comment[<code>]=` lines for each language the app
ships, so the launcher shows the translated name (`Name[da]=…`,
`Comment[pt_BR]=…`; desktop files spell regions with an underscore).

## `pkgbuild/<name>.svg`

The icon is a single square SVG. Start from a rounded square in the accent
and draw the app's mark on it.

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64" width="64" height="64">
  <rect width="64" height="64" rx="14" fill="#FFD60A"/>
</svg>
```

## `.gitignore`

```text
/build/
/pkgbuild/pkg/
/pkgbuild/src/
*.pkg.tar.*
```
