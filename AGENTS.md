# Repository Agent Guidelines

Welcome AI Agent. This repository contains the Nix flake configuration for a ThinkPad (NixOS) and a work Mac (nix-darwin), with multi-user Home Manager profiles, dual dynamic desktop shell support (DMS and Noctalia), and a pure Lua-based Hyprland window manager.

Follow the instructions, architectural invariants, and safety protocols below when modifying or extending this codebase.

---

## 1. System & Repository Architecture

### Directory Structure & Component Map

```text
.
├── flake.nix                          # Flake entrypoint: thinkpad + work-mac configs, formatters
├── flake.lock                         # Pinned dependency revisions
├── hosts/
│   ├── thinkpad/
│   │   ├── default.nix                # Host entrypoint: imports system, hardware, packages & home-manager
│   │   ├── configuration.nix          # System config: GNOME/GDM, Pipewire, fprintd (Goodix TOD), PAM/polkit
│   │   ├── hardware-configuration.nix # Generated HW: LUKS encrypted root/home/boot, EFI systemd-boot
│   │   ├── hardware-embedded.nix      # Udev rules (CP210x, CH340) & user groups (dialout, plugdev)
│   │   └── virtualisation.nix         # Podman daemon & Docker socket emulation
│   └── work-mac/
│       └── default.nix                # nix-darwin host: Homebrew casks, Touch ID, HM for santhoshc
├── modules/
│   └── packages/
│       ├── cli.nix                    # Linux system CLI (gcc, wl-clipboard, usbutils…) & 1Password browser allowlist
│       └── desktop.nix                # Shared GUI tools, fonts (JetBrainsMono NF), Hyprland & portals
└── users/
    ├── lisasri/
    │   └── home.nix                   # Minimal user profile (GNOME tweaks, Ghostty)
    └── santhosh/
        ├── home.nix                   # Linux entrypoint: desktop apps, Hyprland/DMS, GTK
        ├── work-mac-home.nix          # Darwin entrypoint: username/home only; imports common.nix
        ├── config/
        │   └── aliases.nix            # Shared shell aliases (eza, bat, lazygit, nvim, darwin rebuild)
        └── modules/
            ├── common.nix             # Cross-platform HM: zsh/OMZ, LazyVim, direnv, git, CLI pkgs
            ├── starship.nix           # Shared Starship prompt settings
            ├── shell.nix              # custom.desktop.shell option, generates constants.lua & session target
            ├── dms.nix                # DankMaterialShell: theme, plugins (calc, clock), widgets, bar layout
            ├── noctalia.nix           # Noctalia shell: top bar, system monitor, dark theme, systemd service
            ├── hyprland.nix           # Symlinks ./hypr to ~/.config/hypr (HM wrapper disabled)
            ├── 1password.nix          # 1Password CLI & shell plugins
            ├── zen.nix                # Zen browser flake package integration
            ├── desktop.nix            # Unfree predicates & 1Password polkit permissions
            └── hypr/                  # Pure-Lua Hyprland configuration
                ├── hyprland.lua       # Entrypoint loading all config/*.lua modules
                └── config/
                    ├── constants.lua  # Generated at build: main_mod, shell, ipc prefix
                    ├── keybinds.lua   # Keybindings (DMS vs Noctalia conditional dispatches)
                    ├── animations.lua # Hyprland window/workspace animation curves
                    ├── decoration.lua # Blurs, rounding, shadows
                    ├── environment.lua# Wayland/XDG environment variables
                    ├── general.lua    # Layout (dwindle), gaps, border colors
                    ├── input.lua      # Keyboard layout, touchpad natural scroll
                    ├── misc.lua       # Gestures, misc Hyprland settings
                    └── monitors.lua   # Monitor resolutions, refresh rates, positioning
```

---

## 2. Desktop Shell Architecture & Switching

The user switches between desktop shells using a custom Nix option:
```nix
# In users/santhosh/home.nix:
custom.desktop.shell = "dms"; # Options: "dms" | "noctalia" | "none"
```

### How Dynamic Shell Switching Works:
1. **Option Definition (`users/santhosh/modules/shell.nix`)**:
   Defines `config.custom.desktop.shell` (enum: `"dms"`, `"noctalia"`, `"none"`).
