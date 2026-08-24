# Repository Guidelines

## Project Structure & Module Organization
This repository is a Nix flake for a single `thinkpad` host with per-user Home Manager profiles.

- `flake.nix` defines inputs, the formatter, and `nixosConfigurations.thinkpad`.
- `hosts/thinkpad/` contains host-specific NixOS entrypoints such as `default.nix`, `configuration.nix`, and `hardware-configuration.nix`.
- `modules/packages/` holds shared system package modules, split into `cli.nix` and `desktop.nix`.
- `users/santhosh/` and `users/lisasri/` contain Home Manager configs. Santhosh-specific feature modules live under `users/santhosh/modules/`.
- Hyprland Lua assets are stored in `users/santhosh/modules/hypr/config/`.

## Build, Test, and Development Commands
Run commands from the repository root.

- `nix fmt` formats all Nix files using the flake formatter (`nixfmt-rfc-style`).
- `statix check .` runs static analysis for Nix expressions.
- `nix flake check` evaluates the flake and catches integration issues early.
- `sudo nixos-rebuild build --flake .#thinkpad` builds the system without switching.
- `sudo nixos-rebuild switch --flake .#thinkpad` applies the host configuration.

Use `build` before `switch` when changing shared modules or boot-related settings.

## Coding Style & Naming Conventions
Follow existing Nix style in the repo:

- Use 2-space indentation and trailing semicolons.
- Keep attribute sets and lists multi-line when they contain more than a few entries.
- Prefer descriptive module names like `hyprland.nix`, `desktop.nix`, or `aliases.nix`.
- Group related options together instead of scattering a program’s settings across files.

Format with `nix fmt` before submitting changes.

## Testing Guidelines
There is no dedicated unit test suite. Validation is configuration-focused:

- Run `nix flake check` for every change.
- Run `statix check .` for linting.
- For host changes, verify with `sudo nixos-rebuild build --flake .#thinkpad`.
- For Home Manager-only edits, ensure the affected user module still evaluates through the host build.

## Commit & Pull Request Guidelines
Recent commits use short, imperative subjects such as `add wdisplays display manager` and `fix noctalia shell`.

- Keep commit titles concise and action-first.
- Limit each commit to one logical change.
- In pull requests, include the affected area (`host`, `user`, `Hyprland`, `packages`), the validation commands you ran, and screenshots only for visible desktop changes.

## Security & Configuration Tips
Do not commit secrets, device-specific credentials, or generated state. Keep hardware-specific changes isolated to `hosts/thinkpad/` and user-specific behavior inside the matching `users/<name>/` tree.
