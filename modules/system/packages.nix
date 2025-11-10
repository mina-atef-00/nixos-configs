# System packages configuration module
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

  

  # Get the latest Vesktop from unstable with fallback
 vesktop = if pkgs-unstable ? vesktop then pkgs-unstable.vesktop else pkgs.discord;

  # Get the latest Steam from unstable with fallback
  steam = if pkgs-unstable ? steam then pkgs-unstable.steam else pkgs.steam;

  # Get the latest OBSidian from unstable with fallback
  obsidian = if pkgs-unstable ? obsidian then pkgs-unstable.obsidian else pkgs.obsidian;

  # Get the latest Thunderbird from unstable with fallback
  thunderbird = if pkgs-unstable ? thunderbird then pkgs-unstable.thunderbird else pkgs.thunderbird;

  # Get Zen Browser from the dedicated flake
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;

  # Get MangoWC from the input (this was causing the error, so we'll remove the reference)
  # mangowc = inputs.mangowc.packages.${pkgs.system}.mangowc;

  # Create a custom neovim with LazyVim (moved from user config)
  neovim = pkgs.neovim.override {
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
          pkgs.vimPlugins.lazy-nvim
          pkgs.vimPlugins.mason-nvim
          pkgs.vimPlugins.mason-lspconfig-nvim
          pkgs.vimPlugins.nvim-lspconfig
          pkgs.vimPlugins.nvim-treesitter.withAllGrammars
          pkgs.vimPlugins.indent-blankline-nvim
          pkgs.vimPlugins.nvim-cmp
          pkgs.vimPlugins.cmp-nvim-lsp
          pkgs.vimPlugins.cmp-buffer
          pkgs.vimPlugins.cmp-path
          pkgs.vimPlugins.cmp-cmdline
          pkgs.vimPlugins.lualine-nvim
          pkgs.vimPlugins.toggleterm-nvim
          pkgs.vimPlugins.nvim-tree-lua
          pkgs.vimPlugins.nvim-web-devicons
          pkgs.vimPlugins.telescope-nvim
          pkgs.vimPlugins.plenary-nvim
          pkgs.vimPlugins.nvim-colorizer-lua
          pkgs.vimPlugins.which-key-nvim
          pkgs.vimPlugins.gitsigns-nvim
          # Theme
          pkgs.vimPlugins.catppuccin-nvim
        ];
        opt = [ ];
      };
    };
  };
in
{
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
       foot
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
      gitAndTools.gitFull
      plymouth

      # Media and graphics
      mpv
      ffmpeg
      ffmpegthumbnailer
      imagemagick

      # Browsers
      zen-browser

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
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXrender
      xorg.libXext

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
       xorg.xorgserver
       xwayland
      wlr-randr
      grim
      slurp
      swappy

      # GTK themes
      colloid-gtk-theme

      # KDE themes
      colloid-kde

      # Icon themes
      papirus-icon-theme

      # Cursor themes
      numix-cursor-theme

      # Add any additional system-wide packages here
    ]
    ++ [
      # Add packages that are not in pkgs namespace
      neovim # Custom neovim defined in let block
    ];

  # Set environment variables
  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "zen";
    TERMINAL = "kitty";
  };

  # Fonts configuration
  fonts.packages = with pkgs; [
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
}
