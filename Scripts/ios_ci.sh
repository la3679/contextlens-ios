#!/usr/bin/env bash
set -euo pipefail

mkdir -p artifacts
xcodebuild -version
xcrun swift --version
xcodebuild -showsdks

# Fail clearly if the pinned SDK's simulator runtime or device is unavailable.
xcrun simctl list devices available -j > artifacts/simulators.json
SIMULATOR_ID=$(python3 - <<'PY'
import json
with open("artifacts/simulators.json") as stream:
    devices = json.load(stream)["devices"]
matches = [d["udid"] for runtime, group in devices.items() if runtime.endswith("iOS-18-5")
           for d in group if d["name"] == "iPhone 16" and d.get("isAvailable")]
if not matches:
    raise SystemExit("Required iOS 18.5 / iPhone 16 simulator is unavailable.")
print(matches[0])
PY
)
xcrun simctl boot "$SIMULATOR_ID"
xcrun simctl bootstatus "$SIMULATOR_ID" -b
xcrun simctl status_bar "$SIMULATOR_ID" override --time '9:41' --batteryState charged --batteryLevel 100

xcodebuild -resolvePackageDependencies -project ContextLens.xcodeproj -scheme ContextLens
xcodebuild test \
  -project ContextLens.xcodeproj -scheme ContextLens \
  -destination "platform=iOS Simulator,id=$SIMULATOR_ID" \
  -derivedDataPath DerivedData -resultBundlePath artifacts/ContextLens.xcresult \
  -parallel-testing-enabled NO CODE_SIGNING_ALLOWED=NO \
  2>&1 | tee artifacts/xcodebuild.log

xcrun xcresulttool export attachments --path artifacts/ContextLens.xcresult --output-path artifacts/screenshots
