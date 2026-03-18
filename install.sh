#!/usr/bin/env bash
set -e

SCRIPT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL="$HOME/.local/share/NullPass"
BIN="$HOME/.local/bin"
DESK="$HOME/.local/share/applications"

echo "NullPass installer"
echo "------------------"

if ! command -v python3 &>/dev/null; then
    echo "Python 3 not found."
    echo "Arch:    sudo pacman -S python"
    echo "Ubuntu:  sudo apt install python3"
    exit 1
fi

PY=$(command -v python3)
echo "[ok] $($PY --version)"

if ! $PY -c "import tkinter" &>/dev/null; then
    echo "Installing tkinter..."
    if   command -v pacman &>/dev/null; then sudo pacman -S --noconfirm tk
    elif command -v apt    &>/dev/null; then sudo apt install -y python3-tk
    elif command -v dnf    &>/dev/null; then sudo dnf install -y python3-tkinter
    fi
fi

echo "Installing packages..."
$PY -m pip install --quiet cryptography argon2-cffi Pillow 2>/dev/null || \
$PY -m pip install --quiet --break-system-packages cryptography argon2-cffi Pillow
echo "[ok] packages"

mkdir -p "$INSTALL"
cp "$SCRIPT/nullpass.py" "$INSTALL/"
[ -f "$SCRIPT/icon.png" ] && cp "$SCRIPT/icon.png" "$INSTALL/"
echo "[ok] installed to $INSTALL"

mkdir -p "$BIN"
printf '#!/usr/bin/env bash\nexec %s "%s/nullpass.py" "$@"\n' "$PY" "$INSTALL" > "$BIN/nullpass"
chmod +x "$BIN/nullpass"
echo "[ok] launcher: $BIN/nullpass"

mkdir -p "$DESK"
cat > "$DESK/nullpass.desktop" <<EOF
[Desktop Entry]
Name=NullPass
Comment=Password manager
Exec=$BIN/nullpass
Icon=$INSTALL/icon.png
Terminal=false
Type=Application
Categories=Utility;Security;
EOF
command -v update-desktop-database &>/dev/null && update-desktop-database "$DESK" 2>/dev/null || true
echo "[ok] desktop entry"

if [[ ":$PATH:" != *":$BIN:"* ]]; then
    echo ""
    echo "Add to ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo ""
echo "Done. Run: nullpass"
