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
  boot.plymouth.enable = true;
  boot.kernelModules = [ "v4l2loopback" "uinput" "xpad"];

  # Configure console keymap (this sets the system-wide default)
  # console.keyMap = lib.mkForce "us,ara";  # Commented out because multiple layouts can't be set this way
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

  # Use the standard NixOS firewall with proper configuration
 networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 2222 ]; # SSH on new port
    allowedUDPPorts = [ ]; # No specific UDP ports
    # NixOS firewall allows established/related connections by default (includes outgoing)
    # No need to explicitly allow outgoing connections - this happens automatically
    allowPing = false; # Disable ping unless needed for diagnostics
 };


users.users = {
    "mina" = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
        "audio"
        "video"
        "podman"
      ];
      hashedPassword = "$6$rounds=4096$0nh2sl0D0G0gqEiA$TCFCA36zEVuLGRDrluY02PaILJ31xLTjou.ADxgI8iWoar98sBUn0m4V06erkBU2UXkJYFVIljXNTv2aRTh4m0";
    };

    root.hashedPassword = "$6$rounds=4096$ZndMwux/UG4xJ6G/$mPu2hJDUbskiuagCddmnd3cogdNgpDk1z9LBWaTOeG8he90oWGW0qgqqGiVUSAxyiQaxheCm4sNrDqroguiCQ1";
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



  # upower.enable = false; # Power management (required for DMS battery monitoring)


  # Printing is disabled by default but can be enabled if needed.
  # To enable printing, uncomment the next line:
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true; 
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
  # Power management settings to prevent sleep issues with Wayland
  services.logind = {
    lidSwitch = "ignore";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
    powerKey = "ignore";
    suspendKey = "ignore";
  };
  # Note: blueman is configured in hardware module

  # Enable Tailscale
 # Enable NFS support
 services.rpcbind.enable = true;
 services.nfs.server.enable = true;



  services.tailscale.enable = true;
  
  

  # Enable NFS client

  # Enable SDDM display manager (with Wayland support for MangoWC)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  
  # Enable avahi
 services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Define how NixOS should be built.
 system.stateVersion = "25.05"; # Did you read the comment?
}
