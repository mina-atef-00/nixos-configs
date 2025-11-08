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

  # Get the latest zen-browser from unstable with fallback
  zen-browser = if pkgs-unstable ? zen-browser then pkgs-unstable.zen-browser else pkgs.firefox;

  # Get the latest Vesktop from unstable with fallback
  vesktop = if pkgs-unstable ? vesktop then pkgs-unstable.vesktop else pkgs.discord;

  # Get the latest Steam from unstable with fallback
  steam = if pkgs-unstable ? steam then pkgs-unstable.steam else pkgs.steam;

  # Get the latest OBSidian from unstable with fallback
  obsidian = if pkgs-unstable ? obsidian then pkgs-unstable.obsidian else pkgs.obsidian;

  # Get the latest Thunderbird from unstable with fallback
  thunderbird = if pkgs-unstable ? thunderbird then pkgs-unstable.thunderbird else pkgs.thunderbird;

  # Get the latest Firefox from unstable (as fallback)
  firefox = if pkgs-unstable ? firefox then pkgs-unstable.firefox else pkgs.firefox;

  # Get MangoWC from the input
  mangowc = inputs.mangowc.packages.${pkgs.system}.mangowc;

  # Create a custom neovim with LazyVim (moved from user config)
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
      btop
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
      fish
      starship
      direnv

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

      # Audio/video
      pavucontrol
      playerctl

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
      wlr-randr
      grim
      slurp
      swappy

      # Qt themes
      qt6.qtstyleplugin-kvantum
      libsForQt5.qtstyleplugin-kvantum

      # GTK themes
      colloid-gtk-theme

      # KDE themes
      colloid-kde

      # Add any additional system-wide packages here
    ]
    ++ [
      # Add packages that are not in pkgs namespace
      neovim # Custom neovim defined in let block
    ];

  # Set environment variables
  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "zen-browser";
    TERMINAL = "kitty";
  };

  # Fonts configuration
  fonts.packages = with pkgs; [
    # Adobe Source Han Sans/Serif (CJK fonts)
    source-han-sans
    source-han-serif

    # Liberation fonts
    liberation_ttf
    liberation_mono

    # Noto fonts (Google's font family)
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

    # Ubuntu fonts
    ubuntu_font_family

    # GNU FreeFont
    freefont_ttf

    # Ghostscript fonts
    gsfonts

    # WenQuanYi fonts (Chinese)
    wqy_zenhei
    wqy_microhei

    # Additional useful fonts
    fira-code
    fira-code-symbols
    font-awesome
    awesome-terminal-fonts
  ];
}
