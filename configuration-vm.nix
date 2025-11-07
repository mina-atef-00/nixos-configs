# VM system configuration that imports all VM-specific modules
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    # Include VM hardware-specific configuration
    ./modules/hardware/vm-hardware.nix

    # Include VM base system configuration
    ./modules/system/vm-base.nix

    # Include VM system packages configuration
    ./modules/system/vm-packages.nix

    # Include VM desktop environment configuration
    ./modules/desktop/vm-mangowc.nix
  ];

  # Define how NixOS should be built for VM.
  system.stateVersion = "25.05"; # Did you read the comment?
}
