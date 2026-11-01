# Hyprland keybinds (Omarchy-inspired)

Super is the Windows / Command key.

## Tab chords (important)

| Keys | Action |
| --- | --- |
| Super + Tab | **App switcher** — Walker lists windows across all workspaces |
| Alt + Tab | **Next window in group** (tabbed stack in one tile) |
| Alt + Shift + Tab | Previous in group |
| Super + Shift + Tab | DMS workspace overview / Noctalia switcher |

## Shortcuts overlay (no custom plugin needed)

| Shell | Super + K |
| --- | --- |
| DMS | Native modal: `dms ipc call keybinds toggle hyprland` (parses your Lua binds) |
| Noctalia / none | Floating `KEYBINDS.md` via Ghostty |

Walker tools menu (`Super + Shift + Space` or `!`) is shell-agnostic. A custom DMS/Quickshell plugin is optional later if you want macOS Command-Tab *hold-to-cycle HUD* (e.g. hypr-app-switcher).

## Layout

`Super + Shift + L` toggles **this workspace** between dwindle and scrolling via `workspace_rule` (Hyprland 0.57 ignores `hyprctl keyword general:layout`).

`Super + J` only works on dwindle (flips split orientation).

## Launch

| Keys | Action |
| --- | --- |
| Super + Space | Walker launcher |
| Super + Shift + Space / `!` | Tools menu |
| `@query` | Web search |
| Super + Return | Terminal |
| Super + Shift + T | btop (`--force-utf`) |
| Super + K | Keybind cheatsheet |

## Voxtype

Focus a text field → `Super + Ctrl + X` toggle (or hold F9) → speak → toggle/release. Configure: `Super + Ctrl + Alt + X`.
