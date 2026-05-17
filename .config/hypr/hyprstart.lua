-- hyprland @ autostart
-- Wiki: https://wiki.hypr.land/Configuring/Basics/Autostart/

local uwsm = "uwsm app -- "

hl.on("hyprland.start", function()
	hl.exec_cmd(uwsm .. "udiskie -s")
	hl.exec_cmd(uwsm .. "awww-daemon")
	hl.exec_cmd(uwsm .. "mpDris2 -j")
	hl.exec_cmd(uwsm .. "~/.config/hypr/scripts/workspace-watcher")
	hl.exec_cmd(uwsm .. "~/.config/hypr/scripts/wallpaper-daemon")
end)
