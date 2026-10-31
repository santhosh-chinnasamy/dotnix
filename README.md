# dotnix

Nix flake for a personal **ThinkPad (NixOS)** and a work **Mac (nix-darwin)** — one repo, shared Home Manager baseline, host-specific desktops and apps.

## Hosts

| Flake output | System | Role |
| --- | --- | --- |
| `nixosConfigurations.thinkpad` | `x86_64-linux` | Personal laptop: Hyprland, DMS/Noctalia, full desktop |
| `darwinConfigurations.work-mac` | `aarch64-darwin` | Work Mac: Homebrew casks, Touch ID, shared CLI/shell |

## Layout

```text
.
├── flake.nix                 # Inputs + thinkpad / work-mac outputs
├── hosts/
│   ├── thinkpad/             # NixOS system, hardware, Podman, etc.
│   └── work-mac/             # nix-darwin + Homebrew
├── modules/packages/         # Shared system CLI / desktop packages (Linux)
└── users/
    ├── lisasri/              # Secondary NixOS user
    └── santhosh/
        ├── home.nix          # Linux: desktop apps, Hyprland, GTK
        ├── work-mac-home.nix # Darwin: username/home; imports common
        ├── config/aliases.nix
        └── modules/
            ├── common.nix    # Cross-platform shell, tools, editor
            ├── starship.nix
            └── …             # Hyprland, DMS, Noctalia, 1Password, …
```

Shell aliases live in [`users/santhosh/config/aliases.nix`](users/santhosh/config/aliases.nix).

## Quick start

Clone (or move) this repo to the same path on both machines:

```text
~/.config/dotnix
```

### ThinkPad (NixOS)

```bash
sudo nixos-rebuild build --flake .#thinkpad   # dry build first
sudo nixos-rebuild switch --flake .#thinkpad
```

### Work Mac (nix-darwin)

```bash
darwin-rebuild build --flake .#work-mac
darwin-rebuild switch --flake .#work-mac
```

## Shared vs host-specific

**Shared** ([`users/santhosh/modules/common.nix`](users/santhosh/modules/common.nix)):

- zsh + Oh My Zsh, Starship, direnv
- LazyVim / Neovim
- Cross-platform CLI (`lazygit`, `glab`, `claude-code`, `eza`, `bat`, …)
- Git identity and aliases

**ThinkPad-only** ([`users/santhosh/home.nix`](users/santhosh/home.nix) + Hyprland modules):

- Desktop apps, cursors/GTK, Hyprland Lua config
- DankMaterialShell / Noctalia via `custom.desktop.shell`

**Mac-only** ([`hosts/work-mac/default.nix`](hosts/work-mac/default.nix)):

- Homebrew casks, fonts, Touch ID sudo, `santhoshc` user

## Desktop (ThinkPad)

Hyprland is configured in **pure Lua** under `users/santhosh/modules/hypr/` (Home Manager’s `wayland.windowManager.hyprland` settings are disabled).

Switch the Wayland shell in `users/santhosh/home.nix`:

```nix
custom.desktop.shell = "dms"; # "dms" | "noctalia" | "none"
```

Details on shell IPC, keybinds, and agent rules: [`AGENTS.md`](AGENTS.md).

## Development workflow

1. New files must be visible to the flake: `git add -N <path>` (or `git add`).
2. Format: `nix fmt` (Lua under Hyprland: `stylua users/santhosh/modules/hypr/`).
3. Lint: `statix check .`
4. Evaluate: `nix flake check`
5. **Build before switch** on the target host (see Quick start).

Prefer short, imperative commits scoped to one logical change.

## Updating inputs

```bash
nix flake update                    # all inputs
nix flake update nix-darwin         # single input (example)
```

Keep new inputs on `inputs.nixpkgs.follows = "nixpkgs"` when the upstream flake allows it, to avoid duplicate nixpkgs graphs.

## Secrets & unfree

- Do not commit secrets, tokens, or private keys. Prefer 1Password (CLI/GUI wired in this flake).
- Unfree packages are allowed on both hosts (`nixpkgs.config.allowUnfree`).

## Further reading

- [`AGENTS.md`](AGENTS.md) — architecture map, Hyprland Lua rules, package placement, and verification protocol for contributors and coding agents.
