local constants = require("config.constants")

local main_mod = constants.main_mod
local ipc = constants.ipc
local shell = constants.shell

local dirs = {
	{ key = "h", arrow = "left", dir = "left", short = "l" },
	{ key = "j", arrow = "down", dir = "down", short = "d" },
	{ key = "k", arrow = "up", dir = "up", short = "u" },
	{ key = "l", arrow = "right", dir = "right", short = "r" },
}

--------------------------------------------------------------------
-- Applications
--------------------------------------------------------------------
hl.bind(main_mod .. " + Return", hl.dsp.exec_cmd("ghostty"), { description = "Terminal" })
hl.bind(main_mod .. " + SHIFT + Return", hl.dsp.exec_cmd("zen"), { description = "Browser" })
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd("zen"), { description = "Browser" })
hl.bind(main_mod .. " + SHIFT + B", hl.dsp.exec_cmd("zen --private-window"), { description = "Browser (private)" })
hl.bind(main_mod .. " + E", hl.dsp.exec_cmd("nautilus"), { description = "Files" })
hl.bind(main_mod .. " + SHIFT + F", hl.dsp.exec_cmd("nautilus"), { description = "Files" })
hl.bind(main_mod .. " + I", hl.dsp.exec_cmd("codium"), { description = "Editor" })
hl.bind(main_mod .. " + SHIFT + N", hl.dsp.exec_cmd("codium"), { description = "Editor" })
hl.bind(main_mod .. " + SHIFT + slash", hl.dsp.exec_cmd("1password"), { description = "1Password" })
-- Nix telegram-desktop exposes the binary as "Telegram"
hl.bind(main_mod .. " + SHIFT + G", hl.dsp.exec_cmd("Telegram"), { description = "Telegram" })

-- Floating TUIs / tools menu
hl.bind(main_mod .. " + SHIFT + T", hl.dsp.exec_cmd("floating-tui btop --force-utf"), {
	description = "Activity (btop)",
})
hl.bind(main_mod .. " + SHIFT + ALT + G", hl.dsp.exec_cmd("floating-tui lazygit"), { description = "Lazygit" })
hl.bind(main_mod .. " + SHIFT + Space", hl.dsp.exec_cmd("walker -s tools"), { description = "Tools menu" })

--------------------------------------------------------------------
-- Launcher (Walker) + shell chrome
--------------------------------------------------------------------
hl.bind(main_mod .. " + Space", hl.dsp.exec_cmd("walker"), { description = "Walker launcher" })
-- Super+Tab: cross-workspace window/app switcher (Walker windows provider)
hl.bind(main_mod .. " + Tab", hl.dsp.exec_cmd("walker -s switcher"), {
	description = "App switcher (all workspaces)",
})
hl.bind(main_mod .. " + CTRL + L", hl.dsp.exec_cmd("hyprlock"), { description = "Lock" })
hl.bind(main_mod .. " + CTRL + N", hl.dsp.exec_cmd("nightlight-toggle"), {
	description = "Toggle nightlight",
})

