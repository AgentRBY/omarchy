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

// Pinned apps come first, in pin order, whether or not they run. Running apps
// that are not pinned follow in the order their first window appeared. Each
// window is { key, ... } where key is the app's desktop id, or its app id when
// no desktop entry claims it.
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
    if (window && window.key) itemFor(window.key, false).windows.push(window)
  }

  return items
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
    buildItems: buildItems,
    nextWindowIndex: nextWindowIndex
  }
}
