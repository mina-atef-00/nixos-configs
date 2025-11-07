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

  # Create a custom neovim with LazyVim
  neovim =
    pkgs.neovim.overrideAttrs
      (oldAttrs: {
        nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.cmake ];
      }).override
      {
        viAlias = true;
        vimAlias = true;
        configure = {
          customRC = ''
            " Use system clipboard by default
            set clipboard=unnamedplus
          '';
          packages.myVimPackage = with pkgs.vimPlugins; {
            start = [
              # Core LazyVim plugins
              lazy-nvim
              mason-nvim
              mason-lspconfig-nvim
              nvim-lspconfig
              nvim-treesitter.withAllGrammars
              indent-blankline-nvim
              nvim-cmp
              cmp-nvim-lsp
              cmp-buffer
              cmp-path
              cmp-cmdline
              lualine-nvim
              toggleterm-nvim
              nvim-tree-lua
              nvim-web-devicons
              telescope-nvim
              plenary-nvim
              nvim-colorizer-lua
              which-key-nvim
              gitsigns-nvim
              # Theme
              catppuccin-nvim
            ];
            opt = [ ];
          };
        };
      };
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

    # Package management
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

      # Development tools
      neovim
      nodejs
      nodePackages.npm
      nodePackages.yarn
      python3
      python311Packages.pip
      gcc
      gnumake
      cmake
      gitAndTools.gitFull

      # Media and graphics
      mpv
      ffmpeg
      imagemagick

      # Browsers
      zen-browser

      # Communication
      vesktop

      # Gaming
      steam

      # Productivity
      obsidian
      thunderbird
      libreoffice

      # System tools
      nix-index
      nix-tree
      gitoxide

      # Audio/video
      pavucontrol
      playerctl

      # File management
      file
      unzip
      p7zip

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
        nrs = "nixos-rebuild switch --flake .#nixos";
        hms = "home-manager switch --flake .#nixos";
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

    # Kitty terminal
    kitty = {
      enable = true;
      font.name = "FiraCode Nerd Font";
      font.size = 12.0;
      settings = {
        background_opacity = "0.95";
        tab_bar_edge = "top";
        tab_bar_style = "powerline";
        cursor_shape = "beam";
        remember_window_size = false;
        scrollback_lines = 10000;
        enable_audio_bell = false;
        mouse_hide_wait = 3.0;
        url_color = "#89b4fa";
        wheel_scroll_multiplier = 3.0;
        repaint_delay = 10;
        input_delay = 3;
        sync_to_monitor = true;
      };
      keybindings = {
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+shift+t" = "new_tab";
        "ctrl+shift+w" = "close_tab";
        "ctrl+shift+plus" = "change_font_size +2.0";
        "ctrl+minus" = "change_font_size -2.0";
        "ctrl+shift+tab" = "next_tab";
        "ctrl+tab" = "previous_tab";
        "ctrl+shift+left" = "previous_tab";
        "ctrl+shift+right" = "next_tab";
      };
    };

    # MPV media player
    mpv = {
      enable = true;
      config = {
        # Hardware Decoding
        hwdec = "auto";
        "hwdec-codecs" = "all";
        "vd-lavc-dr" = "auto";
        "vd-lavc-film-grain" = "gpu";

        # Video Output
        vo = "gpu";
        "gpu-api" = "auto";
        "opengl-pbo" = "yes";
        "opengl-sw" = "auto";

        # Caching and Buffering
        cache = "yes";
        "demuxer-max-bytes" = "200MiB";
        "demuxer-max-back-bytes" = "20MiB";
        "demuxer-readahead-secs" = "120";
        "demuxer-cache-wait" = "no";
        "cache-pause" = "yes";
        "cache-pause-wait" = "2.0";
        "cache-pause-initial" = "yes";

        # Audio/Video Sync
        "video-sync" = "audio";
        "video-sync-max-video-change" = "1";
        "video-sync-max-audio-change" = "0.125";
        "video-sync-max-factor" = "5";
        autosync = "30";

        # Performance
        "vd-lavc-threads" = "0";
        ao = "pipewire";
        "ao-pipewire-buffer" = "10";
        "ao-pulse-buffer" = "10";
        "opengl-swapinterval" = "1";
        "opengl-waitvsync" = "no";

        # Video Filters and Scaling
        scale = "lanczos";
        cscale = "lanczos";
        dscale = "bicubic";
        tscale = "oversample";
        "scale-antiring" = "0.8";
        "cscale-antiring" = "0.8";
        "correct-downscaling" = "yes";
        "sigmoid-upscaling" = "yes";

        # Audio
        "audio-buffer" = "0.2";
        "audio-client-name" = "mpv";

        # Video Adjustments
        deband = "yes";
        "deband-grain" = "48";
        denoise = "0";
        sharpen = "0";
        contrast = "0";
        brightness = "0";
        saturation = "0";
        gamma = "0";

        # Subtitles
        "sub-auto" = "exact";
        "sub-scale-by-window" = "yes";
        "sub-scale-with-window" = "yes";
        "sub-ass-force-margins" = "no";
        "sub-use-margins" = "yes";

        # Input
        "input-default-bindings" = "yes";
        "input-vo-keyboard" = "yes";

        # Window
        ontop = "no";
        border = "yes";
        "keep-open" = "yes";
        "keep-open-pause" = "no";
        "autofit-larger" = "75%x75%";
        keepaspect = "yes";
        "keepaspect-window" = "yes";

        # Screenshot
        "screenshot-directory" = "~/Pictures";
        "screenshot-template" = "mpv-shot%n";
        "screenshot-format" = "jpg";
        "screenshot-jpeg-quality" = "90";

        # OSD
        "osd-bar" = "yes";
        "osd-bar-align-y" = "0.5";
        "osd-bar-w" = "75";
        "osd-bar-h" = "3.125";
        "osd-font-size" = "24";
        "osd-color" = "#FFFFFFFF";
        "osd-border-size" = "1.65";
        "osd-shadow-offset" = "0";
        "osd-level" = "1";
      };
      scripts = with pkgs; [
        mpvScripts.autosubsync
        mpvScripts.thumbfast
        mpvScripts.uosc
      ];
    };

    # Neovim configuration
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
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

    # Audio OSD
    swayosd = {
      enable = true;
      settings = {
        show-values = true;
        timeout = 2000;
      };
    };

    # Notification daemon
    mako = {
      enable = true;
      backgroundColor = "#1e1e2e";
      borderColor = "#89b4fa";
      borderSize = 2;
      defaultTimeout = 5000;
      font = "FiraCode Nerd Font 10";
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
      # Start necessary services for MangoWC
      ${pkgs.xdg-desktop-portal-wlr}/bin/xdg-desktop-portal-wlr &
      ${pkgs.swaybg}/bin/swaybg -i /home/mina/Pictures/wallpaper.jpg &
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swaync}/bin/swaync &
      ${pkgs.wlsunset}/bin/wlsunset -l 30.0556 -L 31.22 & # Cairo coordinates
      ${pkgs.wl-clip-persist}/bin/wl-clip-persist &
      # Note: DMS will be handled by its own module
    '';
  };

  # Configure DMS Shell as per official guide
  programs.dankMaterialShell = {
    enable = true;
    enableSystemd = true; # Systemd service for auto-start
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableClipboard = true; # Clipboard history manager
    enableVPN = true; # VPN management widget
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

  # Qt configuration for theming
  qt = {
    enable = true;
    platform = "wayland";
    style = "adwaita-dark";
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "zen-browser";
    TERMINAL = "kitty";
    READER = "zathura";
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