2. **Dynamic Lua Constants Generation**:
   `shell.nix` writes `~/.config/hypr/config/constants.lua` dynamically:
   - For `dms`: `main_mod = "SUPER"`, `shell = "dms"`, `ipc = "dms ipc call "`
   - For `noctalia`: `main_mod = "SUPER"`, `shell = "noctalia"`, `ipc = "noctalia msg "`
3. **Hyprland Keybinding Dispatch (`users/santhosh/modules/hypr/config/keybinds.lua`)**:
   Hyprland checks `constants.shell` and binds appropriate IPC calls for launchers, settings, overview, notifications, and screenshot utilities.
4. **Conditional Module Activation**:
   - `users/santhosh/modules/dms.nix` activates only when `cfg.shell == "dms"`.
   - `users/santhosh/modules/noctalia.nix` activates only when `cfg.shell == "noctalia"`.
5. **Systemd Session Target**:
   `systemd.user.targets.hyprland-session` binds the active shell daemon to the graphical session.

---

## 3. Hyprland Pure-Lua Configuration Rules

> [!IMPORTANT]
> Hyprland in this repository is NOT configured via Home Manager's `wayland.windowManager.hyprland.settings` Nix syntax.

- **Why**: `wayland.windowManager.hyprland.enable` is set to `false` in `users/santhosh/modules/hyprland.nix` to prevent Home Manager from generating a static `hyprland.conf`.
- **How It Works**: `xdg.configFile."hypr"` recursively links `users/santhosh/modules/hypr/` to `~/.config/hypr`.
- **Lua Globals**: The configuration uses Hyprland's Lua plugin/bindings:
  - `hl.config({ ... })`: Sets core Hyprland options (general, decoration, misc, input).
  - `hl.bind(combo, dispatcher, [opts])`: Registers keybindings.
  - `hl.gesture({ fingers, direction, action })`: Registers touchpad swipe gestures.
  - `hl.dsp.*`: Dispatches commands (e.g. `hl.dsp.exec_cmd("ghostty")`, `hl.dsp.window.close()`).
- **Editing Lua Files**:
  - Always check `users/santhosh/modules/hypr/config/keybinds.lua` when modifying key shortcuts.
  - Shell-dependent keybindings must use `if shell == "dms" ... elseif shell == "noctalia" ... end`.
  - Format Lua files using `stylua`.

---

## 4. Package & Module Placement Decision Tree

When adding packages, tools, or configuration settings, follow this exact placement guide:

| Category | Target File | Example Packages / Settings |
| :--- | :--- | :--- |
| **System CLI Utilities (Linux)** | `modules/packages/cli.nix` | `neovim`, `git`, `gcc`, `fd`, `wl-clipboard`, `usbutils`, build/hardware tools |
| **System GUI / Desktops** | `modules/packages/desktop.nix` | Fonts (`nerd-fonts`), system display portals, core browsers (`firefox`), media players |
| **Hardware, Kernel, Boot** | `hosts/thinkpad/` | Kernel modules, udev rules (`hardware-embedded.nix`), LUKS, Podman/Docker (`virtualisation.nix`) |
| **Cross-platform user CLI / shell** | `users/santhosh/modules/common.nix` | zsh/OMZ, Starship, LazyVim, direnv, `lazygit`, `glab`, `claude-code`, etc. |
| **Linux desktop packages** | `users/santhosh/home.nix` | Desktop apps (`ghostty`, `kitty`, `chromium`, `localsend`), Hyprland extras |
| **Darwin host / Homebrew** | `hosts/work-mac/default.nix` | nix-darwin system, Homebrew casks, Touch ID |
| **Complex User Services** | `users/santhosh/modules/<name>.nix` | Shell configurations, custom bars, browsers with extensions, CLI integration plugins |
| **User Shell Aliases** | `users/santhosh/config/aliases.nix` | Command shortcuts (`ls = "eza"`, `gst = "git status"`, etc.) |
| **Lisasri User Profile** | `users/lisasri/home.nix` | User-specific apps for the secondary user account |

