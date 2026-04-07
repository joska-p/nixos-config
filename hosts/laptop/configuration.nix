{
  pkgs,
  lib,
  vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/hardware.nix
    ../../modules/system/desktop.nix
    ../../modules/system/users.nix
    ../../modules/system/programs.nix
    ../../modules/system/system.nix
    ../../modules/system/firefox.nix
    ../../modules/system/gaming.nix
    ../../modules/system/nix-ld.nix
    ../../modules/system/fonts.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # State version for tracking stateful data. Do not change.
  system.stateVersion = "25.11";
}
