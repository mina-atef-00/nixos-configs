# NixOS VM Configuration

This repository contains a lightweight NixOS configuration designed specifically for virtual machines (QEMU/KVM, VirtualBox, VMware), optimized for testing and evaluation purposes.

## Structure

The VM configuration is organized into several modules:

- `configuration-vm.nix`: Main VM system configuration that imports all other VM modules
- `flake.nix`: Flake definition with all necessary inputs (includes both main and VM configurations)
- `modules/hardware/vm-hardware.nix`: VM-specific hardware configuration
- `modules/system/vm-base.nix`: Lightweight base system settings for VMs
- `modules/system/vm-packages.nix`: System-wide package definitions for VMs
- `modules/desktop/vm-mangowc.nix`: Lightweight desktop environment configuration (MangoWC)
- `modules/user/vm-user.nix`: User-specific configuration managed with Home Manager

## Features

- NixOS 25.05 stable with minimal packages for VM testing
- Optimized for QEMU/KVM, VirtualBox, and VMware environments
- MangoWC window manager with tiling/compositing features
- Lightweight package selection (no heavy browsers or applications)
- VM guest agent support (QEMU, VirtualBox, VMware)
- Optimized for performance in virtualized environments
- Arabic keyboard layout support with Super+Space switching
- Wayland-focused with proper audio/video support via PipeWire

## Installation for VM

1. Create a new VM with at least 4GB RAM and 20GB disk space
2. Install NixOS using the minimal ISO
3. Clone this repository to your VM
4. Build and switch to the VM configuration: `sudo nixos-rebuild switch --flake .#vm-nixos`
5. Reboot to apply all changes

## Usage

To update the VM system with the latest changes from this configuration:

```bash
sudo nixos-rebuild switch --flake .#vm-nixos
```

## Customization

To customize the VM configuration:

- VM hardware settings: Modify `modules/hardware/vm-hardware.nix`
- System settings: Modify `modules/system/vm-base.nix`
- VM desktop environment: Modify `modules/desktop/vm-mangowc.nix`
- VM user applications and settings: Modify `modules/user/vm-user.nix`

## Differences from Main Configuration

- Lighter package selection (no heavy browsers like Zen Browser, no gaming applications)
- VM-optimized drivers and settings
- Reduced memory usage optimizations
- No unnecessary services enabled
- Minimal user configuration for testing purposes