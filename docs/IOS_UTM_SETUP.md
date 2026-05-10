# UTM SE SETUP FOR PENOS

1. Create a new VM in UTM.
2. Select **Virtualize** (Apple Silicon) or **Emulate** (Older iOS/Older CPUs).
3. Choose **Linux**.
4. Select `penos.iso` as the Boot Image.
5. In the VM settings:
   - **System**: QEMU 7.0+ (ARM64).
   - **Drives**:
     - 1: CD/DVD (pointing to `penos.iso`).
     - 2: New VirtIO Drive (2GB+ recommended for `/storage`).
6. **Network**: Shared Network.
7. **Display**: VirtIO GPU.
8. Boot and enjoy.
