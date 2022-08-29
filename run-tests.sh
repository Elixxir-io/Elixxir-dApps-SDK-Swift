#!/bin/sh
set -e

if [ "$1" = "ios" ]; then

  echo "\n\033[1;32m▶ Running tests on iOS Simulator...\033[0m"
  set -o pipefail && xcodebuild -scheme 'elixxir-dapps-sdk-swift-Package' -sdk iphonesimulator -destination 'platform=iOS Simulator,OS=15.5,name=iPhone 13' test | ./xcbeautify

elif [ "$1" = "macos" ]; then
  
  echo "\n\033[1;32m▶ Running tests on macOS...\033[0m"
  set -o pipefail && swift test 2>&1 | ./xcbeautify

else

  echo "Invalid option. Usage:"
  echo "  run-tests.sh ios   - Run tests on iOS Simulator"
  echo "  run-tests.sh macos - Run tests on macOS"
  exit 1

fi
