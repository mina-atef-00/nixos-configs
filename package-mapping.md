# Package Mapping: Arch Linux to NixOS

This document maps your previously installed Arch Linux packages to their NixOS equivalents in this configuration.

## Essential System Packages

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| linux | NixOS kernel | Automatically managed by NixOS |
| linux-firmware | NixOS firmware | Automatically managed by NixOS |
| nvidia | config.boot.kernelPackages.nvidiaPackages.latest | Latest NVIDIA drivers |
| nvidia-utils | config.boot.kernelPackages.nvidiaPackages.latest | NVIDIA utilities |
| xorg-server | Not needed | Wayland native with MangoWC |
| xorg-xwayland | pkgs.xorg.xwayland | For X11 app compatibility |

## Development Tools

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| neovim | pkgs.neovim | With LazyVim configuration |
| nodejs | pkgs.nodejs | JavaScript runtime |
| npm | pkgs.nodePackages.npm | Node package manager |
| yarn | pkgs.nodePackages.yarn | Node package manager alternative |
| python | pkgs.python3 | Python 3 runtime |
| python-pip | pkgs.python311Packages.pip | Python package installer |
| gcc | pkgs.gcc | GNU Compiler Collection |
| cmake | pkgs.cmake | Build system generator |
| git | pkgs.git | Version control system |
| base-devel | pkgs.gcc + pkgs.gnumake + pkgs.cmake | Development tools |

## Terminal & Shell

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| kitty | pkgs.kitty | Terminal emulator |
| fish | pkgs.fish | Shell |
| starship | pkgs.starship | Shell prompt |
| direnv | pkgs.direnv | Environment switcher |
| fzf | pkgs.fzf | Fuzzy finder |
| ripgrep | pkgs.ripgrep | Search tool |
| fd | pkgs.fd | File finder |
| bat | pkgs.bat | Cat replacement |
| htop | pkgs.htop | System monitor |
| btop | pkgs.btop | System monitor |
| bottom | pkgs.bottom | System monitor |

## Media & Graphics

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| mpv | pkgs.mpv | Media player |
| ffmpeg | pkgs.ffmpeg | Media processing |
| imagemagick | pkgs.imagemagick | Image processing |
| gimp | pkgs.gimp | Image editor |
| inkscape | pkgs.inkscape | Vector graphics editor |

## Internet & Communication

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| zen-browser-bin | pkgs-unstable.zen-browser | Web browser |
| firefox | pkgs-unstable.firefox | Web browser (fallback) |
| vesktop | pkgs-unstable.vesktop | Discord client |
| thunderbird | pkgs-unstable.thunderbird | Email client |

## Gaming

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| steam | pkgs-unstable.steam | Gaming platform |
| gamemode | pkgs.gamemode | Performance optimization |

## Productivity

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| obsidian | pkgs-unstable.obsidian | Knowledge base |
| libreoffice | pkgs.libreoffice | Office suite |

## System Tools

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| nix-index | pkgs.nix-index | Nix package search |
| nix-tree | pkgs.nix-tree | Nix package dependency viewer |
| git-delta | pkgs.gitoxide | Git tools |

## Audio/Video Services

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| pipewire | services.pipewire | Audio server |
| pipewire-alsa | services.pipewire | ALSA compatibility |
| pipewire-pulse | services.pipewire | PulseAudio compatibility |
| pavucontrol | pkgs.pavucontrol | Audio control |
| playerctl | pkgs.playerctl | Media player control |

## Wayland Utilities

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| wayland | pkgs.wayland | Wayland compositor library |
| wayland-protocols | pkgs.wayland-protocols | Wayland protocols |
| wl-clipboard | pkgs.wl-clipboard | Clipboard utilities |
| wlr-randr | pkgs.wlr-randr | Display configuration |
| grim | pkgs.grim | Screenshot tool |
| slurp | pkgs.slurp | Screenshot region selector |
| swappy | pkgs.swappy | Screenshot editor |

## Desktop Shell Components

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| mangowc | inputs.mangowc.packages.${pkgs.system}.mangowc | Window manager |
| dms-shell | pkgs-unstable.dms-shell | Desktop shell |
| xdg-desktop-portal | pkgs.xdg-desktop-portal | Desktop integration |
| xdg-desktop-portal-wlr | pkgs.xdg-desktop-portal-wlr | Wayland portal |
| swaybg | pkgs.swaybg | Background setter |
| wl-clip-persist | pkgs.wl-clip-persist | Persistent clipboard |
| cliphist | pkgs.cliphist | Clipboard history |
| wlsunset | pkgs.wlsunset | Night light |
| xfce-polkit | pkgs.xfce.polkit | Authorization framework |
| swaync | pkgs.swaync | Notification center |
| pamixer | pkgs.pamixer | Audio control |
| wlr-dpms | pkgs.wlr-dpms | Display power management |
| brightnessctl | pkgs.brightnessctl | Brightness control |
| swayosd | pkgs.swayosd | On-screen display |
| satty | pkgs.satty | Screenshot tool |
| wlogout | pkgs.wlogout | Logout menu |
| sox | pkgs.sox | Audio processing |
| matugen | pkgs.matugen | Material color generator |

## File Management

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| file | pkgs.file | File type detection |
| unzip | pkgs.unzip | Archive extraction |
| zip | pkgs.zip | Archive creation |
| p7zip | pkgs.p7zip | Archive tool |

## Security

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| gnupg | pkgs.gnupg | Encryption tools |
| age | pkgs.age | Encryption tool |
| openssl | pkgs.openssl | SSL/TLS toolkit |

## Network & Services

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| networkmanager | services.networking.networkmanager | Network management |
| openssh | services.openssh | SSH server |
| avahi | services.avahi | Service discovery |
| docker | virtualisation.docker | Container runtime |
| tailscale | services.tailscale | VPN service |

## Bluetooth

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| bluez | hardware.bluetooth | Bluetooth support |
| blueman | services.blueman | Bluetooth manager |

## Printing

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| cups | services.printing | Printing system |
| ghostscript | services.printing | Printing system |
| gsfonts | services.printing | Printing fonts |

## Hardware Support

| Arch Package | NixOS Package | Notes |
|--------------|---------------|-------|
| ntfs-3g | services.udisks2 | NTFS support |
| tlp | powerManagement.enable | Power management (built-in) |

## Package Installation Notes

1. **Stable vs Unstable**: Core system packages use NixOS 25.05 stable, while applications like browsers, games, and communication tools use nixos-unstable for latest versions.

2. **Custom Configurations**: Your existing configurations for neovim, mpv, and kitty are preserved and integrated via Home Manager.

3. **Service Management**: Many services are managed declaratively in configuration.nix rather than installed packages.

4. **Automatic Dependencies**: Nix automatically handles dependencies, so you don't need to install all the individual components that Arch requires.

5. **Version Pinning**: You can pin specific versions of packages if needed, but the default configuration uses the latest stable/unstable versions as appropriate.

## Adding New Packages

To add new packages to your system:

1. For system-wide packages, add to `environment.systemPackages` in configuration.nix
2. For user-specific packages, add to `home.packages` in home.nix
3. For packages from unstable, use `pkgs-unstable.package-name` in home.nix

Example:
```nix
# In home.nix
home.packages = with pkgs; [
  # existing packages...
  new-package-name
];
```

```nix
# In home.nix to use unstable package
home.packages = with pkgs; [
  # existing packages...
] ++ [ pkgs-unstable.unstable-package-name ];