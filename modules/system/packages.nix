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

  # Get the latest Firefox from unstable (as fallback)
  firefox = pkgs-unstable.firefox;

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
 environment.systemPackages = with pkgs; [
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

    # Add any additional system-wide packages here
 ];

  # Set environment variables
  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "zen-browser";
    TERMINAL = "kitty";
  };
}
