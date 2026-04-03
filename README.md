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
**Example Output:**
`00:02.0 VGA ... Intel` -> Bus ID is `PCI:0@0:2:0`
`01:00.0 3D ... NVIDIA` -> Bus ID is `PCI:1@0:0:0`

Update these values in `modules/hardware.nix` before applying the configuration.

---

## 📂 Repository Structure

The configuration is split into functional modules to maintain a clean and readable "Source of Truth."

* **`configuration.nix`**: The entry point. Handles the bootloader and imports all modules.
* **`hardware-configuration.nix`**: System-specific hardware scan (Kernel modules, file systems).
* **`modules/`**:
    * **`hardware.nix`**: NVIDIA PRIME, Bluetooth, and OpenGL/Graphics settings.
    * **`desktop.nix`**: Plasma 6, SDDM, PipeWire audio, and Font collections.
    * **`users.nix`**: User account definitions and user-specific app packages.
    * **`programs.nix`**: Global packages, Shell (Zsh), Gaming (Steam), and Dev tools.
    * **`system.nix`**: Locales (FR/US mix), Networking, and Maintenance (GC).

---

## 🚀 Key Features

| Category | Details |
| :--- | :--- |
| **Desktop** | KDE Plasma 6 (Wayland) with SDDM |
| **Graphics** | NVIDIA PRIME Offload (Intel + NVIDIA) |
| **Shell** | Zsh + Oh-My-Zsh (`refined` theme) & Aliases |
| **Locale** | English (US) System with French (FR) Units/Formatting |
| **Maintenance** | Weekly Garbage Collection & Daily Auto-upgrades |
| **Gaming** | Steam, GameMode, and Wine/Proton utilities |

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
This config includes custom `zsh` aliases for ease of use:
* `rebuild`: Apply changes locally (`sudo nixos-rebuild switch`)
* `update`: Update channels and apply (`sudo nixos-rebuild switch --upgrade`)

---

## 📦 System Toolset
- **Editors:** `Vim`, `Zed`
- **Development:** `GCC`, `NodeJS`, `Nil (LSP)`, `CMake`, `KDiff3`
- **Multimedia:** `VLC`, `EasyEffects`, `Kolourpaint`
- **System:** `NVTop` (GPU Monitor), `Aria2`, `Wayland-utils`, `7-Zip`

---

## ⚙️ Maintenance Logic
- **Store Optimization:** Daily at **03:45** to save disk space.
- **Garbage Collection:** Weekly cleanup of generations older than **30 days**.
- **Auto-Upgrade:** Daily check for system updates at **04:00**.

---

## 💡 Troubleshooting
- **No Graphics:** Ensure `services.xserver.videoDrivers` includes both `modesetting` and `nvidia`.
- **Audio Issues:** Check `easyeffects` if PipeWire sounds distorted or muted.
- **State Version:** Hardcoded to `25.11`. Do not change this unless performing a manual migration.
