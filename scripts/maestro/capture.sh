#!/usr/bin/env bash
# M13 screenshot harness — captures the full gallery (light + dark) for every
# Maestro flow under .maestro/flows/. Usage:
#
#   scripts/maestro/capture.sh                # both themes
#   scripts/maestro/capture.sh light          # light only
#   scripts/maestro/capture.sh dark           # dark only
#
# Prerequisites:
#   * Maestro CLI installed   (https://maestro.mobile.dev/getting-started/installing-maestro)
#   * Flutter SDK on PATH
#   * An emulator/simulator already running (`flutter devices` should list it)
#   * `secrets.json` populated at the repo root (for the live build invocation)
#
# What it does:
#   1. Builds + installs the demo-boot variant once per theme via
#      --dart-define=COURRIER_DEMO_BOOT=true (+ COURRIER_DEMO_DARK on dark).
#   2. Drives every flow in .maestro/flows/.
#   3. Drops PNGs into build/screenshots/<theme>/.

set -euo pipefail

THEMES=("light" "dark")
if [[ $# -ge 1 ]]; then
  THEMES=("$1")
fi

if ! command -v maestro >/dev/null 2>&1; then
  echo "error: maestro CLI not installed — see https://maestro.mobile.dev/" >&2
  exit 1
fi

OUTDIR="build/screenshots"
mkdir -p "$OUTDIR"

for theme in "${THEMES[@]}"; do
  echo "==> capturing $theme gallery"
  themeArgs=("--dart-define=COURRIER_DEMO_BOOT=true")
  if [[ "$theme" == "dark" ]]; then
    themeArgs+=("--dart-define=COURRIER_DEMO_DARK=true")
  fi

  # Install the demo-boot build on the connected device.
  flutter run \
    "${themeArgs[@]}" \
    --dart-define-from-file=secrets.json \
    --no-pub \
    -d "${MAESTRO_TARGET:-}" \
    --no-hot \
    --release \
    --no-resident \
    --quiet

  # Drive each flow.
  mkdir -p "$OUTDIR/$theme"
  MAESTRO_COURRIER_THEME="$theme" \
    maestro test .maestro/flows/ \
      --format=junit \
      --output "$OUTDIR/$theme/junit.xml"

  # Maestro deposits screenshots into ~/.maestro/screenshots/; move them.
  find ~/.maestro/screenshots -name "*$theme*.png" \
    -exec mv {} "$OUTDIR/$theme/" \; 2>/dev/null || true

  echo "==> $theme gallery: $(ls "$OUTDIR/$theme" | wc -l) files"
done

echo "done. gallery under $OUTDIR/"
