hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")

-- Omarchy shell: shell.qml derives every path from OMARCHY_PATH, and its
-- widgets shell out to omarchy-* helpers in the checkout's bin/.
-- Upstream sets these via uwsm; we launch Hyprland directly, so do it here.
local omarchy = os.getenv("HOME") .. "/omarchy"
hl.env("OMARCHY_PATH", omarchy)
hl.env("PATH", omarchy .. "/bin:" .. os.getenv("PATH"))
