# Main system configuration that imports all modules
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    # Include hardware-specific configuration
    ./modules/hardware/default.nix

    # Include base system configuration
    ./modules/system/base.nix

    # Include system packages configuration
    ./modules/system/packages.nix

    # Include desktop environment configuration
    ./modules/desktop/mangowc.nix
  ];

  # Define how NixOS should be built.
  system.stateVersion = "25.05"; # Did you read the comment?
  
  # Allow unfree packages (needed for nvidia drivers)
  nixpkgs.config.allowUnfree = true;
}
