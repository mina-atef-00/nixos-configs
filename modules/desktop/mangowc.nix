# MangoWC configuration module for NixOS
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  # Temporarily disable MangoWC due to build issues with incompatible wlroots
  # Will re-enable when a compatible version is available
  
  # Import the MangoWC NixOS module (commented out due to build issues)
  # imports = [
  #   inputs.mangowc.nixosModules.mango
  # ];

  # Enable MangoWC at the system level (commented out due to build issues)
  # programs.mango.enable = true;

  # Configure video drivers for MangoWC (commented out due to build issues)
  # services.xserver = {
  #   videoDrivers = [ "nvidia" ];
  #   layout = "us,ar";
  #   xkbOptions = "grp:win_space_toggle,caps:swapescape";
  # };
  # hardware.graphics.enable = true;
}
