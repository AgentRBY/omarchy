import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import qs.Commons
import "DockModel.js" as DockModel

// An app dock that shows on floating workspaces. A floating workspace has no
// tiles to hand the apps out, so the dock gives back a place to find them:
// pinned apps, running apps, and a grid of every app.
Item {
  id: root

  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  property var shell: null
  property var manifest: null

  readonly property var appLibrary: shell ? shell.appLibrary : null
  readonly property var dockConfig: shell && shell.shellConfig && shell.shellConfig.dock ? shell.shellConfig.dock : ({})
  readonly property var defaultDockConfig: shell && shell.defaultsConfig && shell.defaultsConfig.dock ? shell.defaultsConfig.dock : ({})
  readonly property string position: DockModel.normalizePosition(dockConfig.position)
  readonly property bool vertical: DockModel.isVertical(position)

  // A pinned app that is not installed has nothing to launch, so it is left
  // out until it is. Windows are matched to the desktop entry that claims them.
  readonly property var items: {
    var appsRevision = DesktopEntries.applications.values.length
    var pinned = DockModel.pinnedIds(dockConfig, defaultDockConfig).filter(function(id) {
      return !!DesktopEntries.byId(id)
    })

    var windows = []
    var toplevels = ToplevelManager.toplevels.values
    for (var i = 0; i < toplevels.length; i++) {
      var toplevel = toplevels[i]
      if (!toplevel.appId || toplevel.parent) continue
      windows.push({ key: root.keyFor(toplevel.appId), toplevel: toplevel })
    }

    return DockModel.buildItems(pinned, windows)
  }

  function keyFor(appId) {
    var entry = DesktopEntries.heuristicLookup(appId)
    return entry ? entry.id : appId
  }

  function entryFor(item) {
    return item ? DesktopEntries.byId(item.key) : null
  }

  function nameFor(item) {
    var entry = entryFor(item)
    if (entry && entry.name) return entry.name
    return item ? item.key : ""
  }

  function iconFor(item) {
    var entry = entryFor(item)
    var icon = entry && entry.icon ? entry.icon : (item ? item.key : "")
    return root.appLibrary ? root.appLibrary.iconSource(icon) : Quickshell.iconPath(icon, true)
  }

  function launch(item) {
    var entry = entryFor(item)
    if (entry && root.appLibrary) root.appLibrary.launch(entry.id, entry.name)
  }

  function activate(item) {
    if (!item) return
    if (item.windows.length === 0) {
      root.launch(item)
      return
    }
    var index = DockModel.nextWindowIndex(item.windows.map(function(window) { return window.toplevel.activated }))
    item.windows[index].toplevel.activate()
  }

  function quit(item) {
    if (!item) return
    var windows = item.windows.slice()
    for (var i = 0; i < windows.length; i++) windows[i].toplevel.close()
  }

  function openApps() {
    appGrid.open()
  }

  function setPinned(item, pinned) {
    if (!item) return
    Util.execDetached("omarchy-dock " + (pinned ? "pin " : "unpin ") + Util.shellQuote(item.key))
  }

  // Each workspace's layout is read once and cached. It only changes through
  // the layout commands, which ask the dock to refresh, or a config reload.
  property var modes: ({})
  property var pendingModes: []
  property int modeGeneration: 0
  property int modeProcWorkspace: -1
  property int modeProcGeneration: 0

  function isFloating(workspaceId) {
    return root.modes[workspaceId] === "floating"
  }

  function readMode(workspaceId) {
    if (!(workspaceId >= 1) || root.modes[workspaceId] !== undefined) return
    if (root.pendingModes.indexOf(workspaceId) === -1) root.pendingModes.push(workspaceId)
    root.readNextMode()
  }

  function readNextMode() {
    if (modeProc.running || root.pendingModes.length === 0) return
    root.modeProcWorkspace = root.pendingModes.shift()
    root.modeProcGeneration = root.modeGeneration
    modeProc.command = ["omarchy-hyprland-workspace-layout-current", String(root.modeProcWorkspace)]
    modeProc.running = true
  }

  function refresh() {
    root.modes = ({})
    root.pendingModes = []
    root.modeGeneration++
    var monitors = Hyprland.monitors.values
    for (var i = 0; i < monitors.length; i++) {
      if (monitors[i].activeWorkspace) root.readMode(monitors[i].activeWorkspace.id)
    }
  }

  Component.onCompleted: refresh()

  Process {
    id: modeProc
    stdout: StdioCollector {
      onStreamFinished: {
        var mode = text.trim()
        // A read that started before a refresh may predate the change.
        if (!mode || root.modeProcGeneration !== root.modeGeneration) return
        var next = Object.assign({}, root.modes)
        next[root.modeProcWorkspace] = mode
        root.modes = next
      }
    }
    // Deferred: the process still reports running while it signals exit.
    onExited: Qt.callLater(root.readNextMode)
  }

  Connections {
    target: Hyprland
    function onRawEvent(event) {
      var name = event ? String(event.name) : ""
      if (name === "configreloaded") root.refresh()
      // Hyprland's workspace list does not follow fullscreen on its own.
      else if (name === "fullscreen") Hyprland.refreshWorkspaces()
    }
  }

  ShellIpc {
    target: "omarchy.dock"

    // The layout commands call this after changing a workspace's mode.
    function refresh(): void { root.refresh() }
    function apps(): void { appGrid.toggle() }
  }

  Variants {
    model: Quickshell.screens

    delegate: Component {
      DockWindow {
        required property var modelData

        screen: modelData
        dock: root
      }
    }
  }

  AppGrid {
    id: appGrid
    appLibrary: root.appLibrary
  }
}
