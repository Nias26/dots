-- hyprland @ autostart
-- Wiki: https://wiki.hypr.land/Configuring/Basics/Autostart/

local uwsm = "uwsm app -- "

hl.on("hyprland.start", function()
	hl.exec_cmd(uwsm .. "awww-daemon")
	hl.exec_cmd(uwsm .. "mpDris2 -j")
	-- hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
	-- hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'")
	-- hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'")
	hl.exec_cmd("tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE '$HYPRLAND_INSTANCE_SIGNATURE'")
end)
