#!/usr/bin/env bash
set -e

echo "=== Installing dependencies ==="
sudo apt update
sudo apt install -y \
    meson ninja-build build-essential git pkg-config \
    libudev-dev libgudev-1.0-dev libgusb-dev libgirepository1.0-dev \
    libcairo-dev libpixman-1-dev libnss3-dev libpam-wrapper \
    libpamtest-dev gtk-doc-tools libssl-dev

echo "=== Preparing workspace ==="
INSTALL_DIR="$HOME/.software/installers/libfprint"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

if [ ! -d ".git" ]; then
    echo "=== Cloning libfprint fork ==="
    git clone https://gitlab.freedesktop.org/depau/libfprint.git "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

echo "=== Fetching branches ==="
git fetch --all

echo "=== Switching to origin/elanmoc2 branch ==="
git switch -f origin/elanmoc2

echo "=== Applying Meson udev patch ==="
MESON_FILE="$INSTALL_DIR/meson.build"

# Patch the udev rule line exactly as requested
sed -i \
    "s|udev_rules_dir = udev_dep.get_variable(pkgconfig: 'udevdir') + '/rules.d'|udev_dir = udev_dep.get_pkgconfig_variable('udev_dir', default: '/usr/lib/udev')|" \
    "$MESON_FILE"

echo "=== Creating udev.pc symlink if needed ==="
UDEV_PC="/usr/lib/x86_64-linux-gnu/pkgconfig/udev.pc"
LIBUDEV_PC="/usr/lib/x86_64-linux-gnu/pkgconfig/libudev.pc"

if [ ! -f "$UDEV_PC" ]; then
    sudo ln -s "$LIBUDEV_PC" "$UDEV_PC"
fi

echo "=== Cleaning old build directory ==="
rm -rf "$INSTALL_DIR/builddir"

echo "=== Running Meson setup ==="
meson setup builddir

echo "=== Compiling libfprint ==="
cd builddir
meson compile

echo "=== Installing libfprint ==="
sudo meson install
sudo ldconfig

echo "=== Restarting fingerprint service ==="
sudo systemctl restart fprintd

echo "=== Done! Try enrolling a fingerprint with: fprintd-enroll ==="
