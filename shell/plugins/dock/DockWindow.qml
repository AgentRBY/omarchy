import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.Commons
import qs.Commons as Commons
import qs.Ui

// One screen's dock. It stays mapped and fades in and out, so switching to a
// floating workspace does not wait on a fresh layer surface. While hidden the
// mask is empty and clicks fall through to the windows below.
PanelWindow {
  id: window

  property var dock: null

  readonly property string position: dock ? dock.position : "bottom"
  readonly property bool vertical: dock ? dock.vertical : false
  readonly property var monitor: Hyprland.monitorFor(screen)
  readonly property var workspace: monitor ? monitor.activeWorkspace : null
  readonly property int workspaceId: workspace ? workspace.id : -1
  readonly property bool shown: !!dock && dock.isFloating(workspaceId) && !(workspace && workspace.hasFullscreen)

  readonly property int gap: Style.gapsOut
  readonly property int iconSize: Math.round(36 * Style.fontScale)
  readonly property int slotPadding: Style.spacing.md
  readonly property int slotSize: iconSize + slotPadding * 2
  readonly property int bodyPadding: Style.spacing.sm
  readonly property int thickness: slotSize + bodyPadding * 2
  // Room inward of the dock for the app name and the app menu.
  readonly property int popupRoom: Style.space(160)

  property Item hoveredSlot: null
  property var menuItem: null
  property Item menuSlot: null

  onWorkspaceIdChanged: if (dock) dock.readMode(workspaceId)
  onShownChanged: if (!shown) closeMenu()
  Component.onCompleted: if (dock) dock.readMode(workspaceId)

  function openMenu(item, slot) {
    window.menuItem = item
    window.menuSlot = slot
  }

  function closeMenu() {
    window.menuItem = null
    window.menuSlot = null
  }

  // Places a popup inward of the dock, centered on a slot.
  function popupX(slot, popup) {
    if (!slot) return 0
    var center = slot.mapToItem(window.contentItem, slot.width / 2, 0).x
    if (window.position === "left") return body.x + body.width + window.gap
    if (window.position === "right") return body.x - window.gap - popup.width
    return Math.max(window.gap, Math.min(window.width - popup.width - window.gap, center - popup.width / 2))
  }

  function popupY(slot, popup) {
    if (!slot) return 0
    var center = slot.mapToItem(window.contentItem, 0, slot.height / 2).y
    if (window.position === "top") return body.y + body.height + window.gap
    if (window.position === "bottom") return body.y - window.gap - popup.height
    return Math.max(window.gap, Math.min(window.height - popup.height - window.gap, center - popup.height / 2))
  }

  visible: !remapGuard.remapping
  color: "transparent"
  WlrLayershell.namespace: "omarchy-dock"
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  // Kept clear of the bar's reserved edge, without reserving one of its own:
  // floating windows go where they are put.
  exclusionMode: ExclusionMode.Normal
  exclusiveZone: 0

  anchors {
    top: window.position !== "bottom"
    bottom: window.position !== "top"
    left: window.position !== "right"
    right: window.position !== "left"
  }

  implicitWidth: window.vertical ? window.gap + window.thickness + window.popupRoom : 0
  implicitHeight: window.vertical ? 0 : window.gap + window.thickness + window.popupRoom

  mask: Region {
    item: window.shown ? body : null

    Region { item: menu.visible ? menu : null }
  }

  ScreenMoveRemap {
    id: remapGuard
    window: window
  }

  HyprlandFocusGrab {
    active: window.menuItem !== null
    windows: [window]
    onCleared: window.closeMenu()
  }

  Rectangle {
    id: body

    property real slide: window.shown ? 0 : window.thickness / 2

    width: slots.implicitWidth + window.bodyPadding * 2
    height: slots.implicitHeight + window.bodyPadding * 2
    x: window.position === "left" ? window.gap - slide
      : window.position === "right" ? window.width - width - window.gap + slide
      : (window.width - width) / 2
    y: window.position === "top" ? window.gap - slide
      : window.position === "bottom" ? window.height - height - window.gap + slide
      : (window.height - height) / 2
    radius: Style.cornerRadius
    color: Util.alpha(Commons.Color.bar.background, 0.4)
    opacity: window.shown ? 1 : 0

    Behavior on opacity { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
    Behavior on slide { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    Grid {
      id: slots
      anchors.centerIn: parent
      columns: window.vertical ? 1 : appRepeater.count + 1

      AppsSlot {}

      Repeater {
        id: appRepeater
        model: window.dock ? window.dock.items : []

        delegate: AppSlot {}
      }
    }
  }

  component Slot: Item {
    id: slot

    property bool hovered: mouse.containsMouse
    property bool pressed: mouse.pressed
    property alias mouse: mouse

    width: window.slotSize
    height: window.slotSize

    Rectangle {
      anchors.fill: parent
      anchors.margins: Style.spacing.xxs
      radius: Style.cornerRadius
      color: slot.pressed ? Style.pressedFill : (slot.hovered ? Style.hoverFill : "transparent")
    }

    MouseArea {
      id: mouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
      onContainsMouseChanged: {
        if (containsMouse) window.hoveredSlot = slot
        else if (window.hoveredSlot === slot) window.hoveredSlot = null
      }
    }
  }

  component AppsSlot: Slot {
    id: appsSlot

    readonly property string label: "Apps"

    mouse.onClicked: {
      window.closeMenu()
      if (window.dock) window.dock.openApps()
    }

    // A grid of dots reads as "all apps" in any icon theme.
    Grid {
      anchors.centerIn: parent
      columns: 3
      spacing: Math.round(window.iconSize / 9)
      scale: appsSlot.pressed ? 0.92 : (appsSlot.hovered ? 1.08 : 1)

      Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

      Repeater {
        model: 9

        delegate: Rectangle {
          width: Math.round(window.iconSize / 5)
          height: width
          radius: width / 2
          color: Commons.Color.bar.text
        }
      }
    }
  }

  component AppSlot: Slot {
    id: appSlot

    required property var modelData
    readonly property string label: window.dock ? window.dock.nameFor(modelData) : ""
    readonly property int windowCount: modelData.windows.length
    readonly property bool focused: {
      for (var i = 0; i < modelData.windows.length; i++) {
        if (modelData.windows[i].toplevel.activated) return true
      }
      return false
    }

    mouse.onClicked: function(event) {
      if (event.button === Qt.RightButton) {
        window.openMenu(appSlot.modelData, appSlot)
        return
      }
      window.closeMenu()
      if (event.button === Qt.MiddleButton) window.dock.launch(appSlot.modelData)
      else window.dock.activate(appSlot.modelData)
    }

    Image {
      anchors.centerIn: parent
      width: window.iconSize
      height: window.iconSize
      sourceSize: Qt.size(window.iconSize * 2, window.iconSize * 2)
      source: window.dock ? window.dock.iconFor(appSlot.modelData) : ""
      fillMode: Image.PreserveAspectFit
      asynchronous: true
      smooth: true
      mipmap: true
      scale: appSlot.pressed ? 0.92 : (appSlot.hovered ? 1.08 : 1)

      Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
    }

    // One dot per window, up to three, on the side facing the screen edge.
    Grid {
      readonly property int dot: Math.max(3, Math.round(window.iconSize / 9))

      visible: appSlot.windowCount > 0
      columns: window.vertical ? 1 : 3
      spacing: dot
      x: window.position === "left" ? Style.spacing.xxs
        : window.position === "right" ? parent.width - width - Style.spacing.xxs
        : (parent.width - width) / 2
      y: window.position === "top" ? Style.spacing.xxs
        : window.position === "bottom" ? parent.height - height - Style.spacing.xxs
        : (parent.height - height) / 2

      Repeater {
        model: Math.min(3, appSlot.windowCount)

        delegate: Rectangle {
          width: parent.dot
          height: parent.dot
          radius: width / 2
          color: appSlot.focused ? Commons.Color.accent : Util.alpha(Commons.Color.bar.text, 0.6)
        }
      }
    }
  }

  // The app's name, shown inward of the hovered icon.
  Rectangle {
    id: tooltip

    readonly property Item slot: window.hoveredSlot

    visible: window.shown && !!slot && !menu.visible
    width: tooltipText.implicitWidth + Style.spacing.controlPaddingX * 2
    height: tooltipText.implicitHeight + Style.spacing.controlPaddingY * 2
    x: window.popupX(slot, tooltip)
    y: window.popupY(slot, tooltip)
    radius: Style.cornerRadius
    color: Commons.Color.tooltip.background

    Text {
      id: tooltipText
      anchors.centerIn: parent
      textFormat: Text.PlainText
      text: tooltip.slot ? tooltip.slot.label : ""
      color: Commons.Color.tooltip.text
      font.family: Style.font.family
      font.pixelSize: Style.font.body
    }
  }

  BorderSurface {
    id: menu

    readonly property var item: window.menuItem
    readonly property bool hasEntry: !!item && !!window.dock && !!window.dock.entryFor(item)
    readonly property bool running: !!item && item.windows.length > 0

    visible: window.shown && !!item
    width: Math.max(Style.space(140), menuColumn.implicitWidth) + padding * 2
    height: menuColumn.implicitHeight + padding * 2
    x: window.popupX(window.menuSlot, menu)
    y: window.popupY(window.menuSlot, menu)
    radius: Style.cornerRadius
    color: Commons.Color.popups.background
    borderSpec: Border.surfaceSpec("popups", "border", Commons.Color.popups.border, Style.normalBorderWidth)
    padding: Style.spacing.sm

    Column {
      id: menuColumn
      x: menu.contentLeftInset
      y: menu.contentTopInset
      width: menu.width - menu.contentLeftInset - menu.contentRightInset

      MenuRow {
        visible: menu.hasEntry && menu.running
        text: "New Window"
        onTriggered: window.dock.launch(menu.item)
      }

      MenuRow {
        visible: menu.hasEntry
        text: menu.item && menu.item.pinned ? "Remove from Dock" : "Keep in Dock"
        onTriggered: window.dock.setPinned(menu.item, !menu.item.pinned)
      }

      MenuRow {
        visible: menu.running
        text: "Quit"
        onTriggered: window.dock.quit(menu.item)
      }
    }
  }

  component MenuRow: Rectangle {
    id: row

    property string text: ""
    signal triggered()

    width: parent ? parent.width : 0
    height: visible ? Style.spacing.popupRowHeight : 0
    radius: Style.cornerRadius
    color: rowMouse.containsMouse ? Style.hoverFill : "transparent"

    Text {
      anchors.verticalCenter: parent.verticalCenter
      x: Style.spacing.controlPaddingX
      textFormat: Text.PlainText
      text: row.text
      color: Commons.Color.popups.text
      font.family: Style.font.family
      font.pixelSize: Style.font.body
    }

    MouseArea {
      id: rowMouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        row.triggered()
        window.closeMenu()
      }
    }
  }
}