---

## 5. Flake & Dependency Management

- **Inputs Following `nixpkgs`**: All flake inputs must follow the primary `nixpkgs` input when possible (`inputs.nixpkgs.follows = "nixpkgs"`) to avoid duplicate package builds and store bloat.
- **External Flakes**:
  - `nix-darwin`: macOS system management (`darwinConfigurations.work-mac`).
  - `mac-app-util`: macOS app linking helpers for nix-darwin.
  - `lazyvim`: LazyVim Home Manager module (shared via `common.nix`).
  - `antigravity-nix`: Google Antigravity CLI and IDE.
  - `codex-cli-nix`: SadJow's Codex CLI.
  - `dms`: DankMaterialShell (`github:AvengeMedia/DankMaterialShell`).
  - `noctalia`: Noctalia shell (`github:noctalia-dev/noctalia`).
  - `zen-browser`: Zen Browser flake.
- **Flake Commands**:
  - Update a single input: `nix flake lock --update-input <input_name>`
  - Check flake evaluation: `nix flake check`
  - Show flake outputs: `nix flake show`

---

## 6. Inviolable AI Agent Rules & Pitfalls

### Rule 1: The Git Staging Invariant (CRITICAL)
Nix Flakes strictly ignore any file that is not tracked by Git.
If you create any new file (e.g. `users/santhosh/modules/new-feature.nix`), you **MUST** run:
```bash
git add -N <new-file-path>
```
If you do not run `git add -N`, Nix evaluation will fail with `getting status of '...': No such file or directory`.

### Rule 2: Build Before Switch (NEVER switch untested changes)
Always verify the build in a sandbox without activating it:
```bash
# 1. Test build the host configuration
sudo nixos-rebuild build --flake .#thinkpad

# 2. Only after build succeeds, switch to activate
sudo nixos-rebuild switch --flake .#thinkpad
```
Never execute `nixos-rebuild switch` directly on unverified code.

### Rule 3: Nix & Lua Formatting Rules
- **Nix code**: Use 2-space indentation, trailing semicolons, and multi-line attribute sets. Format all Nix files using:
  ```bash
  nix fmt
  ```
- **Lua code**: Format Hyprland Lua configuration using `stylua`:
  ```bash
  stylua users/santhosh/modules/hypr/
  ```

### Rule 4: Statix Linting Cleanliness
Run static analysis before finalizing changes:
```bash
statix check .
```
Avoid repeated keys in attribute sets (e.g. write `boot = { loader = ...; kernelPackages = ...; };` rather than repeated top-level `boot.loader = ...; boot.kernelPackages = ...;` where appropriate).

### Rule 5: Secrets & Unfree License Hygiene
- **Never commit secrets**: Do not hardcode SSH keys, passwords, tokens, or private keys. 1Password is integrated on this system for credential management.
- **Unfree packages**: Unfree packages are enabled globally on the host (`nixpkgs.config.allowUnfree = true` in `configuration.nix`) and handled via `allowUnfreePredicate` in user modules where necessary.

### Rule 6: Rollback & Recovery
If a switch or build leaves the system in a bad state:
- To rollback system generation: `sudo nixos-rebuild switch --rollback`
- To inspect systemd failure logs: `journalctl -xeu <service-name>` or `journalctl --user -xeu <service-name>`
- To inspect Hyprland crash/session logs: `hyprctl instances` or `cat $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log`

---

## 7. Step-by-Step Verification Protocol for AI Agents

Whenever making any code changes in this repository, follow this exact sequence:

1. **Stage New Files** (if any files were created):
   ```bash
   git add -N <new_files>
   ```
2. **Format Code**:
   ```bash
   nix fmt
   ```
3. **Lint Expressions**:
   ```bash
   statix check .
   ```
4. **Evaluate Flake**:
   ```bash
   nix flake check
   ```
5. **Dry Build**:
   ```bash
   sudo nixos-rebuild build --flake .#thinkpad
   ```
6. **Commit Message**:
   Use short, imperative commit subjects (e.g. `add localsend and update screenshot keybind`, `feat(dms): remove version pinning`). Limit each commit to one logical change.
