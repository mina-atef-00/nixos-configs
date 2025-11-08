# User configuration module
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

  # Get the latest zen-browser from unstable
  zen-browser = pkgs-unstable.zen-browser;

  # Get the latest Vesktop from unstable
  vesktop = pkgs-unstable.vesktop;

  # Get the latest Steam from unstable
  steam = pkgs-unstable.steam;

  # Get the latest OBSidian from unstable
  obsidian = pkgs-unstable.obsidian;

  # Get the latest Thunderbird from unstable
  thunderbird = pkgs-unstable.thunderbird;

  # Since all packages are now system-wide, we don't need to define them in user config
  # The custom neovim should be defined in the system packages module
in
{
  # Import the DMS Shell home module as per official guide
  imports = [
    inputs.dankMaterialShell.homeModules.dankMaterialShell.default
    # Add the niri module if using niri compositor
    # inputs.dankMaterialShell.homeModules.dankMaterialShell.niri
    inputs.mangowc.hmModules.mango
  ];

  # Home Manager configuration
  home = {
    username = "mina";
    homeDirectory = "/home/mina";
    stateVersion = "25.05"; # Match the system version

    # Enable Fish shell
    shell = pkgs.fish;

    # Package management - All packages moved to system level
    packages = with pkgs; [
      # Only keep packages that are specifically needed in user profile
      # Most packages are now available system-wide
    ];

    # File management
    file = {
      ".config/nvim".source = ./config/nvim;
      ".config/mpv".source = ./config/mpv;
      ".config/kitty".source = ./config/kitty;
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
        nrs = "sudo nixos-rebuild switch --flake .#nixos";
        hms = "home-manager switch --flake .#nixos";
      };
    };
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
  };

    # Neovim configuration - using system-installed custom neovim with local config
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
    
    # Configure DMS Shell as per official guide
    dankMaterialShell = {
      enable = true;
      enableSystemd = true; # Systemd service for auto-start
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableClipboard = true; # Clipboard history manager
      enableVPN = false; # VPN management widget
      enableBrightnessControl = true; # Backlight/brightness controls
      enableColorPicker = true; # Color picker tool
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)
      enableSystemSound = true; # System sound effects

      # Default settings that will be used on first launch
      default.settings = {
        theme = "dark";
        dynamicTheming = true;
      };
    };
  

  # Services configuration
  services = {
    # Clipboard manager
    wl-clipboard-hist = {
      enable = true;
      settings = {
        general = {
          max_hist_items = 100;
          max_item_size = 1024000;
        };
      };
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
        "text/html" = "zen-browser.desktop";
        "x-scheme-handler/http" = "zen-browser.desktop";
        "x-scheme-handler/https" = "zen-browser.desktop";
        "x-scheme-handler/about" = "zen-browser.desktop";
        "x-scheme-handler/ftp" = "zen-browser.desktop";
        "x-scheme-handler/chrome" = "zen-browser.desktop";
        "application/x-extension-htm" = "zen-browser.desktop";
        "application/x-extension-html" = "zen-browser.desktop";
        "application/x-extension-shtml" = "zen-browser.desktop";
        "application/xhtml+xml" = "zen-browser.desktop";
        "application/x-extension-xhtml" = "zen-browser.desktop";
        "application/x-extension-xht" = "zen-browser.desktop";
        "audio/*" = "mpv.desktop";
        "video/*" = "mpv.desktop";
      };
    };

    # Desktop portal for Wayland
    desktopEntries = {
      zen-browser = {
        name = "Zen Browser";
        exec = "zen %U";
        type = "Application";
        mimeType = [
          "text/html"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
        categories = [
          "Network"
          "WebBrowser"
        ];
      };
    };
  };

  # Configure MangoWC via the home-manager module
  wayland.windowManager.mango = {
    enable = true;
    settings = ''
      # MangoWC configuration based on your preferences
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
      super+shift, 1 tagn 1
      super+shift, 2 tagn 2
      super+shift, 3 tagn 3
      super+shift, 4 tagn 4
      super+shift, 5 tagn 5
    '';
    autostart_sh = ''
      # Start necessary services for MangoWC
      ${pkgs.xdg-desktop-portal-wlr}/bin/xdg-desktop-portal-wlr &
      ${pkgs.swaync}/bin/swaync &
      ${pkgs.wlsunset}/bin/wlsunset -l 30.0556 -L 31.22 & # Cairo coordinates
      ${pkgs.wl-clip-persist}/bin/wl-clip-persist &
      # Note: DMS will be handled by its own module
    '';
  };


  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim"; # System-installed
    BROWSER = "zen-browser"; # System-installed
    TERMINAL = "kitty"; # System-installed
    READER = "zathura"; # System-installed
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

}
