import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons
import qs.Commons as Commons
import qs.Ui

// Every app on one grid. Type to narrow it, arrows to move, Enter to launch.
Item {
  id: root

  property var appLibrary: null

  property bool opened: false
  property string filterText: ""
  property int selectedIndex: 0
  property var apps: []

  readonly property int iconSize: Math.round(56 * Style.fontScale)
  readonly property int cellWidth: Math.round(iconSize * 2)
  readonly property int cellHeight: iconSize + Style.font.body * 3 + Style.spacing.lg * 2
  readonly property int contentMargin: Style.spacing.panelPadding
  readonly property int headerHeight: Math.max(Style.space(34), Style.font.title + Style.spacing.controlPaddingY * 2)
  readonly property int columns: Math.max(1, Math.min(7, Math.floor((panel.width * 0.8 - contentMargin * 2) / cellWidth)))
  readonly property int cardWidth: columns * cellWidth + contentMargin * 2
  readonly property int cardHeight: Math.min(panel.height * 0.8, headerHeight + Style.spacing.md + cellHeight * 5 + contentMargin * 2)

  function open() {
    root.filterText = ""
    root.selectedIndex = 0
    if (root.appLibrary) root.appLibrary.refreshIcons()
    root.rebuild()
    root.opened = true
    Qt.callLater(function() { keyCatcher.forceActiveFocus() })
  }

  function close() {
    root.opened = false
  }

  function toggle() {
    if (root.opened) root.close()
    else root.open()
  }

  function rebuild() {
    var rows = root.appLibrary ? root.appLibrary.sortedEntries(root.filterText) : []
    root.apps = rows.map(function(row) { return row.entry })
    root.selectedIndex = Math.max(0, Math.min(root.selectedIndex, root.apps.length - 1))
    grid.positionViewAtBeginning()
  }

  function setFilter(text) {
    root.filterText = text
    root.selectedIndex = 0
    root.rebuild()
  }

  function select(delta) {
    if (root.apps.length === 0) return
    root.selectedIndex = Math.max(0, Math.min(root.apps.length - 1, root.selectedIndex + delta))
    grid.positionViewAtIndex(root.selectedIndex, GridView.Contain)
  }

  function launch(index) {
    var entry = root.apps[index]
    if (!entry || !root.appLibrary) return
    root.close()
    root.appLibrary.launch(entry.id, root.appLibrary.entryName(entry))
  }

  Connections {
    target: root.appLibrary
    function onAppsChanged() { if (root.opened) root.rebuild() }
  }

  OverlayWindow {
    id: panel
    shown: root.opened
    WlrLayershell.namespace: "omarchy-dock-apps"

    Rectangle {
      anchors.fill: parent
      color: Commons.Color.menu.scrim
    }

    MouseArea {
      anchors.fill: parent
      onClicked: root.close()
    }

    BorderSurface {
      id: card
      width: root.cardWidth
      height: root.cardHeight
      anchors.centerIn: parent
      radius: Style.cornerRadius
      color: Commons.Color.menu.background
      borderSpec: Border.surfaceSpec("menu", "border", Commons.Color.menu.border, Math.max(1, Style.space(2)))
      padding: root.contentMargin

      MouseArea { anchors.fill: parent; onClicked: {} }

      Item {
        id: keyCatcher
        anchors.fill: parent
        focus: true

        Keys.priority: Keys.BeforeItem
        Keys.onPressed: function(event) {
          if (event.key === Qt.Key_Escape) {
            if (root.filterText) root.setFilter("")
            else root.close()
          } else if (Util.editsFilter(event, root.filterText)) {
            root.setFilter(Util.editedFilter(event, root.filterText))
          } else if (event.key === Qt.Key_Left) {
            root.select(-1)
          } else if (event.key === Qt.Key_Right) {
            root.select(1)
          } else if (event.key === Qt.Key_Up) {
            root.select(-root.columns)
          } else if (event.key === Qt.Key_Down) {
            root.select(root.columns)
          } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.launch(root.selectedIndex)
          } else if (event.text && event.text.length === 1 && event.text.charCodeAt(0) >= 32 && event.text.charCodeAt(0) !== 127) {
            root.setFilter(root.filterText + event.text)
          } else {
            return
          }
          event.accepted = true
        }
      }

      Column {
        anchors.fill: parent
        anchors.topMargin: card.contentTopInset
        anchors.rightMargin: card.contentRightInset
        anchors.bottomMargin: card.contentBottomInset
        anchors.leftMargin: card.contentLeftInset
        spacing: Style.spacing.md

        Item {
          width: parent.width
          height: root.headerHeight

          Text {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Style.spacing.controlPaddingX
            anchors.verticalCenter: parent.verticalCenter
            textFormat: Text.PlainText
            text: root.filterText || "Search apps…"
            color: Commons.Color.menu.text
            opacity: root.filterText ? 1 : 0.58
            font.family: Style.font.menuFamily
            font.pixelSize: Style.font.heading
            elide: Text.ElideRight
          }
        }

        Item {
          width: parent.width
          height: parent.height - root.headerHeight - parent.spacing

          GridView {
            id: grid
            anchors.fill: parent
            model: root.apps
            clip: true
            cellWidth: root.cellWidth
            cellHeight: root.cellHeight
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
              id: cell

              required property int index
              required property var modelData
              readonly property bool selected: index === root.selectedIndex

              width: root.cellWidth
              height: root.cellHeight
              radius: Style.cornerRadius
              color: selected ? Commons.Color.menu.selectedBackground : "transparent"

              Image {
                id: icon
                anchors.horizontalCenter: parent.horizontalCenter
                y: Style.spacing.lg
                width: root.iconSize
                height: root.iconSize
                sourceSize: Qt.size(root.iconSize * 2, root.iconSize * 2)
                source: root.appLibrary ? root.appLibrary.iconSource(cell.modelData.icon) : ""
                fillMode: Image.PreserveAspectFit
                asynchronous: true
                smooth: true
                mipmap: true
              }

              Text {
                anchors.top: icon.bottom
                anchors.topMargin: Style.spacing.md
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - Style.spacing.md * 2
                textFormat: Text.PlainText
                text: root.appLibrary ? root.appLibrary.entryName(cell.modelData) : ""
                color: cell.selected ? Commons.Color.menu.selectedText : Commons.Color.menu.text
                font.family: Style.font.menuFamily
                font.pixelSize: Style.font.body
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
              }

              MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onContainsMouseChanged: if (containsMouse) root.selectedIndex = cell.index
                onClicked: root.launch(cell.index)
              }
            }
          }

          Text {
            anchors.centerIn: parent
            visible: root.apps.length === 0
            textFormat: Text.PlainText
            text: "No apps match “" + root.filterText + "”"
            color: Commons.Color.menu.text
            opacity: 0.7
            font.family: Style.font.menuFamily
            font.pixelSize: Style.font.title
          }
        }
      }
    }
  }
}
