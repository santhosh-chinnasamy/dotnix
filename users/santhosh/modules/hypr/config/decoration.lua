hl.config({
    decoration = {
        rounding = 2,
        blur = {
            enabled = true,
            size = 3,
            passes = 0,
        },
        -- Modernized shadow configuration (top-level drop_shadow is deprecated)
        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
    },
})