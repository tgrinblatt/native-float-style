#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

APP_NAME="NativeFloatDemo"

echo "Building $APP_NAME..."
swift build -c release 2>&1

BINARY=$(swift build -c release --show-bin-path)/$APP_NAME

APP_BUNDLE="$SCRIPT_DIR/$APP_NAME.app"
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cp "$BINARY" "$APP_BUNDLE/Contents/MacOS/$APP_NAME"
cp "Sources/$APP_NAME/Info.plist" "$APP_BUNDLE/Contents/Info.plist"

echo "Build complete: $APP_BUNDLE"
