#!/bin/bash
set -e

# Uninstall Viper4Linux and all related files

# Remove GStreamer plugin
if [ -f /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstviperfx.so ]; then
    sudo rm /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstviperfx.so
fi
if [ -f /usr/lib/gstreamer-1.0/libgstviperfx.so ]; then
    sudo rm /usr/lib/gstreamer-1.0/libgstviperfx.so
fi

# Remove main library
if [ -f /usr/lib/libviperfx.so ]; then
    sudo rm /usr/lib/libviperfx.so
fi
if [ -f /lib/libviperfx.so ]; then
    sudo rm /lib/libviperfx.so
fi
if [ -f /usr/lib64/libviperfx.so ]; then
    sudo rm /usr/lib64/libviperfx.so
fi

# Remove viper executable
if command -v viper >/dev/null 2>&1; then
    sudo rm $(command -v viper)
fi

# Remove config directory
if [ -d "$HOME/.config/viper4linux" ]; then
    rm -rf "$HOME/.config/viper4linux"
fi
if [ -d "/etc/viper4linux" ]; then
    sudo rm -rf "/etc/viper4linux"
fi

echo "Viper4Linux and related files have been removed."
