-- hyprland @ windowrules
-- Wiki: https://wiki.hypr.land/Configuring/Basics/Window-Rules/ - https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Smart gaps
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0, rounding = 0 })

hl.window_rule({
	name = "Suppress maximize events",
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})

hl.window_rule({
	name = "Fix xwayland drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
	},
	no_initial_focus = true,
	no_anim = true,
})

hl.window_rule({
	name = "Fix xwayland blur",
	match = {
		xwayland = true,
		float = true,
	},
	opacity = "1.0 override",
	no_blur = true,
})

-- Opacity
hl.window_rule({
	match = { class = "^(dev.zed.Zed|jetbrains-idea|com.github.th_ch.youtube_music)$" },
	opacity = "0.9 override",
})
hl.window_rule({ match = { title = "^(superfile)$" }, opacity = "0.8 override" })
hl.window_rule({ match = { class = "^(gimp)$" }, opacity = "1.0 override 1.0 override 1.0 override" })

-- Floating
hl.window_rule({ match = { class = "^(file-jpeg|com.gabm.satty)$" }, float = true })
hl.window_rule({ match = { class = "^(X|x)dg-desktop-portal.*" }, float = true })
hl.window_rule({ match = { class = "^(steam)$", title = "^(steam)?.*" }, float = true })
hl.window_rule({ match = { class = "^(org.gnome.Calculator)$" }, size = { 496, 616 }, float = true })
-- TODO: Fix float center by disabling for empty classes and titles
-- hl.window_rule({ match = { float = true, class = "negative:^$", title = "negative:^$" }, center = true })
