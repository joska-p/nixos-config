{ pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/hardware.nix
    ./modules/desktop.nix
    ./modules/users.nix
    ./modules/programs.nix
    ./modules/system.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Keep stateVersion in the main file so you never lose track of it
  system.stateVersion = "25.11";
}
