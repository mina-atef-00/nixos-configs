# Migration Guide from Arch Linux to NixOS

This guide will help you transition from your current Arch Linux setup to the new NixOS configuration with MangoWC and Dank Material Shell.

## Pre-Migration Checklist

- [ ] Backup important data
- [ ] Document current installed packages
- [ ] Note any custom configurations you want to preserve
- [ ] Verify hardware compatibility with NixOS

## Package Mapping

### Current Arch Packages to NixOS Equivalents

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| kitty | pkgs.kitty | Terminal emulator |
| neovim | pkgs.neovim | Already configured with LazyVim |
| mpv | pkgs.mpv | Already configured with custom settings |
| zen-browser | pkgs-unstable.zen-browser | Browser from unstable channel |
| vesktop | pkgs-unstable.vesktop | Discord client |
| steam | pkgs-unstable.steam | Gaming platform |
| obsidian | pkgs-unstable.obsidian | Knowledge base |
| thunderbird | pkgs-unstable.thunderbird | Email client |
| mangowc | inputs.mangowc.packages.${pkgs.system}.mangowc | Window manager |
| dms-shell | pkgs-unstable.dms-shell | Desktop shell |

## Hardware Configuration

Your hardware (Intel i5-12400F, NVIDIA RTX 2060) is already configured in the hardware-configuration.nix file. The configuration includes:

- NVIDIA proprietary drivers for gaming performance
- Proper CPU microcode support
- All necessary kernel modules

## Desktop Environment Transition

### From KDE to MangoWC + DMS

The configuration transitions from KDE to a lightweight Wayland setup with:
- MangoWC as the window manager (similar to dwl, but with more features)
- Dank Material Shell for desktop components
- Wayland-optimized application stack

### Key Differences

1. **Window Management**:
   - KDE: Traditional desktop with panels
   - MangoWC: Tiling/composite window management with tags

2. **Configuration**:
   - KDE: System settings GUI and configuration files
   - MangoWC: Configuration through home.nix

3. **Theming**:
   - KDE: Qt/KDE theming system
   - DMS: Material design with automatic wallpaper-based theming

## Migration Steps

### 1. Install NixOS
If not already installed, follow the official NixOS installation guide using the provided configuration files.

### 2. User Setup
The configuration creates a user named "mina" with sudo privileges. If your username is different, update both configuration.nix and home.nix.

### 3. Import Personal Data
Copy your personal data from the Arch installation:
```bash
# Mount your old Arch partition
sudo mkdir /mnt/arch
sudo mount /dev/sdXY /mnt/arch

# Copy personal data (adjust paths as needed)
cp -r /mnt/arch/home/mina/Documents ~/Documents
cp -r /mnt/arch/home/mina/Pictures ~/Pictures
# etc.
```

### 4. Restore Configurations
Your existing Neovim, MPV, and Kitty configurations have been preserved in the config/ directory and will be automatically deployed by Home Manager.

### 5. Install Additional Packages
If you need packages not included in the base configuration, add them to the packages list in home.nix:
```nix
home.packages = with pkgs; [
  # Add your packages here
];
```

## Post-Migration Verification

### System Services
- [ ] Network connectivity working
- [ ] Audio functioning
- [ ] Graphics drivers loaded properly
- [ ] Touchpad/mouse working

### Applications
- [ ] Terminal (kitty) launching
- [ ] Browser (zen-browser) working
- [ ] Text editor (neovim) functioning
- [ ] Media player (mpv) working

### Window Manager
- [ ] MangoWC starting properly
- [ ] DMS shell components visible
- [ ] Wayland session working

## Key Keyboard Shortcuts

MangoWC uses Super (Windows key) as the main modifier:

- `Super + Return`: Open terminal
- `Super + Space`: Open application launcher
- `Super + Q`: Close window
- `Super + Arrow Keys`: Focus windows
- `Super + Shift + Arrow Keys`: Move windows
- `Super + F`: Toggle fullscreen
- `Super + M`: Quit MangoWC
- `Super + Number`: Switch to tag
- `Super + Shift + Number`: Move window to tag

## Troubleshooting Common Issues

### Graphics/Display Problems
1. Check that NVIDIA drivers are properly loaded:
   ```bash
   nvidia-smi
   lsmod | grep nvidia
   ```

2. If issues persist, try using nouveau driver temporarily:
   ```nix
   hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.nouveau;
   ```

### Audio Issues
1. Check PipeWire status:
   ```bash
   systemctl --user status pipewire
   pactl info
   ```

2. Restart audio services:
   ```bash
   systemctl --user restart pipewire
   systemctl --user restart wireplumber
   ```

### Application Not Launching
1. Check if the application is properly installed:
   ```bash
   which application-name
   ```

2. Install missing packages via Nix:
   ```bash
   nix run nixpkgs#package-name
   ```

### Wayland Compatibility Issues
Some applications may not work optimally under Wayland. For these applications:
- Use XWayland: `WAYLAND_DISPLAY="" application-name`
- Check for native Wayland versions

## Customization Tips

### Theming
Dank Material Shell supports automatic wallpaper-based theming. To update your wallpaper:
```bash
dms ipc call wallpaper set /path/to/image.jpg
```

### Adding New Applications
To add applications to your system, modify the packages list in home.nix:
```nix
home.packages = with pkgs; [
  # Your existing packages...
  new-package
];
```

### Keybinding Changes
Modify keybindings in the wayland.windowManager.mangowc.settings section of home.nix.

## Performance Optimization

The configuration includes several performance optimizations:
- ZRAM swap for better memory management
- Optimized kernel parameters
- Wayland for better graphics performance
- Latest NVIDIA drivers for gaming

## Backup and Recovery

NixOS configurations are stored in plain text files. To backup:
```bash
# Backup the entire configuration
tar -czf nixos-config-backup.tar.gz /etc/nixos/
```

To restore:
```bash
# Extract and rebuild
sudo tar -xzf nixos-config-backup.tar.gz -C /
sudo nixos-rebuild switch --flake /etc/nixos#nixos
```

## Getting Help

- NixOS Manual: https://nixos.org/manual
- NixOS Discourse: https://discourse.nixos.org
- MangoWC GitHub: https://github.com/DreamMaoMao/mangowc
- DMS Documentation: https://danklinux.com/docs