# Hardware configuration module
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # File system configuration based on your current setup
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4cdb365c-f2a3-4088-88ae-44cf1d8542b6";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8448-D59E";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192;
    }
  ];
  # # Enable zram swap
  # zramSwap = {
  #   enable = true;
  #   memoryPercent = 50; # Use up to 50% of RAM for zram swap
  # };

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
    # Enable for better Wayland support
    forceFullCompositionPipeline = true;
    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;
  };

  hardware.enableRedistributableFirmware = true;
  hardware.bluetooth.enable = true;
}
