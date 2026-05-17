-- hyprland @ settings
-- Wiki: https://wiki.hypr.land/Configuring/Basics/Variables/

hl.monitor({ output = "eDP-1", mode = "highres@highrr", position = "auto", scale = "auto" })
hl.monitor({
	output = "desc:ASUSTek COMPUTER INC VG279 LBLMQS024615",
	mode = "highres@highrr",
	position = "0x0",
	scale = "auto",
})
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto", mirror = "eDP-1" })

hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "3", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "4", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "9", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "10", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "special:magic", monitor = "HDMI-A-1" })

hl.permission({ binary = "/usr/(bin|local/bin)/grim", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })

--Ecosystem
hl.config({
	ecosystem = {
		no_update_news = true,
	},
})

-- General
hl.config({
	general = {
		border_size = 1,
		gaps_in = 2,
		gaps_out = 6,
		col = {
			active_border = "rgba(42BE65EE)",
			inactive_border = "rgba(393939ff)",
		},
		layout = "dwindle",
		allow_tearing = true,
		snap = {
			enabled = true,
		},
	},
})

-- Decoration
hl.config({
	decoration = {
		rounding = 5,
		rounding_power = 2,
		blur = {
			enabled = true,
			size = 3,
			passes = 3,
			ignore_opacity = true,
			new_optimizations = true,
			xray = true,
			popups = true,
		},
		shadow = {
			enabled = true,
			range = 4,
			render_power = 2,
			color = "rgba(1a1a1aee)",
		},
	},
})

-- Animations
hl.config({
	animations = {
		enabled = true,
		workspace_wraparound = false,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.79, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3.5, bezier = "easeOutQuint", style = "slidevert" })

-- Input
hl.config({
	input = {
		kb_layout = "us, it",
		follow_mouse = 2,
		float_switch_override_focus = 0,
		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Misc
hl.config({
	misc = {
		focus_on_activate = true,
		initial_workspace_tracking = 1,
		middle_click_paste = false,
	},
})

-- XWayland
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})
