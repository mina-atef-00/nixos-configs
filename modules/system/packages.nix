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

  # Get Zen Browser from the dedicated flake with fallback
  zen-browser = (inputs.zen-browser.packages.${pkgs.system}.zen-browser or pkgs.firefox);

  # Get the latest Vesktop from unstable with fallback
  vesktop = if pkgs-unstable ? vesktop then pkgs-unstable.vesktop else pkgs.discord;

  # Get the latest Steam from unstable with fallback
  steam = if pkgs-unstable ? steam then pkgs-unstable.steam else pkgs.steam;

  # Get the latest OBSidian from unstable with fallback
  obsidian = if pkgs-unstable ? obsidian then pkgs-unstable.obsidian else pkgs.obsidian;

  # Get the latest Thunderbird from unstable with fallback
  thunderbird = if pkgs-unstable ? thunderbird then pkgs-unstable.thunderbird else pkgs.thunderbird;

  # Get MangoWC from the input
 mangowc = inputs.mangowc.packages.${pkgs.system}.mangowc;

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
