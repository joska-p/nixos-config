{ pkgs, lib, ... }:

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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
