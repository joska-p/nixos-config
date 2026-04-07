# ❄️ NixOS Configuration: `nixos-laptop`

A modular, Flake-based NixOS configuration tailored for a hybrid GPU laptop (Intel + NVIDIA) running **KDE Plasma 6**. This setup uses **Home Manager** as a NixOS module for a unified system and user environment.

---

## 🏗️ Architecture & Organization

The configuration is organized into a clean, hierarchical structure to separate host-specific settings from reusable system modules and user configurations.

### 🏠 Hosts (`hosts/`)
Machine-specific configurations.
*   **`hosts/laptop/`**: The main host configuration.
    *   `configuration.nix`: Core entry point for this machine.
    *   `hardware-configuration.nix`: Auto-generated hardware scan.

### 📦 System Modules (`modules/system/`)
Reusable system-level configurations.
*   `desktop.nix`: Desktop Environment (Plasma 6), Display Manager (SDDM), and Audio (PipeWire).
*   `hardware.nix`: Graphics (NVIDIA PRIME), Bluetooth, and firmware.
*   `system.nix`: Core OS settings (Networking, Locales, GC, Nix settings).
*   `users.nix`: User definitions and Home Manager bridge.
*   `programs.nix`: General system-wide packages and VS Code.
*   **Dedicated Program Modules**:
    *   `firefox.nix`: Extensive Firefox policy configuration.
    *   `gaming.nix`: Steam, GameMode, and gaming optimizations.
    *   `nix-ld.nix`: Binary compatibility for unpatched tools (LSPs, etc.).
    *   `fonts.nix`: Curated set of Nerd Fonts and system fonts.

### 👤 User Modules (`modules/home/`)
Home Manager configurations for user-space.
*   `default.nix`: Main Home Manager entry point.
*   `zsh.nix`: Shell configuration (Zsh + Oh-My-Zsh).
*   `git.nix`: Git identity and aliases.
*   `zed.nix`: Zed editor settings and custom agents.

### 🖼️ Assets (`assets/`)
Static files used by the configuration.
*   `wallpaper.jpg`: System-wide desktop and SDDM background.

---

## 🚀 Key Features

*   **Modern Desktop**: KDE Plasma 6 (Wayland) with a beautiful custom wallpaper.
*   **Hybrid Graphics**: NVIDIA PRIME Offload mode pre-configured for Intel/NVIDIA laptops.
*   **Declarative User Env**: Shell, Git, and Editor (Zed) managed via Home Manager.
*   **Compatibility**: `nix-ld` enabled to run unpatched binaries (perfect for VS Code/Zed LSPs).
*   **Maintenance**: Automated weekly garbage collection and nix-store optimization.
*   **Gaming**: Steam, GameMode, and Wine compatibility tools pre-installed.
*   **Automated Updates**: Daily background updates of `nixpkgs` (9 AM with randomized delay) and weekly garbage collection to keep the system clean and secure.

---

## 🛠️ Setup & Customization

### 1. Hardware Prerequisites
This configuration requires your machine-specific hardware scan. If setting up on a new machine:
1.  Generate a base config: `nixos-generate-config --show-config`
2.  Place your `hardware-configuration.nix` in the host's directory (e.g., `hosts/laptop/`).
3.  **GPU Bus IDs**: Update `intelBusId` and `nvidiaBusId` in `modules/system/hardware.nix`.

### 2. User Personalization
- **Hostname**: Set in `modules/system/system.nix`.
- **Username**: Update in `modules/system/users.nix` and `modules/home/default.nix`.

---

## 🧹 Maintenance

The system is configured for automated self-maintenance:
*   **Auto-Upgrades**: `nixpkgs` is updated daily at 9:00 AM (randomized delay up to 45m).
*   **Garbage Collection**: Weekly cleaning of older system generations.
*   **Nix Optimization**: Periodic store optimization to save disk space.

---

## 💻 Usage

Since this is a Flake-based configuration, you can apply changes directly from the repository directory.

### Apply Configuration
```bash
# Rebuild and switch to the new configuration
sudo nixos-rebuild switch --flake .

# Update all flake inputs (nixpkgs, etc.) and rebuild
nix flake update
sudo nixos-rebuild switch --flake .
```

### Management Aliases
The configuration includes several Zsh aliases for convenience:
*   `rebuild`: Quick system rebuild.
*   `update`: Update system and apply changes.
*   `nix-clean`: Deep clean old generations.
*   `nix-list`: List system generations.
*   `gs` / `ga` / `gc` / `gp`: Git workflow shortcuts.
