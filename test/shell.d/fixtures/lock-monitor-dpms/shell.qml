import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

ShellRoot {
  id: root

  readonly property string rootPath: Quickshell.env("OMARCHY_PATH")
  readonly property string resultPath: Quickshell.env("OMARCHY_QML_TEST_RESULT")
  readonly property string blankWorksPath: Quickshell.env("LOCK_TEST_BLANK_WORKS")
  readonly property string dpmsStatePath: Quickshell.env("LOCK_TEST_DPMS_STATE")
  readonly property string hyprctlFailuresPath: Quickshell.env("LOCK_TEST_HYPRCTL_FAILURES")
  readonly property string hyprctlHoldPath: Quickshell.env("LOCK_TEST_HYPRCTL_HOLD")
  property bool tracing: false
  property var trace: []
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

  // Every question the hyprctl stub answers is a line in its log. Counting
  // the process's running changes would not do: one restarted from its own
  // exit handler never reports stopping in between.
  FileView {
    id: queryLog
    path: Quickshell.env("LOCK_TEST_HYPRCTL_LOG")
    watchChanges: true
    printErrors: false
    onFileChanged: reload()
    onTextChanged: {
      var lines = String(text() || "").split("\n").filter(function(line) { return line !== "" })
      root.dpmsQueries = lines.length
    }
  }

  function setBlankWorks(works) {
    blankWorks.setText(works ? "yes" : "no")
  }

  // The service runs against the real compositor, so an output change while
  // locked would take a real session lock. Give any such lock straight back.
  function guardSessionLock() {
    var objects = service.data || []
    for (var i = 0; i < objects.length; i++) {
      var object = objects[i]
      if ("locked" in object && "secure" in object) {
        object.lockStateChanged.connect(function() {
          if (!object.locked) return
          object.locked = false
          root.failures.push("the fixture took a real session lock")
        })
        return
      }
    }
    throw new Error("Missing session lock")
  }

  function holdHyprctl(held) {
    Quickshell.execDetached(held ? ["touch", hyprctlHoldPath] : ["rm", "-f", hyprctlHoldPath])
  }

  function lockIpc() {
    var objects = service.data || []
    for (var i = 0; i < objects.length; i++) {
      if (objects[i].target === "lock" && typeof objects[i].lock === "function") return objects[i]
    }
    throw new Error("Missing lock IPC handler")
  }

  function resumeWatch() {
    var objects = service.data || []
    for (var i = 0; i < objects.length; i++) {
      if (objects[i].interval === 30000 && objects[i].repeat === false && "armedAt" in objects[i]) return objects[i]
    }
    throw new Error("Missing resume watch")
  }

  function blankTimer() {
    var objects = service.data || []
    for (var i = 0; i < objects.length; i++) {
      if (objects[i].interval === 5000 && objects[i].repeat === false && "armedAt" in objects[i]) return objects[i]
    }
    throw new Error("Missing blank timer")
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

  FileView {
    id: dpmsState
    path: root.dpmsStatePath
    // The stubs write these too, so follow them or an unchanged write is skipped.
    watchChanges: true
    onFileChanged: reload()
    blockWrites: true
  }

  FileView {
    id: hyprctlFailures
    path: root.hyprctlFailuresPath
    watchChanges: true
    onFileChanged: reload()
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
    guardSessionLock()
    // Records what the lock surface would show each time an answer lands.
    service.monitorDpmsKnownChanged.connect(function() {
      if (root.tracing && service.monitorDpmsKnown) root.trace.push(service.screenBlank("TEST-1"))
    })

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
        setBlankWorks(true)
        service.runBlank()
      }],
      [1500, function() {
        check(service.monitorDpmsKnown && service.screenBlank("TEST-1"), "the panel is dark before the suspend")
        // omarchy-system-sleep-lock asks for a lock before every suspend.
        service.passwordPamConfigured = true
        mark()
        check(lockIpc().lock() === "ok", "a lock request on a locked session succeeds")
        check(service.lockRequested, "a lock request on a locked session keeps it locked")
        check(!service.monitorDpmsKnown && blankTimer().running, "a lock request before suspend forgets the panels and starts a blank countdown")
        check(resumeWatch().running, "a lock request before suspend arms the resume watch")
      }],
      [300, function() {
        check(since() === 0, "getting ready for a resume neither wakes nor asks the panels (asked " + since() + " times)")
      }],
      [5000, function() {
        // Other inhibitors held the machine past the blank countdown.
        check(since() === 1 && service.monitorDpmsKnown && service.screenBlank("TEST-1"), "a suspend held past the countdown blanks first")
        check(resumeWatch().running, "the resume watch outlasts the countdown")
        // The suspend froze the resume watch, so it fires right after the
        // resume with a wall-clock gap; the resume lit the panel with no input.
        dpmsState.setText("on\n")
        var watch = resumeWatch()
        watch.interval = 1000
        watch.restart()
        watch.armedAt = Date.now() - 60000
        mark()
      }],
      [1500, function() {
        check(since() === 1, "a resume asks the panels once (asked " + since() + " times)")
        check(service.monitorDpmsKnown && !service.screenBlank("TEST-1"), "a panel the resume lit plays the video")
        check(blankTimer().running, "a resume starts a fresh blank countdown")
        mark()
      }],
      [5500, function() {
        check(since() === 1, "the blank after the run-up is confirmed with one question (asked " + since() + " times)")
        check(service.monitorDpmsKnown && service.screenBlank("TEST-1"), "the run-up ends with the panel blanked again")
        // Hyprland fails to answer once, as it can while outputs reconfigure.
        hyprctlFailures.setText("1\n")
        mark()
        service.runBlank()
      }],
      [2500, function() {
        check(since() === 2, "a failed question is asked again (asked " + since() + " times)")
        check(service.monitorDpmsKnown && service.screenBlank("TEST-1"), "the retried answer pauses the video on the dark panel")
        service.runWake()
      }],
      [1500, function() {
        check(service.monitorDpmsKnown && !service.screenBlank("TEST-1"), "the panel is lit before the overlapping questions")
        // Hyprland is slow to answer the next question, which sees a lit panel.
        holdHyprctl(true)
      }],
      [300, function() {
        mark()
        tracing = true
        // Any of the lock's triggers asks the same way.
        service.refreshMonitorDpms()
      }],
      [300, function() {
        // The lock blanks while that answer is still on its way.
        service.runBlank()
      }],
      [700, function() {
        check(service.screenBlank("TEST-1"), "a blank asked for during a slow question pauses the video")
        holdHyprctl(false)
      }],
      [1000, function() {
        check(since() === 2, "the question overtaken by the blank is asked again once (asked " + since() + " times)")
        check(service.monitorDpmsKnown && service.screenBlank("TEST-1"), "the fresh answer confirms the blank")
        check(trace.indexOf(false) === -1, "the overtaken answer never restarts the video (" + JSON.stringify(trace) + ")")
        tracing = false
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
