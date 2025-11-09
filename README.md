# NixOS Configuration

This repository contains a modular NixOS configuration with MangoWC and Dank Material Shell, designed with separation of concerns in mind.

## Structure

The configuration is organized into several modules:

- `configuration.nix`: Main system configuration that imports all other modules
- `flake.nix`: Flake definition with all necessary inputs
- `modules/hardware/default.nix`: Hardware-specific configuration
- `modules/system/base.nix`: Base system settings
- `modules/system/packages.nix`: System-wide package definitions
- `modules/desktop/mangowc.nix`: Desktop environment configuration (MangoWC)
- `modules/user/default.nix`: User-specific configuration managed with Home Manager

## Features

- NixOS 25.05 stable with unstable channel for applications
- MangoWC window manager with tiling/compositing features
- Dank Material Shell for a modern desktop experience
- Optimized for Intel i5-12400F + NVIDIA RTX 2060
- Neovim with LazyVim and Catppuccin theme
- MPV with custom hardware decoding and performance settings
- Kitty terminal with Catppuccin themes and custom keybindings
- Fish shell with starship prompt
- ZRAM for better memory management
- Gaming-ready setup with latest NVIDIA drivers
- Wayland-focused with proper audio/video support via PipeWire
- Aligned with official MangoWC and DMS Shell installation guides
- Custom keybindings: SUPER+Return for Kitty terminal, SUPER+w for Zen Browser


## Installation

1. Clone this repository to `/etc/nixos/` (or your preferred location)
2. Update the UUIDs in `modules/hardware/default.nix` to match your system
3. Run `sudo nixos-rebuild switch --flake .#nixos` to apply the configuration

## Updating

To update the system with the latest changes from this configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

## Customization

To customize the configuration:

- Hardware settings: Modify `modules/hardware/default.nix`
- System settings: Modify `modules/system/base.nix`
- Desktop environment: Modify `modules/desktop/mangowc.nix`
- User applications and settings: Modify `modules/user/default.nix`

## Official Guides Alignment

This configuration follows the official installation guides for both MangoWC and Dank Material Shell:

### MangoWC
- Uses the official NixOS and home-manager modules from the MangoWC repository
- Properly imports `inputs.mangowc.nixosModules.mango` and `inputs.mangowc.hmModules.mango`
- Enables MangoWC at both system and user levels

### Dank Material Shell
- Uses the official DMS Shell home module: `inputs.dankMaterialShell.homeModules.dankMaterialShell.default`
- Implements all recommended features including systemd service, system monitoring, clipboard management, etc.
- Properly configures default settings and session state