--------------------------------------------------------------------
-- Window management
--------------------------------------------------------------------
hl.bind(main_mod .. " + W", hl.dsp.window.close(), { description = "Close window" })
hl.bind(main_mod .. " + Q", hl.dsp.window.close(), { description = "Close window" })
-- Reload Lua/config safely (never exit the compositor from a chord)
hl.bind(main_mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"), { description = "Reload Hyprland" })

hl.bind(main_mod .. " + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle float" })
hl.bind(main_mod .. " + U", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle float" })
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo(), { description = "Pseudo tile" })
-- Flip split orientation in dwindle only (errors on scrolling otherwise)
hl.bind(main_mod .. " + J", function()
	local workspace = hl.get_active_workspace()
	if not workspace or workspace.tiled_layout ~= "dwindle" then
		return
	end
	hl.dispatch(hl.dsp.layout("togglesplit"))
end, { description = "Toggle split orientation (dwindle)" })
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Fullscreen" })
hl.bind(main_mod .. " + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Maximize" })
-- Float + pin so the window follows you across workspaces (video/chat/docs)
hl.bind(main_mod .. " + O", hl.dsp.exec_cmd("hypr-window-pop"), { description = "Pop / pin window" })
-- Per-workspace layout cycle (Hyprland 0.57: keyword general:layout does NOT work)
hl.bind(main_mod .. " + SHIFT + L", function()
	local workspace = hl.get_active_workspace()
	if not workspace then
		return
	end
	local current = workspace.tiled_layout or "dwindle"
	local next_layout = current == "dwindle" and "scrolling" or "dwindle"
	hl.workspace_rule({ workspace = workspace.name, layout = next_layout })
	hl.notification.create({
		text = "Workspace " .. tostring(workspace.name) .. " → " .. next_layout,
		timeout = 2500,
	})
end, { description = "Cycle workspace layout (dwindle/scrolling)" })

