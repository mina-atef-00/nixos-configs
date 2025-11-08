# MangoWC configuration module for NixOS
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

  # Configure video drivers for MangoWC
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    xkb.layout = "us,ar";
    xkb.options = "grp:win_space_toggle,caps:swapescape";
  };
  hardware.graphics.enable = true;
}
