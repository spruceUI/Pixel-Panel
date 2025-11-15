# Pixel-Panel

A Python-based GUI application for flashing SD cards and managing device firmware for the Miyoo A30 and Spruce UI.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/spruceUI/Pixel-Panel.git
cd Pixel-Panel

# Install dependencies
pip install -r requirements.txt

# Run the application
python main.py
```

## Development

### Project Structure

```
apps/           # Application modules
  sd_flasher/   # SD card flashing functionality
  settings/     # Settings interface
  template/     # App template
lib/            # Core libraries
  gui/          # GUI components (buttons, terminal, styling)
  sd_card.py    # SD card operations
  usb_flasher.py
  window_manager.py
build-scripts/  # Build automation
res/            # Resources (icons, cursors, etc.)
```

### Building

**Linux:**
```bash
./build-scripts/build.sh
```

**Package:**
```bash
./build-scripts/package.sh
```
git bash test