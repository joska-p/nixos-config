# ❄️ NixOS Configuration: `nixos-laptop`

A modular, Flake-based NixOS configuration for an Intel + NVIDIA laptop running **KDE Plasma 6**.

---

## 🏗️ Structure

*   **`hosts/`**: Machine-specific configurations.
*   **`modules/system/`**: System-level modules (Desktop, Hardware, System, etc.).
*   **`modules/home/`**: User-space configuration (Home Manager).
*   **`assets/`**: Static files like wallpapers.

---

## 🚀 Key Features

*   **Modern Desktop**: KDE Plasma 6 (Wayland) with custom aesthetics.
*   **Hybrid Graphics**: Pre-configured NVIDIA PRIME Offload.
*   **Developer Friendly**: `nix-ld` for binary compatibility, Zsh + Oh-My-Zsh, and Zed editor.
*   **Auto-Maintenance**: Automated weekly garbage collection and daily updates.
*   **Gaming Ready**: Steam, GameMode, and Wine/Proton tools.

---

## 🛠️ Installation

1.  **Hardware Scan**: Generate your `hardware-configuration.nix` and place it in `hosts/laptop/`.
2.  **GPU IDs**: Update `intelBusId` and `nvidiaBusId` in `modules/system/hardware.nix`.
3.  **Personalize**: Update `vars` in `flake.nix`.

---

## 💻 Usage

```bash
# Apply configuration
sudo nixos-rebuild switch --flake .

# Update and apply
nix flake update
sudo nixos-rebuild switch --flake .
```

### Useful Aliases
- `rebuild`: Quick system rebuild.
- `update`: Update inputs and apply.
- `nix-clean`: Deep clean old generations.
- `gs` / `ga` / `gc` / `gp`: Git shortcuts.
