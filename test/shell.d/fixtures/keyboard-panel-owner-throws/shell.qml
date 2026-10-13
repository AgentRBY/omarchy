import QtQuick
import Quickshell
import qs.Ui

// Drives the real KeyboardPanel's close() with an owner whose close() throws,
// the way a plugin cloned before a shell API change does. The panels are
// pinned invisible so nothing maps on the desktop running the test.
ShellRoot {
  id: test
  property bool failed: false

  function check(ok, message) {
    if (!ok) {
      failed = true
      console.log("RESULT fail " + message)
    }
  }

  Item {
    id: anchor
    width: 10
    height: 10
  }

  QtObject {
    id: brokenOwner
    property bool opened: true
    function close() { throw new Error("plugin close failed") }
  }

  QtObject {
    id: workingOwner
    property bool opened: true
    property int closes: 0
    function close() {
      closes++
      opened = false
    }
  }

  KeyboardPanel {
    id: broken
    anchorItem: anchor
    bar: null
    owner: brokenOwner
    open: brokenOwner.opened
    visible: false
  }

  KeyboardPanel {
    id: working
    anchorItem: anchor
    bar: null
    owner: workingOwner
    open: workingOwner.opened
    visible: false
  }

  Timer {
    interval: 100
    running: true
    onTriggered: {
      test.check(broken.open, "the broken owner's panel starts open")
      try {
        broken.close()
      } catch (e) {
        test.check(false, "close() lets the owner's exception escape: " + e)
      }
      test.check(!broken.open, "a panel whose owner's close() throws still closes")

      working.close()
      test.check(workingOwner.closes === 1 && !working.open, "close() delegates to an owner that closes normally")
      workingOwner.opened = true
      test.check(working.open, "the panel still follows its owner after a normal close")

      console.log(test.failed ? "RESULT fail" : "RESULT pass")
      Qt.quit()
    }
  }
}
