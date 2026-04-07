{ pkgs, ... }:
{
  # --- Graphics & X11 ---
  services.xserver = {
    enable = true;
    videoDrivers = [
      "modesetting"
      "nvidia"
    ];
    xkb = {
      layout = "fr";
      variant = "";
    };
  };

  # --- Desktop Environment (KDE Plasma 6) ---
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.elisa
    kdePackages.kate
  ];

  # --- Audio (PipeWire) ---
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
