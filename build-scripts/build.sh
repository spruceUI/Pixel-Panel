#!/bin/bash
# Build script for Pixel-Panel on Linux

set -e  # Exit on error

# Get the project root directory (parent of build-scripts)
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

echo "========================================"
echo "  Pixel-Panel Linux Build Script"
echo "========================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if tkinter is available
check_tkinter() {
    python3 -c "import tkinter" 2>/dev/null
    return $?
}

# Install system dependencies if needed
install_system_deps() {
    if check_tkinter; then
        echo -e "${GREEN}✓ System dependencies already installed${NC}"
        return 0
    fi
    
    echo -e "${YELLOW}⚠ tkinter not found. Installing system dependencies...${NC}"
    echo ""
    
    # Detect Linux distribution
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    else
        echo -e "${RED}Cannot detect Linux distribution${NC}"
        echo "Please manually install: python3-tk, python3-dev, tk-devel"
        exit 1
    fi
    
    echo "Detected distribution: $DISTRO"
    echo ""
    
    # Install based on distribution
    case $DISTRO in
        ubuntu|debian|linuxmint|pop)
            echo "Installing dependencies for Debian/Ubuntu..."
            sudo apt-get update
            sudo apt-get install -y python3-tk python3-dev python3-venv python3-pip tk8.6-dev tcl8.6-dev
            ;;
        
        fedora|rhel|centos)
            echo "Installing dependencies for Fedora/RHEL..."
            sudo dnf install -y python3-tkinter python3-devel tk-devel tcl-devel
            ;;
        
        arch|manjaro|cachyos)
            echo "Installing dependencies for Arch..."
            sudo pacman -S --needed --noconfirm tk python python-pip
            ;;
        
        opensuse*)
            echo "Installing dependencies for openSUSE..."
            sudo zypper install -y python3-tk python3-devel tk-devel tcl-devel
            ;;
        
        *)
            echo -e "${RED}Unsupported distribution: $DISTRO${NC}"
            echo ""
            echo "Please manually install:"
            echo "  - Python 3.8+"
            echo "  - Tkinter (python3-tk or python3-tkinter)"
            echo "  - Python development headers"
            echo "  - Tk/Tcl development libraries"
            exit 1
            ;;
    esac
    
    echo ""
    echo -e "${GREEN}✓ System dependencies installed${NC}"
    echo ""
}

# Check and install system dependencies
install_system_deps

# Check if virtual environment is activated
if [ -z "$VIRTUAL_ENV" ]; then
    echo -e "${BLUE}Activating virtual environment...${NC}"
    if [ -d ".venv" ]; then
        source .venv/bin/activate
    else
        echo -e "${BLUE}Creating virtual environment...${NC}"
        python3 -m venv .venv
        source .venv/bin/activate
    fi
fi

# Install dependencies
echo -e "${BLUE}Installing dependencies...${NC}"
pip install --upgrade pip
pip install -r requirements.txt
pip install pyinstaller

# Clean previous builds
echo -e "${BLUE}Cleaning previous builds...${NC}"
rm -rf build dist 2>/dev/null || true

# Generate spec file if it doesn't exist
SPEC_FILE="$PROJECT_ROOT/build-scripts/pixel-panel.spec"
if [ ! -f "$SPEC_FILE" ]; then
    echo -e "${BLUE}Generating PyInstaller spec file...${NC}"
    pyi-makespec --onefile --windowed --name pixel-panel "$PROJECT_ROOT/main.py"
    mv pixel-panel.spec "$PROJECT_ROOT/build-scripts/"
fi

# Build the application
echo -e "${BLUE}Building Pixel-Panel...${NC}"
pyinstaller "$SPEC_FILE"

# Check if build was successful
if [ -f "dist/pixel-panel" ]; then
    echo ""
    echo -e "${GREEN}✓ Build successful!${NC}"
    echo ""
    echo "Executable location: $(pwd)/dist/pixel-panel"
    echo ""
    
    # Make it executable
    chmod +x dist/pixel-panel
    
    # Get file size
    SIZE=$(du -h dist/pixel-panel | cut -f1)
    echo "File size: $SIZE"
    echo ""
    
    echo ""
    echo -e "${GREEN}To run the application:${NC}"
    echo "  ./dist/pixel-panel"
    echo ""
    echo -e "${BLUE}To create a desktop entry:${NC}"
    echo "  ./build-scripts/create-desktop-entry.sh"
    echo ""
    echo -e "${BLUE}To create distribution packages:${NC}"
    echo "  ./build-scripts/package.sh"
    echo ""
else
    echo -e "${RED}✗ Build failed!${NC}"
    echo "Check the output above for errors."
    exit 1
fi
