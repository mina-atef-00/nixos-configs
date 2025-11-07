# Lightweight system packages configuration module for VM
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
  # List lightweight packages installed in system profile for VM
  environment.systemPackages = with pkgs; [
    git
    wget
    vim
    htop
    btop
    bottom
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
    file
    nix-index
    nix-tree
    gitoxide
    # Lightweight alternatives
    nano
    micro
    elinks # Text-based browser
    w3m # Text-based browser
    rsync
    openssh
    dnsutils # For nslookup, dig, etc.
    pciutils # For lspci
    usbutils # For lsusb
    lm_sensors # For hardware monitoring
    smartmontools # For disk health
    powertop # For power usage
    strace
    lsof
    netcat
    socat
    screen
    tmux
    gparted
    ntfs3g
    exfat-utils
    dosfstools
    cryptsetup
    lvm2
  ];

  # Set environment variables for VM
  environment.variables = {
    EDITOR = "micro";
    BROWSER = "elinks";
    TERMINAL = "foot";
  };
}
