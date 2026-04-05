{ lib, ... }:
{
  #services.udev.extraRules = ''
  # Razer DeathAdder V3 - Disable USB Autosuspend
  #ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1532", ATTR{idProduct}=="00b2", ATTR{power/control}="on"
  # Xbox One Controller - Disable USB Autosuspend
  #ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="045e", ATTR{idProduct}=="02ea", ATTR{power/control}="on"
  #'';

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    open = false;
    modesetting.enable = true; # THIS IS CRITICAL
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Find your GPU IDs with:
      #   lspci -nn | grep -E "VGA|3D"
      # Example output:
      #   00:02.0 VGA compatible controller [0300]: Intel Corporation ...
      #   01:00.0 3D controller [0302]: NVIDIA Corporation ...
      # Convert to Nix format `PCI:<domain>@<bus>:<slot>:<func>` (or use the IDs that match your machine):
      #   intelBusId = "PCI:0@0:2:0"
      #   nvidiaBusId = "PCI:1@0:0:0"

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
