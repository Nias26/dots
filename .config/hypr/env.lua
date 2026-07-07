-- hyprland @ environment
-- Wiki: https://wiki.hypr.land/Configuring/Environment-variables

-- Using uwsm! See ~/.config/uwsm/env and env-hyprland

V_terminal = "kitty"
V_fileManager = V_terminal .. " -e elio"
V_taskManager = V_terminal .. " -e btop"
V_menu = "vicinae toggle"
V_browser = "zen-browser"
V_zed = "zeditor"
V_waybar = "waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/styles/style.css"
V_notify = "~/.config/hypr/scripts/notify"
