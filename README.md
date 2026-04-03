# ❄️ NixOS Configuration: `nixos-btw`

This repository houses a modularized, reproducible NixOS configuration tailored for a hybrid GPU laptop (Intel + NVIDIA) running **KDE Plasma 6**.

---

## ⚠️ Important: Before You Begin

### 1. Hardware Configuration
The file `hardware-configuration.nix` is **unique to each machine**. 
- If you are cloning this to a new device, **do not overwrite** your existing `hardware-configuration.nix`. 
- If you don't have one, generate it first using:
  ```bash
  nixos-generate-config --show-config
  ```

### 2. GPU Bus IDs
NVIDIA PRIME offloading requires the exact PCI Bus IDs for your hardware. To find yours, run:
```bash
lspci -nn | grep -E "VGA|3D"
```
Update these values in `modules/hardware.nix` before applying the configuration.

---

## 📂 Repository Structure

The configuration is split into functional modules to maintain a clean and readable "Source of Truth."

* **`configuration.nix`**: The main entry point. Handles the bootloader and imports all modules.
* **`hardware-configuration.nix`**: System-specific hardware scan (Kernel modules, file systems).
* **`modules/`**:
    * **`hardware.nix`**: NVIDIA PRIME (Offload mode), Bluetooth (Experimental/FastConnect), and Graphics settings.
    * **`desktop.nix`**: KDE Plasma 6 (Wayland), SDDM, PipeWire audio, and extensive Font collections (Nerd Fonts, Fira Code).
    * **`users.nix`**: Defines the `muratha` user and bridges to Home Manager.
    * **`home.nix`**: **Home Manager** configuration for the user. Manages Git, Zsh, and Zed editor settings.
    * **`programs.nix`**: System-wide programs, Steam (with GameMode), and **nix-ld** for unpatched binary support.
    * **`system.nix`**: Locales (FR/US mix), Networking (NetworkManager), and Maintenance (GC/Auto-optimise).

---

## 🚀 Key Features

| Category | Details |
| :--- | :--- |
| **Desktop** | KDE Plasma 6 with SDDM (Auto-Numlock enabled) |
| **Graphics** | NVIDIA PRIME Offload (Intel + NVIDIA) with 32-bit support |
| **Shell** | Zsh + Oh-My-Zsh (`refined` theme) managed by Home Manager |
| **Compatibility** | **nix-ld** enabled for running unpatched binaries (LSPs, etc.) |
| **Audio** | PipeWire with ALSA/Pulse support and **EasyEffects** |
| **Maintenance** | Weekly Garbage Collection and Automatic Store Optimization |
| **Gaming** | Steam, ProtonTricks, and GameMode (Renice 10, GPU device 1) |

---

## 🛠 Usage

### 1. Installation
```bash
# Backup your existing config first!
sudo mv /etc/nixos /etc/nixos.bak
sudo git clone <your-repo-url> /etc/nixos/
# Restore your machine-specific hardware config
sudo cp /etc/nixos.bak/hardware-configuration.nix /etc/nixos/
```

### 2. Management Aliases
This config includes custom `zsh` aliases for quick management:
* `rebuild`: Apply changes locally (`sudo nixos-rebuild switch`)
* `update`: Update channels and apply (`sudo nixos-rebuild switch --upgrade`)
* `ll`: Long list format (`ls -l`)

---

## 📦 System & User Toolset
- **Editors:** `Vim`, `Zed` (with Gruvbox Dark & Nixd integration), `VS Code`
- **Development:** `GCC`, `NodeJS`, `nixd` (Nix LSP), `CMake`, `KDiff3`
- **Multimedia:** `VLC`, `EasyEffects`, `Kolourpaint`, `KCalc`
- **Utilities:** `bat`, `aria2`, `uget`, `nvtop`, `p7zip`, `wl-clipboard`
- **Gaming:** `Steam`, `Wine`, `Winetricks`, `ProtonPlus`

---

## ⚙️ Maintenance Logic
- **Store Optimization:** Enabled (`nix.optimise.automatic = true`) to save disk space.
- **Garbage Collection:** Weekly cleanup of generations older than **30 days**.
- **Auto-Upgrade:** Enabled to keep the system up to date.

---

## 💡 Troubleshooting
- **No Graphics:** Ensure `services.xserver.videoDrivers` includes both `modesetting` and `nvidia`.
- **Zed LSP:** Ensure `nix-ld` is active if language servers fail to start.
- **State Version:** Set to `25.11` for both System and Home Manager.
