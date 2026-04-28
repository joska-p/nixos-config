# ❄️ NixOS Configuration: `nixos-laptop`

A modular, Flake-based NixOS configuration for an Intel + NVIDIA laptop (Razer/Microsoft peripherals) running **KDE Plasma 6**.

---

## 🏗️ Project Structure

This configuration follows a modular approach to separate system concerns from user preferences.

```text
.
├── assets/                # Static resources (wallpapers, icons, etc.)
├── flake.lock             # Lockfile for dependency versions
├── flake.nix              # Entry point for the configuration
├── hosts/                 # Machine-specific configurations
│   └── laptop/            # Configuration for the 'laptop' host
│       └── hardware-configuration.nix
├── modules/               # Shared logic
│   ├── home/              # Home Manager (User-space apps & Zsh)
│   │   ├── zed.nix
│   │   └── zsh.nix        # Shell aliases and Oh-My-Zsh
│   └── system/            # NixOS System-level modules
│       ├── desktop.nix    # Plasma 6 / Wayland
│       ├── hardware.nix   # NVIDIA PRIME & Udev rules
│       └── system.nix     # Core settings & Nix-LD
├── pkgs/                  # Custom local packages
│   └── cursor/            # Cursor Editor + update.js script
└── README.md
```

*   **`hosts/`**: Contains hardware-specific logic and entry points for different machines.
*   **`modules/system/`**: Global configurations including networking, bootloader, and hardware drivers.
*   **`modules/home/`**: Managed via Home Manager for dotfiles, CLI tools, and desktop environment customization.
*   **`assets/`**: Centralized storage for branding and media.

---

## ✨ Key Features

*   **Modern Desktop**: KDE Plasma 6 (Wayland) with custom aesthetics.
*   **Hybrid Graphics**: Pre-configured NVIDIA PRIME Offload.
*   **Developer Friendly**: `nix-ld` for binary compatibility, Zsh + Oh-My-Zsh, and Zed editor.
*   **Auto-Maintenance**: Automated weekly garbage collection and daily updates.
*   **Gaming Optimized**: Pre-installed Steam, GameMode, and compatibility layers (Wine/Proton).

---

## 🛡️ Technical Highlights

### Hybrid Package Strategy
Tracks **NixOS 25.11** (Stable) for the system core, while exposing **Unstable** via `pkgs-unstable`. This provides a reliable base with the ability to opt-in to bleeding-edge developer tools.

### Hardware Optimizations
Specific logic in `modules/system/hardware.nix` ensures hardware performs optimally:
*   **Input Latency**: Custom `udev` rules disable USB autosuspend for the Razer DeathAdder V3 and Xbox One Controller.
*   **NVIDIA PRIME**: Configured for hybrid setups. Use `nvidia-offload <app>` to run demanding applications on the discrete GPU.
*   **Connectivity**: Bluetooth `Experimental` features enabled for improved BLE device pairing and reconnection speeds.

### Centralized Variables
A `vars` block in `flake.nix` centralizes system identity (username, git email, config paths). These are passed to both NixOS and Home Manager via `specialArgs` for global consistency.

### Custom Packages
*   **Cursor Editor**: A custom derivation in `pkgs/cursor/` using `appimageTools`.
    *   **Wayland Wrapper**: Uses shell expansion (`${NIXOS_OZONE_WL:+...}`) to conditionally apply `--ozone-platform-hint=auto` and Wayland IME flags only when a Wayland session is detected.
    *   **Nix-Native Updates**: The `--no-update` flag is forced to prevent the AppImage from trying to self-modify outside the Nix store.
    *   **Automation**: Maintenance is simplified via a local `update.js` script triggered by the `up-cursor` alias.

---

## 🛠️ Installation

1.  **Hardware Scan**: `nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix`
2.  **GPU IDs**: Find PCI IDs via `lspci -nn | grep -E "VGA|3D"` and update `intelBusId` and `nvidiaBusId` in `modules/system/hardware.nix`.
3.  **Personalize**: Update the `vars` block in `flake.nix` with your username and git credentials.
4.  **First Build**: `sudo nixos-rebuild switch --flake .#nixos-laptop`

---

## ⌨️ Workflow & Aliases

### System Maintenance
Commands defined in `modules/home/zsh.nix` for managing the flake from anywhere:

| Command | Action |
| :--- | :--- |
| `rebuild`    | Rebuild system using `~/nixos-config` |
| `update`     | Update all flake inputs and rebuild system |
| `up-cursor`  | Navigate to pkg, run `update.js`, and rebuild |
| `nix-clean`  | Garbage collect user and root generations |
| `nix-list`   | Show system generation history |
| `conf`       | Quick `cd` to configuration directory |

### Development & Productivity

| Alias | Description |
| :--- | :--- |
| `c` / `z` / `v` | Launch Cursor, Zed, or Vim |
| `ns <pkg>`     | `nix shell nixpkgs#<pkg>` (Ephemeral tools) |
| `gs` / `ga`     | Git Status / Git Add |
| `gc` / `gp`     | Git Commit / Git Push |
| `ll` / `la`     | Colorized `ls` with detail |
| `..` / `...`    | Easy directory navigation |
