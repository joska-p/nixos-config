# ❄️ NixOS Configuration: `nixos-btw`

A modular, Flake-based NixOS configuration tailored for a hybrid GPU laptop (Intel + NVIDIA) running **KDE Plasma 6**. This setup uses **Home Manager** as a NixOS module for a unified system and user environment.

---

## 🏗️ Architecture & Modules

The configuration is organized into functional modules to maintain a clean "Source of Truth."

*   **`flake.nix`**: The entry point. Defines inputs (NixOS, Home Manager) and system outputs.
*   **`configuration.nix`**: Core system entry point. Handles bootloader and imports.
*   **`modules/`**:
    *   **`system.nix`**: Core OS settings (Networking, Locales, GC, Nix settings).
    *   **`desktop.nix`**: Desktop Environment (Plasma 6), Display Manager (SDDM), and Audio (PipeWire).
    *   **`hardware.nix`**: Graphics (NVIDIA PRIME), Bluetooth, and firmware.
    *   **`programs.nix`**: System-level applications, Steam, and `nix-ld` for binary compatibility.
    *   **`users.nix`**: User definitions and Home Manager bridge.
    *   **`home.nix`**: User-space configuration (Shell, Git, Editor settings).

---

## 🚀 Key Features

*   **Modern Desktop**: KDE Plasma 6 (Wayland) with a curated set of Nerd Fonts.
*   **Hybrid Graphics**: NVIDIA PRIME Offload mode pre-configured for Intel/NVIDIA laptops.
*   **Declarative User Env**: Shell (Zsh + Oh-My-Zsh), Git, and Editor (Zed) managed via Home Manager.
*   **Compatibility**: `nix-ld` enabled to run unpatched binaries (perfect for VS Code/Zed LSPs).
*   **Maintenance**: Automated weekly garbage collection and nix-store optimization.
*   **Gaming**: Steam, GameMode, and Wine compatibility tools pre-installed.

---

## 🛠️ Setup & Customization

### 1. Hardware Prerequisites
This configuration requires your machine-specific hardware scan. If setting up on a new machine:
1.  Generate a base config: `nixos-generate-config --show-config`
2.  Ensure your `hardware-configuration.nix` is present in the root of this repo.
3.  **GPU Bus IDs**: Update `intelBusId` and `nvidiaBusId` in `modules/hardware.nix`. Find them using:
    ```bash
    lspci -nn | grep -E "VGA|3D"
    ```

### 2. User Personalization
- **Hostname**: Set in `modules/system.nix`.
- **Username**: Update in `modules/users.nix` and `modules/home.nix`.

---

## 💻 Usage

Since this is a Flake-based configuration, you can apply changes directly from the repository directory without symlinking to `/etc/nixos`.

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

---

## ⚙️ Maintenance
The system is configured to stay lean automatically:
- **Garbage Collection**: Runs weekly, removing generations older than 30 days.
- **Store Optimization**: Automatically hardlinks duplicate files in the Nix store.
- **Auto-Upgrade**: Periodically checks for system updates.
