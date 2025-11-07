# Lightweight base system configuration module for VM
{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # Configure console keymap
  console.keyMap = "us";

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable networking
  networking = {
    networkmanager.enable = true;
    # Enable wireless support
    wireless.enable = false; # No wireless in VM
    # The global useDHCP flag is deprecated, therefore explicitly set to false.
    useDHCP = false;
    # Configure network interfaces manually if not using DHCP.
    interfaces.enp3s0.useDHCP = true; # Adjust interface name as needed
    interfaces.wlo1.useDHCP = true; # Adjust interface name as needed
  };

  # Set up the basic firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSH
    allowedUDPPorts = [ ]; # No specific UDP ports
    # Enable rate limiting for SSH
    extraCommands = ''
      # Rate limit SSH attempts
      ip46tables -A nixos-fw -p tcp --dport 22 -m state --state NEW -m recent --name ssh --set
      ip46tables -A nixos-fw -p tcp --dport 22 -m state --state NEW -m recent --name ssh --update --seconds 60 --hitcount 4 -j nixos-fw-reject
    '';
  };

  # Copy the NixOS configuration file to /etc/nixos/configuration.nix on activation.
  system.copySystemConfiguration = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.vmuser = {
    isNormalUser = true;
    description = "VM Test User";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
    packages = with pkgs; [
      # Add minimal packages for VM testing
    ];
    shell = pkgs.fish;
  };

  # Use Fish shell as default
  programs.fish.enable = true;

  # Enable automatic login for the user (optional for VM)
  services.getty.autologinUser = "vmuser";

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = true;
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable Docker for VM
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Enable ZRAM for VM
  zramSwap.enable = true;
  zramSwap.memoryPercent = 25;

  # Enable NTFS support
  services.udisks2.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable the GNU Nix package manager
  nix.package = pkgs.nix;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = false; # Disabled for VM
  services.blueman.enable = false;

  # Enable Tailscale
  services.tailscale.enable = false; # Disabled for VM

  # Enable NFS client
  services.nfs.client.enable = false; # Disabled for VM

  # Enable avahi
  services.avahi = {
    enable = false; # Disabled for VM
    nssmdns = true;
  };

  # Define how NixOS should be built.
  system.stateVersion = "25.05"; # Did you read the comment?
}
