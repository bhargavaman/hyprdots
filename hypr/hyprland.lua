-- require("modules.multi-monitor")
require("modules.monitor")
require("modules.autostart")
require("modules.rules")
require("modules.env")
require("modules.general")
require("modules.input")
require("modules.mics")
require("modules.decoration")
-- require("modules.animation(vertical)")
require("modules.animation(horizontal)")
require("modules.binds")
-- require("modules.hyprcursor")
-- require("modules.plugin")

-- Acheron theme: border colors, and gum's colors for apps Hyprland launches.
-- Written by acheron-theme-set into the applied theme; a theme may ship its own
-- hyprland.lua, so each file is loaded defensively.
for _, file in ipairs({ "hyprland.lua", "gum_env.lua" }) do
	local path = os.getenv("HOME") .. "/.config/acheron/theme/current/" .. file
	local handle = io.open(path, "r")
	if handle then
		handle:close()
		pcall(dofile, path)
	end
end
