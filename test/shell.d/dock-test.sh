#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

export OMARCHY_PATH="$ROOT"

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

ROOT="$ROOT" run_node_test <<'JS'
const dock = requireFromRoot('shell/plugins/dock/DockModel.js')

assertEqual(dock.normalizePosition('left'), 'left', 'dock accepts a valid position')
assertEqual(dock.normalizePosition(' Top '), 'top', 'dock reads a position loosely')
assertEqual(dock.normalizePosition('diagonal'), 'bottom', 'dock falls back to the bottom')
assertEqual(dock.normalizePosition(undefined), 'bottom', 'dock sits at the bottom by default')
assert(dock.isVertical('right') && !dock.isVertical('top'), 'dock runs vertically on the left and right')

assertDeepEqual(
  dock.pinnedIds({ pinned: ['chromium', 'org.gnome.Nautilus.desktop', 'chromium', ''] }, { pinned: ['spotify'] }),
  ['chromium', 'org.gnome.Nautilus'],
  'dock pins each desktop id once, without its .desktop suffix'
)
assertDeepEqual(dock.pinnedIds({}, { pinned: ['spotify'] }), ['spotify'], 'dock falls back to the default pins')
assertDeepEqual(dock.pinnedIds({ pinned: [] }, { pinned: ['spotify'] }), [], 'dock keeps an emptied pin list empty')

const items = dock.buildItems(['chromium', 'Alacritty'], [
  { key: 'signal', id: 1 },
  { key: 'chromium', id: 2 },
  { key: 'signal', id: 3 }
])
assertDeepEqual(
  items.map(item => [item.key, item.pinned, item.windows.map(window => window.id)]),
  [
    ['chromium', true, [2]],
    ['Alacritty', true, []],
    ['signal', false, [1, 3]]
  ],
  'dock lists pinned apps first, then running apps grouped by app'
)

assertEqual(dock.nextWindowIndex([]), -1, 'dock has no window to bring forward for an app that is not running')
assertEqual(dock.nextWindowIndex([false, false]), 0, 'dock brings forward the first window of an unfocused app')
assertEqual(dock.nextWindowIndex([false, true, false]), 2, 'dock cycles to the next window of a focused app')
assertEqual(dock.nextWindowIndex([false, true]), 0, 'dock cycles back around to the first window')
JS

home="$TMPDIR/home"
mkdir -p "$home/.config/omarchy"
mock_bin="$TMPDIR/bin"
mkdir -p "$mock_bin"
printf '#!/bin/bash\nexit 0\n' >"$mock_bin/omarchy-shell"
chmod +x "$mock_bin/omarchy-shell"
omarchy_dock() { HOME="$home" PATH="$mock_bin:$ROOT/bin:$PATH" omarchy-dock "$@"; }

[[ $(omarchy_dock position) == "bottom" ]] || fail "dock position defaults to bottom"
omarchy_dock position left >/dev/null
jq -e '.dock.position == "left" and .version == 1' "$home/.config/omarchy/shell.json" >/dev/null ||
  fail "dock position is saved" "$(cat "$home/.config/omarchy/shell.json")"
[[ $(omarchy_dock position) == "left" ]] || fail "dock position reads back"
if omarchy_dock position diagonal 2>/dev/null; then
  fail "dock position rejects anything but top, bottom, left, and right"
fi
pass "dock position is set and read through omarchy-dock"

[[ $(omarchy_dock pinned | head -1) == "chromium" ]] || fail "dock pins start from the defaults"
omarchy_dock unpin spotify >/dev/null
omarchy_dock pin com.example.App.desktop >/dev/null
omarchy_dock pin com.example.App >/dev/null
jq -e '
  .dock.pinned[-1] == "com.example.App" and
  (.dock.pinned | index("spotify")) == null and
  (.dock.pinned | map(select(. == "com.example.App")) | length) == 1 and
  .dock.position == "left"
' "$home/.config/omarchy/shell.json" >/dev/null ||
  fail "dock pins and unpins apps once each" "$(cat "$home/.config/omarchy/shell.json")"
pass "dock pins and unpins apps through omarchy-dock"

# The dock only shows on floating workspaces, and gets out of the way of a
# fullscreen window.
grep -qF 'dock.isFloating(workspaceId) && !(workspace && workspace.hasFullscreen)' "$ROOT/shell/plugins/dock/DockWindow.qml" ||
  fail "dock shows only on floating workspaces without a fullscreen window"
pass "dock shows only on floating workspaces without a fullscreen window"
