#!/usr/bin/env bash
set -euo pipefail

# Build a simple .deb package for Viper4Linux.
# This script compiles the required gstreamer plugin and bundles
# the Viper4Linux script and configuration into a Debian package.
# Usage: ./build_deb.sh

WORKDIR="$(mktemp -d)"
PKGDIR="$WORKDIR"

mkdir -p "$PKGDIR/usr/bin" \
         "$PKGDIR/usr/local/bin" \
         "$PKGDIR/usr/lib/x86_64-linux-gnu/gstreamer-1.0" \
         "$PKGDIR/usr/lib" \
         "$PKGDIR/home/$USER/.config/viper4linux"


# Build the gstreamer plugin
git clone https://github.com/Audio4Linux/gst-plugin-viperfx.git "$WORKDIR/gst-plugin-viperfx"
(
  cd "$WORKDIR/gst-plugin-viperfx"
  cmake .
  make
  if [ ! -f libgstviperfx.so ]; then
    echo "ERROR: libgstviperfx.so not found after build!" >&2
    exit 1
  fi
  cp libgstviperfx.so "$PKGDIR/usr/lib/x86_64-linux-gnu/gstreamer-1.0/"
)


# Fetch the core binary
git clone https://github.com/vipersaudio/viperfx_core_binary.git "$WORKDIR/viperfx_core_binary"
if [ ! -f "$WORKDIR/viperfx_core_binary/libviperfx_x64_linux.so" ]; then
  echo "ERROR: libviperfx_x64_linux.so not found!" >&2
  exit 1
fi
cp "$WORKDIR/viperfx_core_binary/libviperfx_x64_linux.so" "$PKGDIR/usr/lib/libviperfx.so"




 # Install the script to /usr/bin and /usr/local/bin so it can be easily found in PATH
cp viper "$PKGDIR/usr/bin/"
cp viper "$PKGDIR/usr/local/bin/"
cp -r viper4linux/* "$PKGDIR/home/$USER/.config/viper4linux/"

 # Copy audio.conf.template to audio.conf so the user gets a config immediately
cp viper4linux/audio.conf "$PKGDIR/home/$USER/.config/viper4linux/audio.conf"


# Create control file
mkdir -p "$WORKDIR/DEBIAN"
cat > "$WORKDIR/DEBIAN/control" <<'CTL'
Package: viper4linux
Version: 1.0
Section: sound
Priority: optional
Architecture: amd64
Depends: gstreamer1.0-tools, gstreamer1.0-plugins-base, build-essential, git, cmake, libgstreamer-plugins-base1.0-dev, libgstreamer1.0-dev
Maintainer: Viper4Linux contributors
Description: Viper4Linux audio effects processor
CTL


dpkg-deb --build "$WORKDIR" viper4linux_1.0_amd64.deb
echo "Package built: viper4linux_1.0_amd64.deb"

# Clean up
rm -rf "$WORKDIR"
