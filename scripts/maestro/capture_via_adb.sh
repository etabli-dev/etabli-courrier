#!/usr/bin/env bash
# adb-driven gallery capture — the shorter-loop sibling to capture.sh.
#
# Usage:
#   scripts/maestro/capture_via_adb.sh                  # captures to docs/_screens/0.1.0/
#   OUT=/tmp/gallery scripts/maestro/capture_via_adb.sh # custom output dir
#
# Prerequisites:
#   * adb on PATH and an emulator/device booted (`adb devices` shows one)
#   * The demo APK built + installed:
#       flutter build apk --debug --target-platform android-arm64 \
#         --dart-define-from-file=secrets.json \
#         --dart-define=COURRIER_DEMO_BOOT=true
#       adb install -r build/app/outputs/flutter-apk/app-debug.apk
#
# Why this exists alongside capture.sh:
#   * capture.sh runs the Maestro flows (canonical, includes light+dark + CI
#     artefacts). Those flows depend on testIDs the shell does not yet
#     expose for every nav target — see M13 follow-ups in BUILD_LOG.
#   * This script just taps the bottom-nav tabs in known coordinates against
#     a Pixel-class 1080x2340 viewport, then `screencap -p`s each module.
#     It is the path used to capture the v0.1.0 gallery embedded in the
#     vignettes; reproducible, fast, no test-id dependency.

set -euo pipefail

OUT="${OUT:-docs/_screens/0.1.0}"
mkdir -p "$OUT"

if ! command -v adb >/dev/null 2>&1; then
  echo "error: adb not on PATH" >&2
  exit 1
fi

if ! adb shell true >/dev/null 2>&1; then
  echo "error: adb cannot reach a device (boot the emulator first)" >&2
  exit 1
fi

shot() {
  local name="$1"
  adb exec-out screencap -p > "$OUT/$name.png"
  echo "  captured $OUT/$name.png ($(wc -c < "$OUT/$name.png") bytes)"
}

# Fresh launch so we land on the mail tab.
adb shell am force-stop dev.etabli.courrier
sleep 1
adb shell am start -n dev.etabli.courrier/.MainActivity >/dev/null
echo "==> waiting for splash to clear"
sleep 10

# Bottom-nav x centres on a 1080-wide viewport for the 6-tab layout.
# Each tab is 1080/6 = 180px wide; centres at x = 90 + i*180.
MAIL_X=90
CAL_X=270
CONT_X=450
TASK_X=630
NOTE_X=810
FEED_X=990
NAV_Y=2150

echo "==> 01 mail"
shot 01-mail

echo "==> 02 calendar (agenda)"
adb shell input tap $CAL_X $NAV_Y; sleep 3
shot 02-calendar

echo "==> 07 calendar (month)"
adb shell input tap 472 378  # Month toggle pill centre
sleep 3
shot 07-calendar-month
adb shell input tap 200 378  # back to Agenda for cleanliness
sleep 2

echo "==> 03 contacts"
adb shell input tap $CONT_X $NAV_Y; sleep 3
shot 03-contacts

echo "==> 08 contact detail (Grace Hopper, 2nd row)"
adb shell input tap 540 620; sleep 4
shot 08-contact-detail
adb shell input tap $CONT_X $NAV_Y; sleep 2  # back via tab

echo "==> 04 tasks"
adb shell input tap $TASK_X $NAV_Y; sleep 3
shot 04-tasks

echo "==> 05 notes"
adb shell input tap $NOTE_X $NAV_Y; sleep 3
shot 05-notes

echo "==> 06 feeds"
adb shell input tap $FEED_X $NAV_Y; sleep 3
shot 06-feeds

# Back to mail for steady state.
adb shell input tap $MAIL_X $NAV_Y; sleep 2

echo "==> done. gallery under $OUT/"
ls -la "$OUT"
