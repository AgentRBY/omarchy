pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

// Input devices arriving and leaving, which Hyprland raises no event for. Every
// device the kernel sees, from a USB keyboard to a Bluetooth one pairing, adds
// and removes its nodes under /dev/input, so one watch there serves the whole
// shell instead of each bar asking Hyprland on a timer.
Singleton {
  id: root

  signal changed()

  // Tests point this at a fixture root, the way OMARCHY_PROC_ROOT and
  // OMARCHY_SYS_ROOT stand in for /proc and /sys.
  readonly property string inputDir: (Quickshell.env("OMARCHY_DEV_ROOT") || "") + "/dev/input"

  // inotifywait is restarted when it ends, unless it keeps ending at once, as
  // it would on a system with no /dev/input to watch.
  property real startedAt: 0
  property int quickExits: 0

  Process {
    id: watcher
    command: ["inotifywait", "-m", "-q", "-e", "create,delete", "--format", "%f", root.inputDir]
    running: true
    onRunningChanged: if (running) root.startedAt = Date.now()
    stdout: SplitParser {
      onRead: settle.restart()
    }
    onExited: {
      root.quickExits = Date.now() - root.startedAt < 1000 ? root.quickExits + 1 : 0
      if (root.quickExits < 5) restart.start()
    }
  }

  // A device brings several nodes at once, and libinput hands it to Hyprland a
  // moment after they appear, so announce it once the burst has settled.
  Timer {
    id: settle
    interval: 500
    onTriggered: root.changed()
  }

  Timer {
    id: restart
    interval: 1000
    onTriggered: watcher.running = true
  }
}
