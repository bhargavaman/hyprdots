hl.config({
	decoration = {
		dim_special = 0.2,
		rounding = 10,
    active_opacity = 1,
    inactive_opacity = 1,
		blur = {
			enabled = true,
			size = 5,
			popups = true,
			passes = 4,
			new_optimizations = true,
			vibrancy = 0.4,
			ignore_opacity = true,
			special = true,
		},
		shadow = {
			enabled = true,
			range = 200,
			render_power = 4,
			color = "rgba(00000066)",
			offset = { 0, -10 },
			-- scale = 0.95,
		},
	},
})
