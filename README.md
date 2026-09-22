# NixOS Configuration: `nixos-laptop`

A modular, Flake-based NixOS configuration for an Intel + NVIDIA laptop (Razer/Microsoft peripherals) running **KDE Plasma 6**.

## Key Features

*   **Modern Desktop**: KDE Plasma 6 (Wayland) with custom aesthetics.
*   **Hybrid Graphics**: Pre-configured NVIDIA PRIME Offload.
*   **Developer Friendly**: `nix-ld` for binary compatibility, Zsh + Oh-My-Zsh, and Zed editor.
*   **Auto-Maintenance**: Automated weekly garbage collection and daily updates.
*   **Gaming Optimized**: Pre-installed Steam, GameMode, and compatibility layers (Wine/Proton).

### Hardware Optimizations
Specific logic in `modules/system/hardware.nix` ensures hardware performs optimally:
*   **Input Latency**: Custom `udev` rules disable USB autosuspend for the Razer DeathAdder V3 and Xbox One Controller.
*   **NVIDIA PRIME**: Configured for hybrid setups. Use `nvidia-offload <app>` to run demanding applications on the discrete GPU.
*   **Connectivity**: Bluetooth `Experimental` features enabled for improved BLE device pairing and reconnection speeds.

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


# Development environment

The NixOS/Home Manager configuration provides one shared development shell:

```text
~/nixos-config
└── devShells.x86_64-linux.default
```

A project opts into it with a `.envrc`:

```bash
use flake ~/nixos-config
```

Then run once:

```bash
direnv allow
```

After that, entering the project from Zed, a normal terminal, or another shell automatically activates the dev shell.

## Isolation boundary

Only the dev shell changes these paths:

- `XDG_CONFIG_HOME=$PWD/.dev/xdg/config`
- `XDG_DATA_HOME=$PWD/.dev/xdg/data`
- `XDG_STATE_HOME=$PWD/.dev/xdg/state`
- `XDG_CACHE_HOME=$PWD/.dev/xdg/cache`
- `PNPM_HOME=$PWD/.dev/pnpm`

The normal KDE/Home Manager session is unchanged.

This is deliberately not a filesystem sandbox. Tools that ignore XDG or use their own home-directory variables can still write to `$HOME`; those exceptions can be handled later when they are observed.

## Permanent vs dev

Kept in Home Manager because they are useful outside a project or are needed by the editor itself:

- `nodejs` (Zed's configured Node runtime)
- `nixd`
- `nixpkgs-fmt`
- `openssh`
- `gh`
- shell/CLI tools

Moved into the dev shell:

- `pnpm`
- `uv`
- `nixfmt`
- `nix-vite-plus`
- development agents
- `devcontainer`

`devenv` is no longer required for this setup.
