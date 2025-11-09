# Base system configuration module
{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Bootloader - Use GRUB instead of systemd-boot
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true; # Detect other OSes like previous NixOS generations
  };

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
    # The global useDHCP flag is deprecated, therefore explicitly set to false.
    useDHCP = false;
    # Configure network interfaces manually if not using DHCP.
    interfaces.enp3s0.useDHCP = true; # Adjust interface name as needed
    interfaces.wlo1.useDHCP = true; # Adjust interface name as needed
  };

  # Use UFW as firewall manager instead of iptables for easier management
  services.ufw = {
    enable = true;
    # Allow outgoing connections by default
    enableDefaultOutgoing = true;
    # Allow incoming SSH on new port
    allowedTCPPorts = [ 2222 ]; # SSH on new port
    # Additional allowed services can be added as needed
    extraAllowed = [ ]; # Additional custom rules if needed
  };
  
  # Disable the default NixOS firewall to avoid conflicts with UFW
  networking.firewall.enable = false;


  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.mina = {
    isNormalUser = true;
    description = "mina user";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "podman"
    ];
    packages = with pkgs; [
      # Add packages for this user
    ];
    shell = pkgs.fish;
  };

  # Use Fish shell as default
  programs.fish.enable = true;

  # Enable automatic login for the user (optional)
  # services.getty.autologinUser = "mina";

  # Enable the OpenSSH daemon with hardened security.
  services.openssh = {
    enable = true;
    ports = [ 2222 ]; # Change SSH port from default 22
    settings = {
      PermitRootLogin = "no"; # Disable root login
      PasswordAuthentication = false; # Disable password authentication
      KbdInteractiveAuthentication = true; # Disable keyboard-interactive authentication
      PubkeyAuthentication = true; # Enable public key authentication only
      PermitEmptyPasswords = false;
      X11Forwarding = false;
      AllowTcpForwarding = true;
      GatewayPorts = "no";
      AllowAgentForwarding = false;
      MaxAuthTries = 15;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
    };
  };

  # Printing is disabled by default but can be enabled if needed.
  # To enable printing, uncomment the next line:
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  # Enable flatpak support
  services.flatpak.enable = false;

  # Enable Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Enable docker-compatible socket
    dockerSocket.enable = true; # Create the docker-compatible socket
    extraPackages = with pkgs; [
      podman-compose
    ];
  };

  # Enable ZRAM
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # Enable NTFS support
  services.udisks2.enable = true;
  boot.supportedFilesystems = [ "ntfs" "nfs" ];

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
    options = "";
  };

  # Keep only the last 3 generations (current + 2 previous)

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = false; # Disable blueman since DMS Shell may provide better integration

  # Enable Tailscale
  # Enable NFS support
  services.rpcbind.enable = true;


  services.tailscale.enable = true;

  # Enable NFS client

  # Enable SDDM display manager
  services.displayManager.sddm.enable = true;
 services.xserver.enable = true;

  # Enable avahi
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Define how NixOS should be built.
  system.stateVersion = "25.05"; # Did you read the comment?
}
