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
  readonly property string devDir: (Quickshell.env("OMARCHY_DEV_ROOT") || "") + "/dev"
  readonly property string inputDir: devDir + "/input"

  // inotifywait is restarted when it ends, unless it keeps ending at once, as
  // it would if it could not watch at all.
  property real startedAt: 0
  property int quickExits: 0

  // /dev is watched beside /dev/input, for one thing: /dev/input being created
  // again after it went away with the last device, when the watch on the old
  // directory is gone and has to be set up on the new one.
  Process {
    id: watcher
    command: ["bash", "-c",
      "dirs=(\"$2\"); [[ -d $1 ]] && dirs+=(\"$1\"); "
        + "exec inotifywait -m -q -e create,delete,delete_self --format '%w|%e|%f' \"${dirs[@]}\"",
      "input-devices", root.inputDir, root.devDir]
    running: true
    onRunningChanged: if (running) root.startedAt = Date.now()
    stdout: SplitParser {
      onRead: function(line) {
        var fields = String(line).split("|")
        if (fields[0].replace(/\/$/, "") === root.devDir) {
          if (fields[2] === "input" && fields[1].indexOf("CREATE") !== -1) {
            watcher.running = false
            root.announce()
          }
          return
        }
        root.announce()
      }
    }
    onExited: {
      root.quickExits = Date.now() - root.startedAt < 1000 ? root.quickExits + 1 : 0
      if (root.quickExits < 5) restart.start()
    }
  }

  // A device brings several nodes at once, so announce it once the burst has
  // settled, and again a few seconds on: libinput hands a device to Hyprland
  // only once udev has finished with it, which can take longer than the burst.
  function announce() {
    settle.restart()
    followUp.restart()
  }

  Timer {
    id: settle
    interval: 500
    onTriggered: root.changed()
  }

  Timer {
    id: followUp
    interval: 3000
    onTriggered: root.changed()
  }

  Timer {
    id: restart
    interval: 1000
    onTriggered: watcher.running = true
  }
}
