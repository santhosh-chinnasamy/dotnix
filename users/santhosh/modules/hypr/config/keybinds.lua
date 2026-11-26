local constants = require("config.constants")

-- DMS's static cheatsheet parser only resolves plain string locals, not table
-- fields, so the main modifier stays a literal here. This is the single source
-- of truth: change the modifier here (and nowhere else) if it ever changes.
local main_mod = "SUPER"
local ipc = constants.ipc
local shell = constants.shell

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
-- Snappy Switcher: hold Super, tap Tab, release Super to focus.
hl.bind(main_mod .. " + Tab", hl.dsp.exec_cmd("snappy-switcher next --mod super"), {
	description = "App switcher",
})
hl.bind(main_mod .. " + SHIFT + Tab", hl.dsp.exec_cmd("snappy-switcher prev --mod super"), {
	description = "App switcher (reverse)",
})
-- Super+`: toggle the persistent quake-style console (one Ghostty on special:console)
hl.bind(main_mod .. " + grave", hl.dsp.exec_cmd("quake-console"), {
	description = "Toggle quake console",
})
-- Emoji / symbols via Walker (also type "." in the launcher)
hl.bind(main_mod .. " + period", hl.dsp.exec_cmd("walker -s symbols"), {
	description = "Emoji / symbols",
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
-- Reload Lua/config, then restart Snappy so the daemon reattaches.
hl.bind(
	main_mod .. " + SHIFT + R",
	hl.dsp.exec_cmd(
		"sh -c 'hyprctl reload; sleep 1; systemctl --user reset-failed snappy-switcher.service; systemctl --user restart snappy-switcher.service'"
	),
	{ description = "Reload Hyprland" }
)

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
	local next_layout = "dwindle"
	if current == "dwindle" then
		next_layout = "scrolling"
	elseif current == "scrolling" then
		next_layout = "master"
	end
	hl.workspace_rule({ workspace = workspace.name, layout = next_layout })
	hl.notification.create({
		text = "Workspace " .. tostring(workspace.name) .. " → " .. next_layout,
		timeout = 2500,
	})
end, { description = "Cycle workspace layout (dwindle/scrolling/master)" })

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
-- Written out explicitly (instead of an ipairs(dirs) loop) so DMS's static
-- cheatsheet parser can read the literal key combos for Super+K.
hl.bind(main_mod .. " + h", hl.dsp.focus({ direction = "left" }), { description = "Focus left" })
hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }), { description = "Focus left" })
hl.bind(main_mod .. " + j", hl.dsp.focus({ direction = "down" }), { description = "Focus down" })
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }), { description = "Focus down" })
hl.bind(main_mod .. " + k", hl.dsp.focus({ direction = "up" }), { description = "Focus up" })
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }), { description = "Focus up" })
hl.bind(main_mod .. " + l", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })

hl.bind(main_mod .. " + SHIFT + h", hl.dsp.window.swap({ direction = "left" }), { description = "Swap left" })
hl.bind(main_mod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }), { description = "Swap left" })
hl.bind(main_mod .. " + SHIFT + j", hl.dsp.window.swap({ direction = "down" }), { description = "Swap down" })
hl.bind(main_mod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }), { description = "Swap down" })
hl.bind(main_mod .. " + SHIFT + k", hl.dsp.window.swap({ direction = "up" }), { description = "Swap up" })
hl.bind(main_mod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }), { description = "Swap up" })
hl.bind(main_mod .. " + SHIFT + l", hl.dsp.window.swap({ direction = "right" }), { description = "Swap right" })
hl.bind(main_mod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }), { description = "Swap right" })

hl.bind(main_mod .. " + ALT + h", hl.dsp.window.move({ into_group = "l" }), { description = "Move into group left" })
hl.bind(main_mod .. " + ALT + left", hl.dsp.window.move({ into_group = "l" }), { description = "Move into group left" })
hl.bind(main_mod .. " + ALT + j", hl.dsp.window.move({ into_group = "d" }), { description = "Move into group down" })
hl.bind(main_mod .. " + ALT + down", hl.dsp.window.move({ into_group = "d" }), { description = "Move into group down" })
hl.bind(main_mod .. " + ALT + k", hl.dsp.window.move({ into_group = "u" }), { description = "Move into group up" })
hl.bind(main_mod .. " + ALT + up", hl.dsp.window.move({ into_group = "u" }), { description = "Move into group up" })
hl.bind(main_mod .. " + ALT + l", hl.dsp.window.move({ into_group = "r" }), { description = "Move into group right" })
hl.bind(
	main_mod .. " + ALT + right",
	hl.dsp.window.move({ into_group = "r" }),
	{ description = "Move into group right" }
)

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
-- Super+Shift+3/4/5 are Mac screenshots — use Super+Ctrl+N to move (all workspaces).
--------------------------------------------------------------------
for i = 1, 9 do
	local ws = tostring(i)
	hl.bind(main_mod .. " + " .. ws, hl.dsp.focus({ workspace = ws }), {
		description = "Workspace " .. ws,
	})
	hl.bind(main_mod .. " + CTRL + " .. ws, hl.dsp.window.move({ workspace = ws, follow = true }), {
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
hl.bind(main_mod .. " + CTRL + 0", hl.dsp.window.move({ workspace = "previous", follow = true }), {
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
-- Clipboard + Mac Option word-jump (Alt → Ctrl arrows)
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
-- Option+Left/Right word jump (GUI editors); terminals often already handle Alt.
hl.bind("ALT + left", hl.dsp.send_shortcut({ mods = "CONTROL", key = "Left" }), {
	description = "Word jump left (Option)",
})
hl.bind("ALT + right", hl.dsp.send_shortcut({ mods = "CONTROL", key = "Right" }), {
	description = "Word jump right (Option)",
})

--------------------------------------------------------------------
-- Dictation (Hex) — local voice dictation; Hyprland owns the hotkeys
--------------------------------------------------------------------
-- Hex's portal shortcuts get no key on Hyprland, so bind the bare names
-- (`hyprctl globalshortcuts` lists them). Keys set in Hex Settings are ignored.
hl.bind("ALT + Space", hl.dsp.global("anomaly.hex:dictation"), {
	description = "Dictation (Hex)",
})
hl.bind("F12", hl.dsp.global("anomaly.hex:capture"), {
	description = "Annotate (Hex)",
})
hl.bind("F10", hl.dsp.global("anomaly.hex:terminal-paste"), {
	description = "Dictation into terminal (Hex)",
})
hl.bind(main_mod .. " + CTRL + X", hl.dsp.exec_cmd("hex dictation toggle"), {
	description = "Toggle dictation",
})
hl.bind(main_mod .. " + CTRL + SHIFT + X", hl.dsp.exec_cmd("hex dictation cancel"), {
	description = "Cancel dictation",
})
hl.bind(main_mod .. " + CTRL + ALT + X", hl.dsp.exec_cmd("hex window show settings"), {
	description = "Hex settings",
})
hl.bind("F9", hl.dsp.exec_cmd("hex dictation start"), {
	description = "Dictation start (hold)",
	locked = true,
})
hl.bind("F9", hl.dsp.exec_cmd("hex dictation stop"), {
	description = "Dictation stop (release)",
	release = true,
	locked = true,
})

--------------------------------------------------------------------
-- Capture (Mac-like Super+Shift+3/4/5 + shell-agnostic Satty/Kooha)
--------------------------------------------------------------------
hl.bind(main_mod .. " + Print", hl.dsp.exec_cmd("pkill hyprpicker || hyprpicker -a"), {
	description = "Color picker",
})
hl.bind(main_mod .. " + CTRL + Print", hl.dsp.exec_cmd("hypr-ocr"), { description = "OCR region" })
hl.bind("ALT + Print", hl.dsp.exec_cmd("hypr-screenrecord-toggle"), {
	description = "Toggle screen recording",
})
-- macOS Command+Shift+3/4/5 equivalents
hl.bind(main_mod .. " + SHIFT + 3", hl.dsp.exec_cmd("hypr-screenshot-full"), {
	description = "Screenshot full → Satty",
})
hl.bind(main_mod .. " + SHIFT + 4", hl.dsp.exec_cmd("hypr-screenshot-region"), {
	description = "Screenshot region → Satty",
})
hl.bind(main_mod .. " + SHIFT + 5", hl.dsp.exec_cmd("kooha"), {
	description = "Capture / record (Kooha)",
})

--------------------------------------------------------------------
-- Shell-specific (DMS / Noctalia) — Super+Tab is Snappy; launcher is Walker
--------------------------------------------------------------------
if shell == "dms" then
	-- Grouped cheatsheet (all Hyprland binds, curated categories). The wrapper
	-- regenerates ~/.config/dms/cheatsheets/hyprland-grouped.json from
	-- `dms keybinds show hyprland`, then toggles that provider.
	hl.bind(main_mod .. " + K", hl.dsp.exec_cmd("hypr-keybinds-overlay"), {
		description = "Keybind cheatsheet (grouped)",
	})
	hl.bind(main_mod .. " + SHIFT + K", hl.dsp.exec_cmd("hypr-keybinds-help"), {
		description = "Keybind cheatsheet (markdown)",
	})
	hl.bind(main_mod .. " + ALT + Space", hl.dsp.exec_cmd(ipc .. "spotlight-bar toggle"), {
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
	-- Super+Shift+Tab is Snappy reverse; overview on Super+Ctrl+Tab.
	hl.bind(main_mod .. " + CTRL + Tab", hl.dsp.exec_cmd(ipc .. "hypr toggleOverview"), {
		description = "Workspace overview",
	})

	hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "audio increment 3"), {
		description = "Volume up",
		locked = true,
		repeating = true,
	})
	hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "audio decrement 3"), {
		description = "Volume down",
		locked = true,
		repeating = true,
	})
	hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "audio mute"), {
		description = "Mute audio",
		locked = true,
	})
	hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. "audio micmute"), {
		description = "Mute microphone",
		locked = true,
	})
	hl.bind(
		"XF86MonBrightnessUp",
		hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]),
		{ description = "Brightness up", locked = true, repeating = true }
	)
	hl.bind(
		"XF86MonBrightnessDown",
		hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]),
		{ description = "Brightness down", locked = true, repeating = true }
	)

	hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. "mpris playPause"), {
		description = "Play / pause",
		locked = true,
	})
	hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. "mpris playPause"), {
		description = "Play / pause",
		locked = true,
	})
	hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. "mpris next"), {
		description = "Next track",
		locked = true,
	})
	hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. "mpris previous"), {
		description = "Previous track",
		locked = true,
	})

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
	-- Super+Shift+Tab is Snappy; Noctalia switcher on Super+Ctrl+Tab.
	hl.bind(main_mod .. " + CTRL + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher"), {
		description = "Window switcher",
	})

	hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"), { description = "Volume up" })
	hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), {
		description = "Volume down",
	})
	hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { description = "Mute audio" })
	hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"), {
		description = "Brightness up",
	})
	hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"), {
		description = "Brightness down",
	})

	hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Play / pause" })
	hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { description = "Next track" })
	hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track" })

	hl.bind(
		"SHIFT + Print",
		hl.dsp.exec_cmd("sh -c 'grimblast copy screen && notify-send \"Copied Screen\"'"),
		{ description = "Screenshot full" }
	)
	hl.bind(
		"Print",
		hl.dsp.exec_cmd(
			[[sh -c 'FILE=~/Pictures/Screenshots_$(date +%Y-%m-%d_%H-%M-%S).png && grimblast save screen $FILE && notify-send "Screenshot saved"']]
		),
		{ description = "Screenshot" }
	)
else
	hl.bind(main_mod .. " + K", hl.dsp.exec_cmd("hypr-keybinds-help"), {
		description = "Keybind cheatsheet",
	})
end
