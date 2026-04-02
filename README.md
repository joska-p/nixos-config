# NixOS Configuration (nixos-config)

This repository contains a personal NixOS configuration for one machine, intended to be used as a base for reproducible local configuration.

## Layout

- `configuration.nix` - main NixOS system config.
- `hardware-configuration.nix` - auto-generated hardware config from installer.
- (other files as needed in future)

## Goals

- Desktop setup (Plasma 6, SDDM)
- Hybrid GPU (Intel + NVIDIA prime offload)
- French locale formatting with English system language
- Automatic Nix store maintenance and periodic upgrades
- Useful development tools installed system-wide
- Minimal and readable personal configuration without multiple layers

## Key features

- Boot:
  - `systemd-boot`
  - EFI enabled
- Locale:
  - `i18n.defaultLocale = "en_US.UTF-8"`
  - `i18n.extraLocales = [ "fr_FR.UTF-8" ]`
  - French `LC_*` categories forcing local conventions
- Graphics:
  - `modesetting`, `nvidia` driver
  - `hardware.nvidia.prime.offload.enable = true`
  - explicit `intelBusId` / `nvidiaBusId` for PRIME
- Desktop:
  - `services.xserver`
  - `services.displayManager.sddm`
  - `services.desktopManager.plasma6`
- Sound:
  - `services.pipewire` + `alsa + pulse`
- Network:
  - `networking.networkmanager.enable = true`
- Git, Firefox, VS Code, Steam, gamemode etc enabled using `programs.*`
- RNG:
  - `nix.optimise` auto at 03:45
  - `nix.gc` weekly, `--delete-older-than 30d`
  - `system.autoUpgrade` daily at 04:00 (no auto reboot)

## Packages

System-wide packages are in `environment.systemPackages` (e.g. `vim`, `cmake`, `gcc`, `nodejs`, `vlc`, etc).  
User-specific packages can be kept under `users.users.<username>.packages` when needed.

## How to use

1. Clone your repo:
    - `git clone <repo> && cd nixos-config`
2. Review `hardware-configuration.nix` and `configuration.nix`.
3. Update hardware IDs if needed:
    - `lspci -nn | grep -E "VGA|3D"`
4. Rebuild:
    - `sudo nixos-rebuild switch --upgrade`
5. If no reboot is allowed by auto-upgrade, do manual:
    - `sudo reboot` after `nixos-rebuild` if required.

## Notes

- `system.stateVersion` pins the NixOS channel behavior;
  update when upgrading the OS and testing.
- `nixpkgs.config.allowUnfree = true` is set here to support things like NVidia firmware and some apps.
- Keep the configuration file compact; split into modules only if the config grows significantly.

## Troubleshooting

- GPU PRIME errors:
  - ensure both `intelBusId` + `nvidiaBusId` are set with proper values.
- Locale:
  - check `locale` and `locale -k LC_TIME`
- Auto-upgrade:
  - if no `system.autoUpgrade` option, inspect your channel version.