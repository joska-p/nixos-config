{ vars, ... }:
{
  networking.hostName = vars.hostname;
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  console.keyMap = "fr";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = [ "weekly" ];
    options = "--delete-older-than 30d";
  };

  system.autoUpgrade = {
    enable = true;
    flake = vars.configDir;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
    ];
    dates = "09:00";
    randomizedDelaySec = "45min";
  };
}
