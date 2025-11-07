# Lightweight user configuration module for VM
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  # Use unstable packages for certain applications
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };
in
{
  # Home Manager configuration
  home = {
    username = "vmuser";
    homeDirectory = "/home/vmuser";
    stateVersion = "25.05"; # Match the system version

    # Enable Fish shell
    shell = pkgs.fish;

    # Minimal package management for VM
    packages = with pkgs; [
      # Core utilities
      git
      wget
      curl
      ripgrep
      fd
      fzf
      bat
      jq
      yq
      zip
      unzip
      tree
      htop
      btop
      bottom

      # Terminal and shell
      fish
      starship
      direnv

      # Text editor
      micro
      neovim

      # Network tools
      nmap
      whois
      dnsutils

      # System tools
      nix-index
      nix-tree
      gitoxide

      # Audio/video
      pavucontrol
      playerctl

      # Security
      gnupg
      age
      openssl

      # Wayland utilities
      wayland-protocols
      wl-clipboard
      wlr-randr
      grim
      slurp
      swappy
    ];

    # Minimal file management
    file = {
      # Only include essential configs
    };
  };

  # Programs configuration
  programs = {
    home-manager.enable = true;

    # Fish shell configuration
    fish = {
      enable = true;
      shellAbbrs = {
        ll = "ls -la";
        ".." = "cd ..";
        "..." = "cd ../..";
        nrs = "sudo nixos-rebuild switch --flake .#vm-nixos";
        hms = "home-manager switch --flake .#vm-nixos";
      };
      interactiveShellInit = ''
        set fish_greeting
        starship init fish | source
      '';
    };

    # Starship prompt
    starship = {
      enable = true;
      settings = {
        add_newline = true;
        character = {
          success_symbol = "[→](bold green)";
          error_symbol = "[→](bold red)";
        };
        directory = {
          truncation_length = 3;
          truncation_symbol = "…/";
        };
      };
    };

    # Direnv integration
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };

    # Lightweight terminal
    foot = {
      enable = true;
      settings = {
        main = {
          font = "monospace:size=10";
          pad = "4x4";
          dpi-aware = "no";
        };
      };
    };
  };

  # Services configuration
  services = {
    # Clipboard manager
    wl-clipboard-hist = {
      enable = true;
      settings = {
        general = {
          max_hist_items = 50; # Reduce for VM
          max_item_size = 512000; # Reduce for VM
        };
      };
    };

    # Audio OSD
    swayosd = {
      enable = true;
      settings = {
        show-values = true;
        timeout = 2000;
      };
    };

    # Lightweight notification daemon
    mako = {
      enable = true;
      backgroundColor = "#1e1e2e";
      borderColor = "#89b4fa";
      borderSize = 2;
      defaultTimeout = 5000;
      font = "monospace 10";
      padding = "10,10,10,10";
      margin = "10,10,10,10";
      width = 500;
      height = 100;
    };

    # Network tray
    network-manager-applet.enable = true;

    # GPG agent
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };

  # XDG configuration
  xdg = {
    enable = true;

    # Mime types
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "micro.desktop";
        "text/html" = "elinks.desktop";
        "x-scheme-handler/http" = "elinks.desktop";
        "x-scheme-handler/https" = "elinks.desktop";
      };
    };
  };

  # Configure MangoWC via the home-manager module
  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      # MangoWC configuration for VM
      # Use super as the main modifier
      super, Return exec foot
      super, space exec fuzzel --no-fuzzy
      super, q kill-client
      super, left focus left
      super, right focus right
      super, up focus up
      super, down focus down
      super+shift, left move left
      super+shift, right move right
      super+shift, up move up
      super+shift, down move down
      super, f fullscreen
      super, m quit
      super, 1 tag 1
      super, 2 tag 2
      super, 3 tag 3
      super, 4 tag 4
      super, 5 tag 5
      super, 6 tag 6
      super, 7 tag 7
      super, 8 tag 8
      super, 9 tag 9
      super+shift, 1 tagn 1
      super+shift, 2 tagn 2
      super+shift, 3 tagn 3
      super+shift, 4 tagn 4
      super+shift, 5 tagn 5
      super+shift, 6 tagn 6
      super+shift, 7 tagn 7
      super+shift, 8 tagn 8
      super+shift, 9 tagn 9
    '';
    autostart_sh = ''
      # Start necessary services for MangoWC in VM
      ${pkgs.xdg-desktop-portal-wlr}/bin/xdg-desktop-portal-wlr &
      ${pkgs.swaybg}/bin/swaybg -i /home/vmuser/Pictures/wallpaper.jpg &
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swaync}/bin/swaync &
      ${pkgs.wl-clip-persist}/bin/wl-clip-persist &
    '';
  };

  # Qt configuration for theming
  qt = {
    enable = true;
    platform = "wayland";
    style = "adwaita-dark";
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "micro";
    BROWSER = "elinks";
    TERMINAL = "foot";
    XDG_CURRENT_DESKTOP = "mangowc";
    XDG_SESSION_TYPE = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Enable home-manager built-in modules
  home.stateVersion = "25.05";
}
