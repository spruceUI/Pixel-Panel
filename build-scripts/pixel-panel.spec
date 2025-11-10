# -*- mode: python ; coding: utf-8 -*-
"""
PyInstaller spec file for Pixel-Panel Linux build
"""

import os
from pathlib import Path
from PyInstaller.utils.hooks import collect_data_files, collect_submodules

# Get project root - work from current directory when running pyinstaller
# PyInstaller should be run from the project root
PROJECT_ROOT = Path.cwd()

block_cipher = None

# Collect all resource files
res_datas = []
res_dir = PROJECT_ROOT / 'res'
for root, dirs, files in os.walk(res_dir):
    for file in files:
        file_path = os.path.join(root, file)
        target_dir = os.path.dirname(os.path.relpath(file_path, PROJECT_ROOT))
        res_datas.append((file_path, target_dir))

# Collect tkinterdnd2 data files
tkinterdnd2_datas = collect_data_files('tkinterdnd2')

# All data files to include
datas = res_datas + tkinterdnd2_datas

# Hidden imports that PyInstaller might miss
hiddenimports = [
    'tkinter',
    'tkinter.ttk',
    'tkinterdnd2',
    'PIL._tkinter_finder',
    'py7zr',
    'psutil',
    'requests',
    'ctypes',
    'threading',
]

a = Analysis(
    [str(PROJECT_ROOT / 'main.py')],
    pathex=[str(PROJECT_ROOT)],
    binaries=[],
    datas=datas,
    hiddenimports=hiddenimports,
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='pixel-panel',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
