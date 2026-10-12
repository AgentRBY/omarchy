#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

test_tmp=$(mktemp -d) || fail "test temp directory is available"
trap 'rm -rf "$test_tmp"' EXIT

fake_bin="$test_tmp/bin"
mkdir -p "$fake_bin"

cat >"$fake_bin/lspci" <<'STUB'
#!/bin/bash
printf '00:02.0 VGA compatible controller: %s\n' "$TEST_GPU"
STUB

cat >"$fake_bin/omarchy-pkg-add" <<'STUB'
#!/bin/bash
echo "$*" >"$TEST_INSTALLED"
STUB

chmod +x "$fake_bin"/*

installed_for() {
  rm -f "$test_tmp/installed"
  TEST_GPU=$1 TEST_INSTALLED="$test_tmp/installed" PATH="$fake_bin:$PATH" \
    bash -c 'source "$ROOT/install/hardware/intel/video-acceleration.sh"'
  if [[ -f $test_tmp/installed ]]; then
    cat "$test_tmp/installed"
  fi
}

media_driver="intel-media-driver libvpl vpl-gpu-rt"

for gpu in \
  "Intel Corporation Wildcat Lake [Intel Graphics] (rev 01)" \
  "Intel Corporation Meteor Lake-P [Intel Graphics] (rev 08)" \
  "Intel Corporation Arrow Lake-P [Intel Graphics] (rev 03)" \
  "Intel Corporation Lunar Lake [Intel Graphics] (rev 04)" \
  "Intel Corporation Raptor Lake-P [Intel Graphics] (rev 04)" \
  "Intel Corporation Alder Lake-N [Intel Graphics]" \
  "Intel Corporation Battlemage G21 [Intel Graphics]" \
  "Intel Corporation Panther Lake [Intel Graphics] (rev 04)" \
  "Intel Corporation Alder Lake-P GT2 [Iris Xe Graphics] (rev 0c)" \
  "Intel Corporation CometLake-U GT2 [UHD Graphics] (rev 02)"; do
  [[ $(installed_for "$gpu") == "$media_driver" ]] || fail "intel-media-driver is installed for $gpu"
done
pass "intel-media-driver is installed for Gen8+ Intel GPUs, including those named only [Intel Graphics]"

[[ -z $(installed_for "Advanced Micro Devices, Inc. [AMD/ATI] Phoenix1 (rev c1)") ]] ||
  fail "nothing is installed without an Intel GPU"
pass "nothing is installed without an Intel GPU"
