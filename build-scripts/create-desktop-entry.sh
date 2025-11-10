#!/bin/bash
# Create a desktop entry for Pixel-Panel

set -e

APP_NAME="Pixel-Panel"
EXEC_PATH="$(pwd)/dist/pixel-panel"
ICON_PATH="$(pwd)/res/apps/sd.png"
DESKTOP_FILE="$HOME/.local/share/applications/pixel-panel.desktop"

# Check if executable exists
if [ ! -f "$EXEC_PATH" ]; then
    echo "Error: Executable not found at $EXEC_PATH"
    echo "Please build the application first using ./build.sh"
    exit 1
fi

# Create .local/share/applications if it doesn't exist
mkdir -p "$HOME/.local/share/applications"

# Create desktop entry
cat > "$DESKTOP_FILE" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$APP_NAME
Comment=SD Card Manager for Spruce OS and Retro Handhelds
Exec=$EXEC_PATH
Icon=$ICON_PATH
Terminal=false
Categories=Utility;System;
Keywords=sd;flash;spruce;miyoo;retro;
StartupNotify=true
EOF

# Make executable
chmod +x "$DESKTOP_FILE"

echo "✓ Desktop entry created successfully!"
echo ""
echo "Location: $DESKTOP_FILE"
echo ""
echo "You can now find '$APP_NAME' in your application menu."
echo ""

# Update desktop database if update-desktop-database is available
if command -v update-desktop-database &> /dev/null; then
    update-desktop-database "$HOME/.local/share/applications"
    echo "✓ Desktop database updated"
fi
