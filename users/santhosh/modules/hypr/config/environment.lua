hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("NIXOS_OZONE_WL", "1")
hl.env("GDK_BACKEND", "wayland")
-- Let hyprpolkitagent own the agent slot (DMS would otherwise register first).
hl.env("DMS_DISABLE_POLKIT", "1")

hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("XCURSOR_SIZE", "24")

hl.exec_cmd(
	"sh -c '"
		.. "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE DISPLAY "
		.. "&& systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE DISPLAY "
		.. "&& systemctl --user start hyprland-session.target "
		-- Portal + Walker + Elephant + polkit must start AFTER Wayland is imported
		-- (xdph fails with \"Couldn't connect to a wayland compositor\" if too early).
		.. "&& systemctl --user reset-failed "
		.. "xdg-desktop-portal-hyprland.service xdg-desktop-portal.service "
		.. "hyprpolkitagent.service snappy-switcher.service 2>/dev/null || true "
		.. "&& systemctl --user restart --no-block "
		.. "xdg-desktop-portal-hyprland.service xdg-desktop-portal.service "
		.. "elephant.service walker-ensure.service hyprpolkitagent.service snappy-switcher.service'"
)
