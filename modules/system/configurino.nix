{ config, pkgs, ... }:
# let

# in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };

  };

  boot = {
    initrd = {
      kernelModules = [ ];
      availableKernelModules = [ 
       "vmd"
       "xhci_pci"
       "ahci"
       "nvme"
       "usb_storage"
       "usbhid"
       "sd_mod"
      ];
    };
    kernelModules = [ "v4l2loopback" "uinput" "xpad" "kvm-intel"];
    extraModulePackages = [ ];
    plymouth.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        device = "nodev";
        enable = true;
        efiSupport = true;
      };
    };
  };

  programs.hyprland.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.xserver = {
    xkbOptions = "grp:win_space_toggle";
    xkb.layout = "us,ara";
  };

  console.keyMap = "us";
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    hostName = "nix-asus";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 2222 ]; # SSH on new port
      allowedUDPPorts = [ ]; # No specific UDP ports
      allowPing = false; # Disable ping unless needed for diagnostics
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
      PermitEmptyPasswords = false;
    };
  };
  
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enable avahi
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  time.timeZone = "UTC";
  
  users.users = {
    "mina" = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "video"
        "podman"
      ];
      hashedPassword = "$6$rounds=4096$0nh2sl0D0G0gqEiA$TCFCA36zEVuLGRDrluY02PaILJ31xLTjou.ADxgI8iWoar98sBUn0m4V06erkBU2UXkJYFVIljXNTv2aRTh4m0";
    };

    root.hashedPassword = "$6$rounds=4096$ZndMwux/UG4xJ6G/$mPu2hJDUbskiuagCddmnd3cogdNgpDk1z9LBWaTOeG8he90oWGW0qgqqGiVUSAxyiQaxheCm4sNrDqroguiCQ1";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      # Core utilities
      git
      wget
      curl
      vim
      htop
      bottom
      ripgrep
      fd
      fzf
      bat
      eza
      dust
      jq
      yq
      zip
      unzip
      tree
      file
      nix-index
      nix-tree
      gitoxide

      # Terminal and shell
      kitty
      fish
      starship
      direnv
      eza
      gvfs
      libinput

      # Development tools
      nodejs
      nodePackages.npm
      nodePackages.yarn
      python3
      python311Packages.pip
      gcc
      gnumake
      cmake
      plymouth

      # Media and graphics
      mpv
      ffmpeg
      ffmpegthumbnailer
      imagemagick

      # Browsers
      firefox
      #zen-browser

      # Communication
      vesktop

      # Gaming
      steam
      SDL2
      protontricks
      mangohud
      goverlay
      gamemode

      libusb1
      udev

      # Additional libraries for better compatibility
      xorg.xorgserver
      
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXrender
      xorg.libXext
      xorg.setxkbmap

      # Input diagnostic tools
      xorg.xev
      evtest
      brightnessctl
      mesa-demos
      duf
      dysk
      file-roller
      eog
      inxi
      killall
      libnotify
      lshw
      ncdu
      nixfmt-rfc-style
      nixd
      nil
      sox
      usbutils
      v4l-utils
      gum
      gtk3
      gtk4
      pciutils
      dconf
      # Fix for Xwayland symbol errors
      libkrb5
      keyutils

      # Productivity
      obsidian
      thunderbird
      libreoffice

      # Audio/video
      pavucontrol
      playerctl

      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      xfce.tumbler

      # File management
      unzip
      p7zip

      # Security
      gnupg
      age
      openssl

      # Wayland utilities
      wayland-protocols
      wl-clipboard
      # Additional Wayland support for NVIDIA
      xwayland
      wlr-randr
      grim
      slurp
      swappy

      # GTK themes
      colloid-gtk-theme

      # Icon themes
      papirus-icon-theme

      # Cursor themes
      numix-cursor-theme

      # Add any additional system-wide packages here
    ]
    ++ [
      # Add packages that are not in pkgs namespace
      neovim # Custom neovim defined in let block
    ]
    ++ [
      # Adobe Source Han Sans/Serif (CJK fonts)
      source-han-sans
      source-han-serif

      # Liberation fonts
      liberation_ttf

      # Noto fonts (Google's font family)
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji-blob-bin

      # Ubuntu fonts
      ubuntu-sans

      # GNU FreeFont
      freefont_ttf

      # WenQuanYi fonts (Chinese)
      wqy_zenhei
      wqy_microhei

      # Additional useful fonts
      fira-code
      fira-code-symbols
      font-awesome

      roboto
      roboto-slab

      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.hack

      inter
    ];
 
  system.stateVersion = "25.11";
}