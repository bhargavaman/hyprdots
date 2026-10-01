hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 20,
		border_size = 0,
		col = {
			active_border = {
				colors = {
					"rgb(f5c2e7)",
					"rgb(000000)",
				},
				angle = 45,
			},
			inactive_border = {
				colors = {
					"rgb(242731)",
				},
			},
		},
		resize_on_border = true,
		extend_border_grab_area = 30,
		hover_icon_on_border = true,
		resize_corner = 5,
		allow_tearing = false,
		layout = "scrolling",
	},

	-- scrolling = {
	-- 	column_width = 0.49,
	-- },
	dwindle = {
		-- pseudotile = true
		preserve_split = true,
	},
	master = {
		new_status = inherit,
		new_on_top = true,
		new_on_active = "true",
		smart_resizing = true,
	},
})
