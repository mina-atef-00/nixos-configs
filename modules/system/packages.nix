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
in
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    htop
    btop
    bottom
    thunderbird
    libreoffice
    file
    tree
    zip
    unzip
    p7zip
    jq
    yq
    ripgrep
    fd
    fzf
    bat
    nix-index
    nix-tree
    gitoxide
    # Add any additional system-wide packages here
  ];

  # Set environment variables
  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "zen-browser";
    TERMINAL = "kitty";
  };
}
