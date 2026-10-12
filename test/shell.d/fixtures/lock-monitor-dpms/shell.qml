import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

ShellRoot {
  id: root

  readonly property string rootPath: Quickshell.env("OMARCHY_PATH")
  readonly property string resultPath: Quickshell.env("OMARCHY_QML_TEST_RESULT")
  readonly property string blankWorksPath: Quickshell.env("LOCK_TEST_BLANK_WORKS")
  property var failures: []
  property int checks: 0
  property var service: null
  property int dpmsQueries: 0
  property int queriesAtMark: 0
  property var steps: []

  Item { id: host }

  function check(condition, message) {
    checks += 1
    if (!condition) failures.push(message)
  }

  function finish() {
    if (service) {
      service.lockRequested = false
      service.destroy()
      service = null
    }
    var payload = JSON.stringify({ ok: failures.length === 0, checks: checks, failures: failures })
    var quoted = "'" + payload.replace(/'/g, "'\\''") + "'"
    Quickshell.execDetached(["bash", "-c", "printf '%s' " + quoted + " > \"$1\"", "_", resultPath])
  }

  // Every hyprctl the service starts is counted, whatever starts it.
  function watchQueries() {
    var objects = service.data || []
    for (var i = 0; i < objects.length; i++) {
      var command = objects[i].command
      if (command && command[0] === "hyprctl" && command[1] === "monitors") {
        objects[i].runningChanged.connect(function(process) {
          return function() { if (process.running) root.dpmsQueries += 1 }
        }(objects[i]))
        return
      }
    }
    throw new Error("Missing monitor DPMS process")
  }

  function setBlankWorks(works) {
    blankWorks.setText(works ? "yes" : "no")
  }

  function mark() {
    queriesAtMark = dpmsQueries
  }

  function since() {
    return dpmsQueries - queriesAtMark
  }

  FileView {
    id: blankWorks
    path: root.blankWorksPath
    blockWrites: true
  }

  // Each step waits for its delay, then runs; the next step starts after it.
  function next() {
    if (steps.length === 0) {
      finish()
      return
    }
    var step = steps.shift()
    stepTimer.action = step[1]
    stepTimer.interval = step[0]
    stepTimer.restart()
  }

  Timer {
    id: stepTimer
    property var action: null
    repeat: false
    onTriggered: {
      try {
        action()
        root.next()
      } catch (error) {
        root.failures.push(String(error))
        root.finish()
      }
    }
  }

  function start() {
    var component = Qt.createComponent("file://" + rootPath + "/shell/plugins/lock/Service.qml", Component.PreferSynchronous)
    if (component.status !== Component.Ready) throw new Error(component.errorString())
    service = component.createObject(host, { omarchyPath: rootPath })
    if (!service) throw new Error(component.errorString())
    watchQueries()

    steps = [
      [1500, function() {
        check(service.videoBackground, "the fixture wallpaper is a video")
        check(dpmsQueries === 0, "an unlocked video wallpaper never asks Hyprland about its panels")
        setBlankWorks(true)
        service.lockRequested = true
        mark()
      }],
      [4500, function() {
        check(since() === 1, "a video lock asks about its panels once, then waits for something to change (asked " + since() + " times)")
        check(service.monitorDpmsKnown && !service.screenBlank("TEST-1"), "a lit panel plays the locked video")
        mark()
        service.runBlank()
        check(service.screenBlank("TEST-1"), "a blank request pauses the video before Hyprland confirms it")
      }],
      [1500, function() {
        check(since() === 1, "a finished blank is confirmed with one question (asked " + since() + " times)")
        check(service.monitorDpmsKnown && service.screenBlank("TEST-1"), "a confirmed blank keeps the video paused")
        mark()
        service.runWake()
        check(!service.screenBlank("TEST-1"), "a wake request resumes the video before Hyprland confirms it")
      }],
      [1500, function() {
        check(since() === 1, "a finished wake is confirmed with one question (asked " + since() + " times)")
        check(service.monitorDpmsKnown && !service.screenBlank("TEST-1"), "a confirmed wake keeps the video playing")
        // The wake armed the lock's own 5 s blank; this time the panel refuses.
        setBlankWorks(false)
        mark()
      }],
      [5000, function() {
        check(since() === 1, "the idle blank is confirmed with one question (asked " + since() + " times)")
        check(service.displaysBlank, "the lock asked for the idle blank")
        check(service.monitorDpmsKnown && !service.screenBlank("TEST-1"), "a blank that failed keeps the video playing on the lit panel")
        mark()
      }],
      [4500, function() {
        check(since() === 0, "a settled lock asks nothing more (asked " + since() + " times)")
        service.lockRequested = false
      }],
      [200, function() {
        check(!service.monitorDpmsKnown, "unlocking forgets the panel state")
      }]
    ]
    next()
  }

  Timer {
    interval: 1
    running: true
    onTriggered: {
      try {
        root.start()
      } catch (error) {
        root.failures.push(String(error))
        root.finish()
      }
    }
  }
}
