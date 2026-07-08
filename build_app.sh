#!/bin/bash
set -eo pipefail

APP_NAME="即建"
APP_BUNDLE="$APP_NAME.app"
BUILD_DIR=".build/arm64-apple-macosx/debug"

echo "=== Building ==="
xcrun swift build 2>&1

echo "=== Creating app bundle ==="
rm -rf "$APP_BUNDLE"
mkdir -p "$APP_BUNDLE/Contents/MacOS"
mkdir -p "$APP_BUNDLE/Contents/Resources"

cp "$BUILD_DIR/RightClickMenuApp" "$APP_BUNDLE/Contents/MacOS/RightClickMenu"
cp "$BUILD_DIR/rclick" "$APP_BUNDLE/Contents/Resources/rclick"

# Create Info.plist
cat > "$APP_BUNDLE/Contents/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleDisplayName</key>
    <string>即建</string>
    <key>CFBundleExecutable</key>
    <string>RightClickMenu</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIdentifier</key>
    <string>com.rightclickmenu.app</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>即建</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
</dict>
</plist>
PLIST

# Copy icon
if [ -f "AppIcon.icns" ]; then
    cp AppIcon.icns "$APP_BUNDLE/Contents/Resources/"
fi

echo "=== Signing ==="
codesign --force --sign - "$APP_BUNDLE" 2>&1 || true

echo "=== Installing to /Applications ==="
rm -rf "/Applications/$APP_BUNDLE"
cp -R "$APP_BUNDLE" /Applications/

echo ""
echo "✅ 安装完成！"
echo "点击菜单栏图标新建文件，或按 ⌥⌘N 快捷键"
