#!/usr/bin/env bash
set -euo pipefail

#!/usr/bin/env bash
set -euo pipefail

# Step 1: Install dependencies (Debian/Ubuntu)
sudo apt install -y build-essential git cmake libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev gstreamer1.0-tools

# Step 2: Clone required repositories
if [ ! -d "Viper4Linux" ]; then
	git clone https://github.com/Audio4Linux/Viper4Linux.git
	cd Viper4Linux
fi
if [ ! -d "gst-plugin-viperfx" ]; then
	git clone https://github.com/Audio4Linux/gst-plugin-viperfx.git
fi
if [ ! -d "viperfx_core_binary" ]; then
	git clone https://github.com/vipersaudio/viperfx_core_binary.git
fi

# Step 3: Build gstreamer plugin
cd gst-plugin-viperfx
cmake .
make
sudo cp libgstviperfx.so /usr/lib/x86_64-linux-gnu/gstreamer-1.0/
cd ..

# Step 4: Install main library
sudo cp viperfx_core_binary/libviperfx_x64_linux.so /lib/libviperfx.so

# Step 5: Clean up build repos
rm -rf viperfx_core_binary gst-plugin-viperfx

# Step 6: Install config files
mkdir -p ~/.config/viper4linux
cp -r viper4linux/* ~/.config/viper4linux/
# Copy devices.conf.template to devices.conf if not present
if [ -f viper4linux/devices.conf.template ] && [ ! -f ~/.config/viper4linux/devices.conf ]; then
	cp viper4linux/devices.conf.template ~/.config/viper4linux/devices.conf
fi
# Copy audio.conf.template to audio.conf if not present
if [ -f viper4linux/audio.conf.template ] && [ ! -f ~/.config/viper4linux/audio.conf ]; then
	cp viper4linux/audio.conf.template ~/.config/viper4linux/audio.conf
fi

# Step 7: Install viper script to PATH
sudo cp viper /usr/local/bin
echo "Viper4Linux manual install complete!"
echo "You can start Viper4Linux with: viper start"

# Step 8: Test plugin install
gst-inspect-1.0 viperfx || echo "Warning: viperfx plugin not detected!"

echo "Viper4Linux manual install complete!"
echo "You can start Viper4Linux with: viper start"
