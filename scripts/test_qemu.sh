#!/bin/bash
echo "Booting PENOS in QEMU (Emulation)..."
qemu-system-aarch64 \
    -M virt \
    -cpu cortex-a57 \
    -smp 2 \
    -m 1024 \
    -bios /usr/share/ovmf/OVMF.fd \
    -cdrom out/penos.iso \
    -nographic
