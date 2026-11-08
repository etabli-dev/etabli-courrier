#!/usr/bin/env bash
# Build an ad-hoc review app without claiming team-signed Keychain support.
set -euo pipefail
cd "$(dirname "$0")/.."
flutter build macos --release --config-only --no-pub
xcodebuild -workspace macos/Runner.xcworkspace -scheme Runner \
  -configuration Release -derivedDataPath build/macos -jobs 2 \
  COURRIER_CODE_SIGN_ENTITLEMENTS="$PWD/macos/Runner/Preview.entitlements" build
app=build/macos/Build/Products/Release/courrier.app
codesign --verify --deep --strict "$app"
test -f "$app/Contents/Resources/PrivacyInfo.xcprivacy"
printf '%s\n' 'Preview compiled. Keychain account persistence still requires a team-signed build and device validation.'
