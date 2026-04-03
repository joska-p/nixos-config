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
`00:02.0 VGA ... Intel`
`01:00.0 3D ... NVIDIA`

**Conversion to Nix format:**
The format required is `PCI:<domain>@<bus>:<slot>:<func>`.
- `00:02.0` becomes `PCI:0@0:2:0`
- `01:00.0` becomes `PCI:1@0:0:0`

Update these values in `modules/hardware.nix` (`intelBusId` and `nvidiaBusId`) before applying the configuration.

### 3. Personalization (User & Hostname)
This configuration is tailored for the user `muratha` and hostname `nixos-btw`. To customize:

- **Hostname:** Change `networking.hostName` in `modules/system.nix`.
- **Username:** 
    1. Rename the user block in `modules/users.nix` (both `users.users.<name>` and `home-manager.users.<name>`).
    2. Update `home.username` and `home.homeDirectory` in `modules/home.nix`.

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

## 🛠 Installation & Usage

There are two ways to set this up. The **Symlink Method** is recommended for better security and ease of use with Git.

### Option A: The Symlink Method (Recommended)
This keeps the configuration in your home folder, allowing you to use Git without `sudo`.

```bash
# 1. Clone the repo to your home directory
git clone git@github.com:joska-p/nixos-config.git ~/nixos-config

# 2. Backup the default configuration
sudo mv /etc/nixos /etc/nixos.bak

# 3. Symlink your local config to the system path
sudo ln -s ~/nixos-config /etc/nixos

# 4. Restore your machine's unique hardware config
sudo cp /etc/nixos.bak/hardware-configuration.nix ~/nixos-config/
```

### Option B: The Standard Method
Directly managing the files in the system path.

```bash
sudo mv /etc/nixos /etc/nixos.bak
sudo git clone <your-repo-url> /etc/nixos/
sudo cp /etc/nixos.bak/hardware-configuration.nix /etc/nixos/
```

### 2. Management Aliases
This config includes custom `zsh` aliases for quick management:

| Alias | Description | Command |
| :--- | :--- | :--- |
| `rebuild` | Apply config changes | `sudo nixos-rebuild switch` |
| `update` | Upgrade NixOS channels & Apply | `sudo nixos-rebuild switch --upgrade` |
| `nix-clean`| Deep clean old generations | `sudo nix-collect-garbage -d` |
| `nix-list` | List system generations | `nix-env --list-generations ...` |
| `la` | Show all with useful info | `ls -lah` |
| `gs`, `ga`, `gc`| Git helpers | `status`, `add`, `commit` |
| `..`, `...` | Quick navigation | `cd ..`, `cd ../..` |
| `v`, `z` | Quick editor access | `vim`, `zed` |

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
