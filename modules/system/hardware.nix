{ lib, ... }:
{
  services.udev.extraRules = ''
    # Razer DeathAdder V3 - Disable USB Autosuspend
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="00b2", ATTR{power/control}="on"
    # Xbox One Controller - Disable USB Autosuspend
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02ea", ATTR{power/control}="on"
  '';

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    open = false;
    modesetting.enable = true; # Required for NVIDIA PRIME
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # GPU IDs (Run: lspci -nn | grep -E "VGA|3D")
      # Format: PCI:<domain>@<bus>:<slot>:<func>
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
}
