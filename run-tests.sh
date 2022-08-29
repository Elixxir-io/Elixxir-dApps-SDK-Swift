#!/bin/sh
set -e

echo -e "\e[0Ksection_start:`date +%s`:test_macos\r\e[0KRunning tests on macOS..."
set -o pipefail && swift test 2>&1 | ./xcbeautify
echo -e "\e[0Ksection_end:`date +%s`:test_macos\r\e[0K"

echo -e "\e[0Ksection_start:`date +%s`:test_ios\r\e[0KRunning tests on iOS Simulator..."
set -o pipefail && xcodebuild -scheme 'elixxir-dapps-sdk-swift-Package' -sdk iphonesimulator -destination 'platform=iOS Simulator,OS=15.5,name=iPhone 13' test | ./xcbeautify
echo -e "\e[0Ksection_end:`date +%s`:test_ios\r\e[0K"
