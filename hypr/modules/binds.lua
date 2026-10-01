-- modules/binds.lua
--
-- One modifier per job, so every bind is guessable:
--
--   SUPER + key               apps, spotlight, focus, window state
--   SUPER + SHIFT + key       move things (windows, columns, to workspace)
--   SUPER + CTRL + key        quickshell: bar, panels, menus, system
--   SUPER + ALT + key         theme & wallpaper
--   Print (+ SHIFT / SUPER)   screenshots
--   media keys                volume, player, brightness

local vars = require("modules.variables")

local mod = "SUPER"
local mods = "SUPER + SHIFT"
local modc = "SUPER + CTRL"
local moda = "SUPER + ALT"

local function bind(modifier, key, cmd)
	hl.bind(modifier .. " + " .. key, hl.dsp.exec_cmd(cmd))
end

local function bindDsp(modifier, key, dispatcher)
	hl.bind(modifier .. " + " .. key, dispatcher)
end

-- ── Apps (SUPER) ─────────────────────────────────────────────────
bind(mod, "T", vars.terminal)
bind(mod, "E", vars.terminal .. " -e " .. vars.fileManager)
bind(mod, "B", vars.zenBrowser)
bind(mod, "N", vars.note)
bind(mod, "SPACE", "quickshell ipc -p /home/ad/config_bak/quickshell call spotlight toggle")

-- ── Windows (SUPER) ──────────────────────────────────────────────
bindDsp(mod, "W", hl.dsp.window.close())
bindDsp(mod, "F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
bindDsp(mod, "V", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mod .. " + equal", hl.dsp.layout("colresize +0.1"))
hl.bind(mod .. " + minus", hl.dsp.layout("colresize -0.1"))

-- Focus: vim keys. Uses the scrolling layout's own focus so it follows
-- columns (the generic focus dispatcher doesn't).
hl.bind(mod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mod .. " + L", hl.dsp.layout("focus r"))
hl.bind(mod .. " + K", hl.dsp.layout("focus u"))
hl.bind(mod .. " + J", hl.dsp.layout("focus d"))

-- ── Move (SUPER + SHIFT) ─────────────────────────────────────────
hl.bind(mods .. " + H", hl.dsp.layout("swapcol l"))
hl.bind(mods .. " + L", hl.dsp.layout("swapcol r"))

-- ── Workspaces ───────────────────────────────────────────────────
-- SUPER + n: go to n (again: back to previous). SUPER + SHIFT + n: send window.
for i = 1, 10 do
	local key = tostring(i % 10)
	local ws = tostring(i)

	hl.bind(mod .. " + " .. key, function()
		local current = hl.get_active_workspace()
		if current ~= nil and current.id == i then
			hl.dispatch(hl.dsp.focus({ workspace = "previous" }))
		else
			hl.dispatch(hl.dsp.focus({ workspace = ws }))
		end
	end)

	hl.bind(mods .. " + " .. key, hl.dsp.window.move({ workspace = ws }))
end

hl.bind(mod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
hl.bind(mod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + bracketleft", hl.dsp.focus({ workspace = "e-1" }))

-- ── Mouse ────────────────────────────────────────────────────────
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── Quickshell & system (SUPER + CTRL) ───────────────────────────
local qs = "quickshell ipc -p /home/ad/config_bak/quickshell call "
-- Panels live on the full bar, so each one unwraps it first.
local function panel(name)
	return "sh -c '" .. qs .. "bar expand && " .. qs .. name .. " toggle'"
end

bind(modc, "V", qs .. "clipboard toggle")
bind(modc, "K", qs .. "passmanager toggle")

bind(modc, "B", qs .. "bar toggleExpanded")
-- Edit mode turns every bar widget into a drag handle; press again to exit.
bind(modc, "E", qs .. "bar editMode")
bind(modc, "T", "~/config_bak/waybar/scripts/toggle-trans.sh")
bind(
	modc,
	"R",
	'pkill -9 -f "quickshell -p $HOME/config_bak/quickshell" || quickshell -p $HOME/config_bak/quickshell &'
)

bind(modc, "P", panel("omarchy.power")) -- logout / reboot / shutdown
bind(modc, "N", panel("omarchy.network"))
bind(modc, "A", panel("omarchy.audio"))

bind(modc, "Escape", vars.terminal .. " -e " .. vars.taskManager)
bind(modc, "C", vars.colorpicker .. " -a")

-- ── Theme & wallpaper (SUPER + ALT) ──────────────────────────────
bind(moda, "T", "~/.config/acheron/bin/acheron-theme-switcher")
bind(moda, "B", "~/.config/acheron/bin/acheron-theme-bg-switcher")
bind(moda, "W", "$HOME/config_bak/rofi/wallselect/script.sh")
bind(moda, "R", "sh -c '~/.config/waybar/scripts/change-wallpaper.sh && hyprpaper'")

-- ── Screenshots (Print) ──────────────────────────────────────────
local shot_clip =
	'sh -c \'slurp | grim -g - /tmp/photo.png && wl-copy --type image/png < /tmp/photo.png && notify-send -w "Screenshot" "Screenshot copied to clipboard" -i /tmp/photo.png\''
local shot_file =
	'sh -c \'FILE=$HOME/Pictures/Screenshot/$(date +%m-%d-%H-%M-%S).png && grim -g "$(slurp)" "$FILE" && notify-send "Screenshot Saved" -i "$FILE"\''
local shot_vim =
	'sh -c \'~/work/side/vim-screenshot/vim-screenshot && sleep 1 && wl-copy --type image/png < /tmp/photo.png && notify-send -w "Screenshot" "Screenshot copied to clipboard" -i /tmp/photo.png\''

hl.bind("Print", hl.dsp.exec_cmd(shot_clip))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(shot_file))
hl.bind("SUPER + Print", hl.dsp.exec_cmd(shot_vim))
-- Same region-to-clipboard shot for keyboards without a Print key.
bind(mods, "S", shot_clip)

-- ── Volume ───────────────────────────────────────────────────────
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("sh -c 'pamixer -i 2 --allow-boost'"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("sh -c 'pamixer -d 2 --allow-boost'"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("sh -c 'pamixer -t '"))

-- ── Player ───────────────────────────────────────────────────────
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))

-- ── Brightness ───────────────────────────────────────────────────
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("sh -c 'brightnessctl set 2%- '"), { repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("sh -c 'brightnessctl set +2% '"), { repeating = true })
