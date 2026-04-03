{ ... }:
{
  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = [ "weekly" ];
    options = "--delete-older-than 30d";
  };

  system.autoUpgrade.enable = true;
}
