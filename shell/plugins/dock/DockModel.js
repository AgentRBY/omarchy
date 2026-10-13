// The dock's state that does not need Quickshell: where it sits, which apps it
// shows, and which window a click brings forward.

var POSITIONS = ["top", "bottom", "left", "right"]

function normalizePosition(value) {
  var position = String(value || "").trim().toLowerCase()
  return POSITIONS.indexOf(position) >= 0 ? position : "bottom"
}

function isVertical(position) {
  var normalized = normalizePosition(position)
  return normalized === "left" || normalized === "right"
}

function normalizeId(value) {
  var id = String(value || "").trim()
  if (id.slice(-8) === ".desktop") id = id.slice(0, -8)
  return id
}

function pinnedIds(dockConfig, defaultsConfig) {
  var source = dockConfig && Array.isArray(dockConfig.pinned) ? dockConfig.pinned
    : (defaultsConfig && Array.isArray(defaultsConfig.pinned) ? defaultsConfig.pinned : [])
  var ids = []
  for (var i = 0; i < source.length; i++) {
    var id = normalizeId(source[i])
    if (id && ids.indexOf(id) === -1) ids.push(id)
  }
  return ids
}

// Only app windows on regular workspaces, or minimized, belong in the dock. Helpers without a
// visible desktop entry, such as the agent window, and anything parked on a
// special workspace, such as the scratchpad, stay out of it.
function isDockWindow(window) {
  return !!window && !!window.key && window.hasEntry === true && (window.workspaceId >= 1 || window.minimized === true)
}

// Minimizing moves a window to this special workspace, and the dock brings it
// back.
var MINIMIZED_WORKSPACE = "special:minimized"

function isMinimizedWorkspace(name) {
  return String(name || "") === MINIMIZED_WORKSPACE
}

// A terminal app's window carries the app id its launcher gave the terminal,
// which no desktop entry names as its class. The entry that passes that app id
// claims it, and so does a terminal entry for the command Omarchy's TUI
// launcher named it after (org.omarchy.nvim for nvim). Entries are
// { id, execString, command, runInTerminal }.
function claimingEntryId(appId, entries) {
  var id = String(appId || "")
  if (!id) return ""
  var list = entries || []
  var flag = "--app-id=" + id
  for (var i = 0; i < list.length; i++) {
    var words = String(list[i].execString || "").split(/\s+/)
    if (words.indexOf(flag) >= 0) return list[i].id
  }
  if (id.indexOf("org.omarchy.") !== 0) return ""
  var command = id.slice("org.omarchy.".length)
  for (var j = 0; j < list.length; j++) {
    var program = String((list[j].command || [])[0] || "")
    if (list[j].runInTerminal && program.slice(program.lastIndexOf("/") + 1) === command) return list[j].id
  }
  return ""
}

// The command Omarchy's TUI launcher runs for a terminal entry, without the
// field codes the entry leaves for a launcher to fill in.
function terminalCommand(command) {
  return (command || []).filter(function(word) { return !/^%[a-zA-Z]$/.test(String(word)) })
}

// Pinned apps come first, in pin order, whether or not they run. Running apps
// that are not pinned follow in the order their first window appeared. Each
// window is { key, hasEntry, workspaceId, ... } where key is the desktop id of
// the entry that claims it.
function buildItems(pinned, windows) {
  var items = []
  var byKey = {}

  function itemFor(key, isPinned) {
    if (!byKey[key]) {
      byKey[key] = { key: key, pinned: isPinned, windows: [] }
      items.push(byKey[key])
    }
    return byKey[key]
  }

  for (var i = 0; i < (pinned || []).length; i++) {
    if (pinned[i]) itemFor(pinned[i], true)
  }

  for (var j = 0; j < (windows || []).length; j++) {
    var window = windows[j]
    if (isDockWindow(window)) itemFor(window.key, false).windows.push(window)
  }

  return items
}

