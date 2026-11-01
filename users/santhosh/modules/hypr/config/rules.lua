-- Floating TUI windows (btop, lazygit, keybind help, voxtype configure)
hl.window_rule({
	name = "floating-tui",
	match = { class = "floating-tui" },
	float = true,
	center = true,
	size = "80% 80%",
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
