#!/bin/bash
# Package Pixel-Panel for distribution

set -e

# Get the project root directory (parent of build-scripts)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

VERSION="1.0.0"  # Update this for each release
APP_NAME="pixel-panel"
DIST_DIR="dist"
PACKAGE_DIR="package"

echo "========================================"
echo "  Pixel-Panel Packaging Script"
echo "  Version: $VERSION"
echo "========================================"
echo ""

# Check if build exists
if [ ! -f "$DIST_DIR/$APP_NAME" ]; then
    echo "Error: Build not found. Run ./build.sh first."
    exit 1
fi

# Create package directory
mkdir -p "$PACKAGE_DIR"

# Get system info
ARCH=$(uname -m)
OS="linux"

# Package filename
PACKAGE_NAME="${APP_NAME}-${VERSION}-${OS}-${ARCH}"

echo "Creating distribution package: $PACKAGE_NAME"
echo ""

# Create tarball
echo "Creating tarball..."
mkdir -p "$PACKAGE_DIR/$PACKAGE_NAME"

# Copy executable
cp "$DIST_DIR/$APP_NAME" "$PACKAGE_DIR/$PACKAGE_NAME/"

# Copy resources if they exist
if [ -d "res" ]; then
    cp -r res "$PACKAGE_DIR/$PACKAGE_NAME/"
fi

# Create README for package
cat > "$PACKAGE_DIR/$PACKAGE_NAME/README.txt" << 'EOF'
Pixel-Panel - SD Card Manager for Spruce OS
============================================

Installation:
1. Extract this archive
2. Run: ./pixel-panel

System Requirements:
- Linux with Tk/Tcl libraries (most desktop distros have these)
- For SD card operations, you may need appropriate permissions

Optional - Add to system:
- Copy pixel-panel to /usr/local/bin/
- Or create a desktop shortcut pointing to this executable

For issues or updates, visit:
https://github.com/spruceUI/Pixel-Panel

Note: This is a standalone executable. No Python installation required.
EOF

# Create install script
cat > "$PACKAGE_DIR/$PACKAGE_NAME/install.sh" << 'EOF'
#!/bin/bash
# Install Pixel-Panel to system

echo "Installing Pixel-Panel..."

# Copy to /usr/local/bin
sudo cp pixel-panel /usr/local/bin/

# Make executable
sudo chmod +x /usr/local/bin/pixel-panel

echo "✓ Pixel-Panel installed to /usr/local/bin/"
echo ""
echo "You can now run it with: pixel-panel"
EOF

chmod +x "$PACKAGE_DIR/$PACKAGE_NAME/install.sh"

# Create tarball
cd "$PACKAGE_DIR"
tar -czf "${PACKAGE_NAME}.tar.gz" "$PACKAGE_NAME"
cd ..

# Create zip as well
cd "$PACKAGE_DIR"
zip -r "${PACKAGE_NAME}.zip" "$PACKAGE_NAME" > /dev/null
cd ..

# Calculate checksums
echo "Calculating checksums..."
cd "$PACKAGE_DIR"
sha256sum "${PACKAGE_NAME}.tar.gz" > "${PACKAGE_NAME}.tar.gz.sha256"
sha256sum "${PACKAGE_NAME}.zip" > "${PACKAGE_NAME}.zip.sha256"
cd ..

# Cleanup temp directory
rm -rf "$PACKAGE_DIR/$PACKAGE_NAME"

# Show results
echo ""
echo "✓ Packaging complete!"
echo ""
echo "Created packages:"
echo "  - $PACKAGE_DIR/${PACKAGE_NAME}.tar.gz"
echo "  - $PACKAGE_DIR/${PACKAGE_NAME}.zip"
echo ""
echo "With checksums:"
echo "  - $PACKAGE_DIR/${PACKAGE_NAME}.tar.gz.sha256"
echo "  - $PACKAGE_DIR/${PACKAGE_NAME}.zip.sha256"
echo ""

# Show sizes
echo "Package sizes:"
du -h "$PACKAGE_DIR/${PACKAGE_NAME}.tar.gz"
du -h "$PACKAGE_DIR/${PACKAGE_NAME}.zip"
echo ""

echo "Ready for distribution!"
