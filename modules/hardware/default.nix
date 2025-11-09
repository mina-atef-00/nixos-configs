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
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/e5a7a191-9c75-4a01-a9c2-1a910dcc7168";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2210-3B3A";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

 swapDevices =
    [ { device = "/dev/disk/by-uuid/2e90d11a-5706-438a-b0f4-b1fb40b82a03"; }
    ];

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
  };

  # Enable OpenGL support (already configured in hardware.graphics)
  # Remove deprecated hardware.opengl configuration

  # Firmware support
  hardware.enableRedistributableFirmware = true;

  # Network hardware
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = false; # Disable blueman since DMS Shell may provide better integration

  # Enable audio with PipeWire (already configured in base.nix)
  # Remove deprecated hardware.pulseaudio configuration

  # Enable printing (can be disabled later if not needed)
  services.printing.enable = false;

}
