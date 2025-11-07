# Lightweight MangoWC configuration module for VM
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  # Use the MangoWC NixOS module
  imports = [
    inputs.mangowc.nixosModules.mango
  ];

  # Enable MangoWC at the system level
  programs.mango.enable = true;

  # Configure video drivers for VM (using generic ones for QEMU/VirtualBox/VMware)
  services.xserver = {
    videoDrivers = [
      "virtualbox"
      "vmware"
      "modesetting"
      "fbdev"
    ]; # Multiple options for different VM types
    layout = "us,ar";
    xkbOptions = "grp:win_space_toggle,caps:swapescape";
  };

  # Enable lighter graphics acceleration for VM
  hardware.graphics.enable = true;
  hardware.opengl.enable = true;
}
