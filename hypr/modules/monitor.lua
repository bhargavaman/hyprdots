-- Matched by description, not connector name: this panel enumerates as eDP-1
-- (it was eDP-2 when this file was written), and an output name that matches
-- nothing leaves Hyprland on its auto scale of 1.5 -- which is why the scale
-- kept springing back to 1.5 after every reload.
--
-- 1.25 is the default: browsers and other apps are sized for it. The bar and
-- the terminal are enlarged on their own, not via the monitor scale.
hl.monitor({
	output = "desc:AU Optronics 0x7EAD",
	mode = "1920x1080@144",
	position = "auto",
	scale = 1.25,
})
