# VM Installation Guide

This guide explains how to install the NixOS VM configuration on a virtual machine.

## Prerequisites

- A virtual machine running with at least 4GB RAM and 20GB disk space
- NixOS installation ISO loaded in the VM
- Basic familiarity with NixOS installation process

## Installation Methods

### Method 1: Direct Flake Installation

After installing NixOS base system on your VM, you can directly install the VM configuration:

```bash
# Clone the repository
git clone https://github.com/mina-atef-00/nixos-configs.git
cd nixos-configs

# Switch to the VM configuration
sudo nixos-rebuild switch --flake .#vm-nixos
```

### Method 2: Using Imperative Commands

If you prefer to set up the configuration manually:

```bash
# Add the flake to your system configuration
sudo nixos-rebuild switch --flake 'github:mina-atef-00/nixos-configs#vm-nixos'
```

### Method 3: Manual Setup

Alternatively, you can copy the VM configuration files to `/etc/nixos/` and use the traditional approach:

```bash
# Clone the repository
git clone https://github.com/mina-atef-00/nixos-configs.git

# Copy VM-specific configuration files
sudo cp nixos-configs/configuration-vm.nix /etc/nixos/configuration.nix
sudo cp -r nixos-configs/modules /etc/nixos/

# Rebuild the system
sudo nixos-rebuild switch
```

## Post-Installation

After installation, you should:

1. Set a password for the `vmuser` account: `passwd vmuser`
2. Reboot the system to ensure all services start correctly
3. Log in with the `vmuser` account
4. Verify that MangoWC and DMS Shell are running correctly

## Troubleshooting

### VM-Specific Issues

- If graphics appear corrupted, try installing with different VM graphics settings
- For slow performance, ensure VM has adequate resources allocated
- For network issues, verify that the network interface names match those in the configuration

### Configuration Issues

- If services fail to start, check logs with `journalctl -u <service-name>`
- For display manager issues, ensure MangoWC is properly configured
- For audio issues, check that PipeWire is running: `systemctl --user status pipewire`

## Customization

To customize the VM configuration:

- VM hardware settings: Modify `modules/hardware/vm-hardware.nix`
- System settings: Modify `modules/system/vm-base.nix`
- VM desktop environment: Modify `modules/desktop/vm-mangowc.nix`
- VM user applications and settings: Modify `modules/user/vm-user.nix`