-- Groups = tabbed stack inside one tile (same workspace only)
hl.bind(main_mod .. " + G", hl.dsp.group.toggle(), { description = "Toggle group" })
hl.bind(main_mod .. " + ALT + G", hl.dsp.window.move({ out_of_group = true }), {
	description = "Move out of group",
})
-- Alt+Tab cycles group tabs (macOS Command+` vibe within a tile)
hl.bind("ALT + Tab", hl.dsp.group.next(), { description = "Next in group" })
hl.bind("ALT + SHIFT + Tab", hl.dsp.group.prev(), { description = "Prev in group" })
hl.bind(main_mod .. " + CTRL + left", hl.dsp.group.prev(), { description = "Prev in group" })
hl.bind(main_mod .. " + CTRL + right", hl.dsp.group.next(), { description = "Next in group" })

--------------------------------------------------------------------
-- Vim-style + arrow focus / swap / resize / group join
--------------------------------------------------------------------
for _, d in ipairs(dirs) do
	hl.bind(main_mod .. " + " .. d.key, hl.dsp.focus({ direction = d.dir }), {
		description = "Focus " .. d.dir,
	})
	hl.bind(main_mod .. " + " .. d.arrow, hl.dsp.focus({ direction = d.dir }), {
		description = "Focus " .. d.dir,
	})

	hl.bind(main_mod .. " + SHIFT + " .. d.key, hl.dsp.window.swap({ direction = d.dir }), {
		description = "Swap " .. d.dir,
	})
	hl.bind(main_mod .. " + SHIFT + " .. d.arrow, hl.dsp.window.swap({ direction = d.dir }), {
		description = "Swap " .. d.dir,
	})

	hl.bind(main_mod .. " + ALT + " .. d.key, hl.dsp.window.move({ into_group = d.short }), {
		description = "Move into group " .. d.dir,
	})
	hl.bind(main_mod .. " + ALT + " .. d.arrow, hl.dsp.window.move({ into_group = d.short }), {
		description = "Move into group " .. d.dir,
	})
end

-- Keyboard resize: Super+Ctrl+hjkl (more reliable than =/- on many layouts)
hl.bind(
	main_mod .. " + CTRL + h",
	hl.dsp.window.resize({ x = -80, y = 0, relative = true }),
	{ description = "Shrink width", repeating = true }
)
hl.bind(
	main_mod .. " + CTRL + l",
	hl.dsp.window.resize({ x = 80, y = 0, relative = true }),
	{ description = "Grow width", repeating = true }
)
hl.bind(
	main_mod .. " + CTRL + k",
	hl.dsp.window.resize({ x = 0, y = -80, relative = true }),
	{ description = "Shrink height", repeating = true }
)
hl.bind(
	main_mod .. " + CTRL + j",
	hl.dsp.window.resize({ x = 0, y = 80, relative = true }),
	{ description = "Grow height", repeating = true }
)
-- Also keep =/- without relying on Shift for vertical
hl.bind(
	main_mod .. " + equal",
	hl.dsp.window.resize({ x = 80, y = 0, relative = true }),
	{ description = "Grow width", repeating = true }
)
hl.bind(
	main_mod .. " + minus",
	hl.dsp.window.resize({ x = -80, y = 0, relative = true }),
	{ description = "Shrink width", repeating = true }
)
hl.bind(
	main_mod .. " + SHIFT + equal",
	hl.dsp.window.resize({ x = 0, y = 80, relative = true }),
	{ description = "Grow height", repeating = true }
)
hl.bind(
	main_mod .. " + SHIFT + minus",
	hl.dsp.window.resize({ x = 0, y = -80, relative = true }),
	{ description = "Shrink height", repeating = true }
)

-- Super + mouse: LMB move, RMB resize, Alt+LMB resize fallback
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })
hl.bind(main_mod .. " + ALT + mouse:272", hl.dsp.window.resize(), {
	mouse = true,
	description = "Resize window (Alt+LMB)",
})
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next workspace" })
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Prev workspace" })

--------------------------------------------------------------------
-- Workspaces (1–9). Super+0 = previous workspace (Omarchy-style "back").
--------------------------------------------------------------------
for i = 1, 9 do
	local ws = tostring(i)
	hl.bind(main_mod .. " + " .. ws, hl.dsp.focus({ workspace = ws }), {
		description = "Workspace " .. ws,
	})
	hl.bind(main_mod .. " + SHIFT + " .. ws, hl.dsp.window.move({ workspace = ws, follow = true }), {
		description = "Move to workspace " .. ws,
	})
	hl.bind(
		main_mod .. " + SHIFT + ALT + " .. ws,
		hl.dsp.window.move({ workspace = ws, follow = false }),
		{ description = "Silent move to workspace " .. ws }
	)
end
hl.bind(main_mod .. " + 0", hl.dsp.focus({ workspace = "previous" }), {
	description = "Previous workspace",
})
hl.bind(main_mod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "previous", follow = true }), {
	description = "Move to previous workspace",
})

-- Scratchpad overlay
hl.bind(main_mod .. " + S", hl.dsp.workspace.toggle_special("scratchpad"), {
	description = "Toggle scratchpad",
})
hl.bind(
	main_mod .. " + ALT + S",
	hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }),
	{ description = "Move to scratchpad" }
)

--------------------------------------------------------------------
-- Clipboard
--------------------------------------------------------------------
hl.bind(main_mod .. " + C", hl.dsp.send_shortcut({ mods = "CONTROL", key = "Insert" }), {
	description = "Universal copy",
})
hl.bind(main_mod .. " + V", hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" }), {
	description = "Universal paste",
})
hl.bind(main_mod .. " + X", hl.dsp.send_shortcut({ mods = "CONTROL", key = "X" }), {
	description = "Universal cut",
})

--------------------------------------------------------------------
-- Dictation (Voxtype) — no separate GUI app; daemon + OSD/notifications
--------------------------------------------------------------------
hl.bind(main_mod .. " + CTRL + X", hl.dsp.exec_cmd("voxtype record toggle"), {
	description = "Toggle dictation",
})
hl.bind(main_mod .. " + CTRL + SHIFT + X", hl.dsp.exec_cmd("voxtype record cancel"), {
	description = "Cancel dictation",
})
hl.bind(main_mod .. " + CTRL + ALT + X", hl.dsp.exec_cmd("floating-tui voxtype configure"), {
	description = "Voxtype configure TUI",
})
hl.bind("F9", hl.dsp.exec_cmd("voxtype record start"), {
	description = "Dictation start (hold)",
	locked = true,
})
hl.bind("F9", hl.dsp.exec_cmd("voxtype record stop"), {
	description = "Dictation stop (release)",
	release = true,
	locked = true,
})

--------------------------------------------------------------------
-- Capture
--------------------------------------------------------------------
hl.bind(main_mod .. " + Print", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"), {
	description = "Color picker",
})
hl.bind(main_mod .. " + CTRL + Print", hl.dsp.exec_cmd("hypr-ocr"), { description = "OCR region" })
hl.bind("ALT + Print", hl.dsp.exec_cmd("hypr-screenrecord-toggle"), {
	description = "Toggle screen recording",
})

--------------------------------------------------------------------
-- Shell-specific (DMS / Noctalia) — launcher/switcher are Walker
--------------------------------------------------------------------
if shell == "dms" then
	-- DMS parses ~/.config/hypr Lua binds into a searchable modal overlay
	hl.bind(main_mod .. " + K", hl.dsp.exec_cmd(ipc .. "keybinds toggle hyprland"), {
		description = "Keybind cheatsheet (DMS)",
	})
	hl.bind("ALT + Space", hl.dsp.exec_cmd(ipc .. "spotlight-bar toggle"), {
		description = "DMS spotlight bar",
	})
	hl.bind(main_mod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings focusOrToggle"), {
		description = "Settings",
	})
	hl.bind(main_mod .. " + N", hl.dsp.exec_cmd(ipc .. "notifications toggle"), {
		description = "Notifications",
	})
	hl.bind("ALT + F4", hl.dsp.exec_cmd(ipc .. "powermenu toggle"), { description = "Power menu" })
	hl.bind(main_mod .. " + SHIFT + C", hl.dsp.exec_cmd(ipc .. "clipboard toggle"), {
		description = "Clipboard history",
	})
	hl.bind(main_mod .. " + SHIFT + Tab", hl.dsp.exec_cmd(ipc .. "hypr toggleOverview"), {
		description = "Workspace overview",
	})

	hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "audio increment 3"), {
		locked = true,
		repeating = true,
	})
	hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "audio decrement 3"), {
		locked = true,
		repeating = true,
	})
	hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "audio mute"), { locked = true })
	hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. "audio micmute"), { locked = true })
	hl.bind(
		"XF86MonBrightnessUp",
		hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]),
		{ locked = true, repeating = true }
	)
	hl.bind(
		"XF86MonBrightnessDown",
		hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]),
		{ locked = true, repeating = true }
	)

	hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. "mpris playPause"), { locked = true })
	hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. "mpris playPause"), { locked = true })
	hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. "mpris next"), { locked = true })
	hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. "mpris previous"), { locked = true })

	hl.bind("Print", hl.dsp.exec_cmd("dms screenshot"), { description = "Screenshot" })
	hl.bind("SHIFT + Print", hl.dsp.exec_cmd("dms screenshot full"), { description = "Screenshot full" })
	hl.bind(main_mod .. " + CTRL + ALT + C", hl.dsp.exec_cmd("dms screenshot"), { description = "Screenshot" })
elseif shell == "noctalia" then
	hl.bind(main_mod .. " + K", hl.dsp.exec_cmd("hypr-keybinds-help"), {
		description = "Keybind cheatsheet",
	})
	hl.bind(main_mod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"), {
		description = "Settings",
	})
	hl.bind(main_mod .. " + SHIFT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"), {
		description = "Window switcher",
	})

	hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
	hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
	hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))
	hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
	hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))

	hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
	hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
	hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

	hl.bind("SHIFT + Print", hl.dsp.exec_cmd("sh -c 'grimblast copy screen && notify-send \"Copied Screen\"'"))
	hl.bind(
		"Print",
		hl.dsp.exec_cmd(
			[[sh -c 'FILE=~/Pictures/Screenshots_$(date +%Y-%m-%d_%H-%M-%S).png && grimblast save screen $FILE && notify-send "Screenshot saved"']]
		)
	)
else
	hl.bind(main_mod .. " + K", hl.dsp.exec_cmd("hypr-keybinds-help"), {
		description = "Keybind cheatsheet",
	})
end