// Puts the items in the dock's own order, which the dock keeps for the
// session: an app keeps its slot while it stays in the dock, and an app that
// joins goes at the end. Items the order does not know yet follow in the order
// buildItems gave them.
function orderItems(items, order) {
  var byKey = {}
  for (var i = 0; i < (items || []).length; i++) byKey[items[i].key] = items[i]
  var result = []
  var placed = {}
  for (var j = 0; j < (order || []).length; j++) {
    var key = order[j]
    if (byKey[key] && !placed[key]) {
      result.push(byKey[key])
      placed[key] = true
    }
  }
  for (var k = 0; k < (items || []).length; k++) {
    if (!placed[items[k].key]) result.push(items[k])
  }
  return result
}

// The order after an app is kept in the dock: it moves to the end.
function orderWithKeyLast(order, key) {
  return (order || []).filter(function(other) { return other !== key }).concat([key])
}

// Where a dragged icon lands: its own slot moved by however many slots the
// pointer has travelled, kept within the dock.
function dropIndex(fromIndex, offset, slotSize, count) {
  if (count <= 0 || !(slotSize > 0)) return fromIndex
  var target = fromIndex + Math.round(offset / slotSize)
  return Math.max(0, Math.min(count - 1, target))
}

// The pin list after dragging the item at fromIndex to toIndex. The dragged
// app is pinned where it lands, as are the pinned apps around it in their new
// order. Pins the dock is not showing, because their app is not installed,
// keep their place at the end.
function movedPins(items, allPinned, fromIndex, toIndex) {
  var keys = (items || []).map(function(item) { return item.key })
  if (fromIndex < 0 || fromIndex >= keys.length) return (allPinned || []).slice()
  var moved = keys.splice(fromIndex, 1)[0]
  keys.splice(Math.max(0, Math.min(keys.length, toIndex)), 0, moved)

  var pinned = {}
  for (var i = 0; i < items.length; i++) {
    if (items[i].pinned) pinned[items[i].key] = true
  }
  pinned[moved] = true

  var result = keys.filter(function(key) { return pinned[key] })
  var shown = {}
  for (var j = 0; j < keys.length; j++) shown[keys[j]] = true
  for (var k = 0; k < (allPinned || []).length; k++) {
    if (!shown[allPinned[k]] && result.indexOf(allPinned[k]) === -1) result.push(allPinned[k])
  }
  return result
}

// The pin list after an app is dropped on the dock before the slot at index,
// counted as the slots stand. An app the dock already shows moves there; any
// other app joins it there.
function pinnedAt(items, allPinned, key, index) {
  var list = (items || []).slice()
  var from = -1
  for (var i = 0; i < list.length; i++) {
    if (list[i].key === key) { from = i; break }
  }
  if (from < 0) {
    list.push({ key: key, pinned: true })
    from = list.length - 1
  }
  return movedPins(list, allPinned, from, from < index ? index - 1 : index)
}

// Clicking an app whose window is focused moves on to its next window, so
// repeated clicks cycle through them. Otherwise the first window comes forward.
function nextWindowIndex(activeFlags) {
  var count = (activeFlags || []).length
  if (count === 0) return -1
  for (var i = 0; i < count; i++) {
    if (activeFlags[i]) return (i + 1) % count
  }
  return 0
}

if (typeof module !== "undefined") {
  module.exports = {
    normalizePosition: normalizePosition,
    isVertical: isVertical,
    normalizeId: normalizeId,
    pinnedIds: pinnedIds,
    isDockWindow: isDockWindow,
    isMinimizedWorkspace: isMinimizedWorkspace,
    claimingEntryId: claimingEntryId,
    terminalCommand: terminalCommand,
    buildItems: buildItems,
    orderItems: orderItems,
    orderWithKeyLast: orderWithKeyLast,
    dropIndex: dropIndex,
    movedPins: movedPins,
    pinnedAt: pinnedAt,
    nextWindowIndex: nextWindowIndex
  }
}
