#!/bin/bash

set -euo pipefail

source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/base-test.sh"

test_root=$(mktemp -d)
test_bin=$(mktemp -d)

cleanup() {
  rm -rf "$test_root" "$test_bin"
}
trap cleanup EXIT

# Stub PipeWire: the sink list and the sink inputs are data files per scenario.
cat >"$test_bin/pactl" <<'STUB'
#!/bin/bash
case "$1 $2" in
  "list sinks") cat "$TEST_DATA/sinks" ;;
  "list sink-inputs") cat "$TEST_DATA/sink-inputs" 2>/dev/null ;;
  *) exit 1 ;;
esac
STUB
chmod +x "$test_bin/pactl"

speakers=alsa_output.usb-Speakers-00.analog-stereo
headphones=alsa_output.usb-Headphones-00.analog-stereo

fronted() {
  OMARCHY_PATH="$test_root/omarchy" TEST_DATA="$test_root/data" \
    PATH="$test_bin:$ROOT/bin:$PATH" bash "$ROOT/bin/omarchy-audio-tuning" fronted-sink
}

reset_scenario() {
  rm -rf "$test_root/data" "$test_root/omarchy"
  mkdir -p "$test_root/data" "$test_root/omarchy/default/audio/tunings"
  printf '60\t%s\tPipeWire\ts16le 2ch 48000Hz\tRUNNING\n61\t%s\tPipeWire\ts16le 2ch 48000Hz\tIDLE\n' \
    "$speakers" "$headphones" >"$test_root/data/sinks"
}

add_tuning_sink() {
  printf '70\tomarchy_speaker_tuning\tPipeWire\tfloat32le 2ch 48000Hz\tRUNNING\n' >>"$test_root/data/sinks"
}

# No tuning sink, nothing is fronted.
reset_scenario
[[ -z $(fronted) ]] || fail "no tuning sink fronts nothing"
pass "no tuning sink fronts nothing"

# A tuning sink no shipped tuning matches (a desktop running a community
# calibrator) fronts the sink its output plays into.
reset_scenario
add_tuning_sink
printf 'Sink Input #80\n  Sink: 60\n  node.name = "omarchy_speaker_tuning_output"\n' >"$test_root/data/sink-inputs"
[[ $(fronted) == "$speakers" ]] || fail "an unmatched tuning sink fronts the sink it plays into" "got: $(fronted)"
pass "unmatched tuning sink fronts the sink it plays into"

# Unlinked and unmatched, there is nothing to hide -- and never the tuning itself.
rm -f "$test_root/data/sink-inputs"
[[ -z $(fronted) ]] || fail "an unlinked unmatched tuning fronts nothing" "got: $(fronted)"
pass "unlinked unmatched tuning fronts nothing"

# A shipped tuning that matches still fronts its hardware while unlinked.
mkdir -p "$test_root/omarchy/default/audio/tunings/test"
printf 'match_command=true\nsink_pattern=usb-Speakers\n' >"$test_root/omarchy/default/audio/tunings/test/tuning.conf"
[[ $(fronted) == "$speakers" ]] || fail "an unlinked matched tuning fronts its hardware sink" "got: $(fronted)"
pass "unlinked matched tuning fronts its hardware sink"
