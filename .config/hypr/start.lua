-- hyprland @ autostart
-- Wiki: https://wiki.hypr.land/Configuring/Basics/Autostart/

local uwsm = "uwsm app -- "

hl.on("hyprland.start", function()
	hl.exec_cmd(uwsm .. "awww-daemon")
	-- hl.exec_cmd("~/.config/hypr/scripts/awww-manager")
	-- hl.exec_cmd("mpDris2 -j")
	-- hl.exec_cmd("udiskie -s")
	-- hl.exec_cmd("hypridle")
	-- hl.exec_cmd("mako")
	-- hl.exec_cmd("~/.config/hypr/scripts/workspace-watcher")
	-- hl.exec_cmd("~/.config/hypr/scripts/battery-monitor")
	-- hl.exec_cmd("waybar")
	-- hl.exec_cmd("vicinae server")
	-- hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
	-- hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'")
	-- hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'")
	hl.exec_cmd("tmux new-session -d")
	hl.exec_cmd("tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE '$HYPRLAND_INSTANCE_SIGNATURE'")
end)
