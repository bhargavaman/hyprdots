local vars = require("modules.variables")

local function exec_once(cmd)
	hl.exec_cmd(cmd)
end

hl.on("hyprland.start", function()
	exec_once("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	exec_once("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	exec_once("hyprpaper")
	-- exec_once("waybar")
	exec_once("quickshell -p /home/ad/config_bak/quickshell/shell.qml")

	exec_once("wl-paste --type text --watch cliphist store")
	exec_once("wl-paste --type image --watch cliphist store")

	exec_once("[workspace 1] " .. vars.zenBrowser)
	exec_once("[workspace 2 silent] " .. vars.terminal)
	exec_once("[workspace 3 silent] " .. vars.note)

	-- exec_once("hyprpm reload -n")
	exec_once("hypridle")

	-- Banana
	-- exec_once("hyprctl setcursor 'Banana' 40")
	-- exec_once("gsettings set org.gnome.desktop.interface cursor-theme 'Banana'")
	-- exec_once("gsettings set org.gnome.desktop.interface cursor-size 40")
end)
