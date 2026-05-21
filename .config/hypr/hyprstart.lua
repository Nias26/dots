-- hyprland @ autostart
-- Wiki: https://wiki.hypr.land/Configuring/Basics/Autostart/

local uwsm = "uwsm app -- "

hl.on("hyprland.start", function()
	hl.exec_cmd(uwsm .. "awww-daemon")
	hl.exec_cmd(uwsm .. "mpDris2 -j")
end)
