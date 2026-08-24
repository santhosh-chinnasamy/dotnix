hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("GDK_BACKEND", "wayland")

hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("XCURSOR_SIZE", "24")

hl.config({
    exec_once = {
        "dbus-update-activation-environment --systemd --all",
        "systemctl --user import-environment --all",
        "systemctl --user start hyprland-session.target",
    },
})
