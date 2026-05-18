#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Clear screen for beautiful console outputs
clear

echo "=================================================="
echo "🚀  ZARF — AUTOMATED PRODUCTION BUILD PIPELINE  🚀"
echo "=================================================="
echo ""
echo "Step 1: Navigating to zarf_mobile directory..."
cd "$(dirname "$0")/zarf_mobile"

echo "Step 2: Cleaning old build caches..."
flutter clean

echo "Step 3: Fetching dependencies..."
flutter pub get

echo "Step 4: Compiling Production Release APK..."
flutter build apk --release

# Locate output APK path
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
  echo ""
  echo "Step 5: Copying and renaming compilation artifact..."
  # Create a build_artifacts directory at the workspace root
  mkdir -p ../build_artifacts
  
  # Copy and rename the compiled APK
  cp "$APK_PATH" "../build_artifacts/zarf.apk"
  
  echo ""
  echo "=================================================="
  echo "✅  SUCCESS! PRODUCTION BUILD COMPLETE  ✅"
  echo "=================================================="
  echo "Artifact created: build_artifacts/zarf.apk"
  echo "Location: $(pwd)/../build_artifacts/zarf.apk"
  echo "=================================================="
else
  echo ""
  echo "❌ Error: Production release APK could not be found at $APK_PATH"
  exit 1
fi
