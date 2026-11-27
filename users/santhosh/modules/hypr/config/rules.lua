-- Floating TUI windows (btop, lazygit, keybind help, voxtype configure)
hl.window_rule({
	name = "floating-tui",
	match = { class = "floating-tui" },
	float = true,
	center = true,
	size = "80% 80%",
})

-- Satty screenshot annotation (GTK app-id com.gabm.satty / satty)
hl.window_rule({
	name = "satty-float",
	match = { class = "com.gabm.satty|satty" },
	float = true,
	center = true,
})

-- Zen/Firefox Picture-in-Picture: floating and pinned, visible on all
-- workspaces. Size is only a seed; Firefox remembers the size you drag.
hl.window_rule({
	name = "pip",
	match = { initial_title = "Picture-in-Picture" },
	float = true,
	pin = true,
	size = "480 270",
})

-- Quake console (Super+`): one persistent console on special:console.
-- Terminal is chosen by custom.desktop.quakeConsole.terminal.
-- kitty carries a real Wayland class:
hl.window_rule({
	name = "quake-console",
	match = { class = "quake-console" },
	float = true,
	center = true,
	size = "70% 60%",
	workspace = "special:console",
	dim_around = true,
})

-- Ghostty's Wayland app-id is fixed, so its console is matched by spawn title:
hl.window_rule({
	name = "quake-console-ghostty",
	match = { initial_title = "Quake Console" },
	float = true,
	center = true,
	size = "70% 60%",
	workspace = "special:console",
	dim_around = true,
})

hl.workspace_rule({
	workspace = "special:console",
	gaps_in = 5,
	gaps_out = 10,
})

hl.workspace_rule({
	workspace = "special:scratchpad",
	gaps_in = 5,
	gaps_out = 10,
})

-- Ignore maximize requests from toolkits
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})
