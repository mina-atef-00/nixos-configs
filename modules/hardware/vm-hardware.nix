# VM hardware configuration module for QEMU/KVM
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Bootloader configuration for VM
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = false; # No need to detect other OSes in VM
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # File system configuration for VM
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/12345678-1234-1234-1234-123456789abc"; # Will need to be updated with actual UUID after installation
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/12345678-1234-1234-1234-123456789def"; # Will need to be updated with actual UUID after installation
      fsType = "vfat";
    };
  };

  # Swap configuration
  swapDevices = [ ];

  # Enable zram swap for VM
  zramSwap = {
    enable = true;
    memoryPercent = 25; # Use less RAM for zram in VM
  };

  # Hardware configuration for VM
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # Enable QEMU guest agent
  services.qemuGuest.enable = true;

  # Enable VirtualBox guest additions if running in VirtualBox
  virtualisation.virtualbox.guest.enable = false;

  # Enable VMware guest additions if running in VMware
  virtualisation.vmware.guest.enable = false;

  # Enable SPICE for QEMU VMs
  services.spice-vdagentd.enable = true;

  # Graphics drivers for VM (using generic ones)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # For QEMU with virgl renderer
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Firmware support
  hardware.enableRedistributableFirmware = true;

  # Network hardware
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = false; # Disable blueman in VM

  # Enable audio with PipeWire
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false; # Disable JACK in VM
  };

  # Timezone (set to your location)
  time.timeZone = "Africa/Cairo";

  # Locale
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
}
