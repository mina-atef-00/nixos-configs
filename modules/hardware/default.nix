# Hardware configuration module
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Bootloader configuration - GRUB for UEFI with NixOS generation support
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true; # Detect other OSes like previous NixOS generations
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # File system configuration based on your current setup
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6c9f0812-12a8-43ed-b7c3-774a1929981d"; # Will need to be updated with actual UUID after installation
      fsType = "btrfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3437-1D6B"; # Will need to be updated with actual UUID after installation
      fsType = "vfat";
    };
  };

  # Swap configuration (based on your zram0 setup)
  swapDevices = [ ];

  # Enable zram swap
  zramSwap = {
    enable = true;
    memoryPercent = 50; # Use up to 50% of RAM for zram swap
  };

  # Hardware configuration
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # CPU microcode for Intel
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # NVIDIA graphics drivers for RTX 2060
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # For gaming compatibility
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # Use proprietary driver for full RTX 2060 features
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # Optimize for desktop use (set to true if using laptop)
    laptop = false;
  };

  # Enable OpenGL support
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
  services.blueman.enable = true;

  # Enable audio with PipeWire
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Enable printing (can be disabled later if not needed)
  services.printing.enable = false;

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
