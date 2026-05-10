# PENOS: Portable Linux Environment for iOS

PENOS is an ultra-lightweight, persistent Linux distribution designed specifically for iPhone and iPad virtualization using UTM SE. It provides a modern, high-fidelity terminal experience with a target footprint of under 100MB.

## 🚀 Vision
The fastest and lightest persistent Linux environment for iOS virtualization. PENOS is designed as a mobile-first appliance, offering instant boot and a "Termux-like" workflow.

## ✨ Features
- **Ultra-Fast Boot:** Minimalist OpenRC init system.
- **Modern Dev Experience:** Includes Starship prompt, Neofetch, fzf, bat, and eza.
- **Persistence:** Automatic mounting of secondary virtual disks to `/storage`.
- **Package Management:** `pen` wrapper for simplified `apk` operations.
- **Small Footprint:** Highly compressed SquashFS rootfs.

## 🛠 Architecture
- **Base:** Alpine Linux (ARM64)
- **Init:** OpenRC
- **Shell:** Bash + Starship
- **Persistence:** qcow2 virtual disk support

## 📦 Getting Started
1. Download the latest `penos.iso` from the releases or build it yourself.
2. Import the ISO into UTM SE on iOS.
3. Add a secondary drive (virtio) for persistent storage.
4. Boot and enjoy "Terminal Freedom for iOS."

## 🔨 Building
To build PENOS from source on an Ubuntu/Debian host:
```bash
sudo apt install -y qemu-user-static xorriso squashfs-tools mtools grub-efi-arm64-bin
./scripts/build_iso.sh
```
The ISO will be generated in the `out/` directory.

## 🤝 Contributing
PENOS is **open source**. We welcome contributions via pull requests and issue reports. See `CONTRIBUTING.md` for details.

## 📜 License
MIT License. See `LICENSE` for details.
