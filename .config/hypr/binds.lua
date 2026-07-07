-- hyprland @ Keybinds
-- Wiki: https://wiki.hypr.land/Configuring/Basics/Binds/

hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd(V_terminal))
hl.bind("SUPER + Return", hl.dsp.exec_cmd(V_terminal))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + E", hl.dsp.exec_cmd(V_fileManager))
hl.bind("SUPER + V", hl.dsp.window.float())
hl.bind("SUPER + R", hl.dsp.exec_cmd(V_menu))
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd(V_menu))
hl.bind("SUPER + P", hl.dsp.window.pin())
hl.bind("SUPER + K", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + J", hl.dsp.layout("swapsplit"))
hl.bind("SUPER + F", hl.dsp.exec_cmd(V_browser))
hl.bind("SUPER + Z", hl.dsp.exec_cmd("env " .. V_zed))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker | wl-copy"))
hl.bind("SUPER + X", hl.dsp.exec_cmd(V_taskManager))
hl.bind(
	"SUPER + SPACE",
	hl.dsp.exec_cmd(
		"hyprctl switchxkblayout all next && notify-send 'Switched Layout:' \"$(hyprctl devices -j | jq -r '.keyboards[] | .active_keymap' | head -n1 | cut -c1-2 | tr 'A-Z' 'a-z')\" -t 1000"
	)
)
-- hl.bind(
-- 	"XF86SelectiveScreenshot",
-- 	hl.dsp.exec_cmd("grim -g '$(slurp -w 0)'|wl-copy && notify-send 'Screenshot saved' -t 2000")
-- )
-- hl.bind("PRINT", hl.dsp.exec_cmd("exec, grim | wl-copy && notify-send 'Screenshot saved' -t 2000"))
hl.bind("F11", hl.dsp.window.fullscreen())

-- Window movement/management
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = "1", true }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = "2", true }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = "3", true }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = "4", true }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = "5", true }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = "6", true }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = "7", true }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = "8", true }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = "9", true }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = "10", true }))
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))

hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1", true }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = "2", true }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = "3", true }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = "4", true }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = "5", true }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = "6", true }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = "7", true }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = "8", true }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = "9", true }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = "10", true }))
hl.bind("SUPER + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic", true }))

-- Cycle focus
hl.bind("SUPER + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next(true))
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end, { repeating = true })

hl.bind("SUPER + SHIFT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next(false))
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end, { repeating = true })

hl.bind("SUPER + CTRL + H", function()
	hl.dispatch(hl.dsp.focus({ direction = "l" }))
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
hl.bind("SUPER + CTRL + L", function()
	hl.dispatch(hl.dsp.focus({ direction = "r" }))
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
hl.bind("SUPER + CTRL + K", function()
	hl.dispatch(hl.dsp.focus({ direction = "u" }))
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
hl.bind("SUPER + CTRL + J", function()
	hl.dispatch(hl.dsp.focus({ direction = "d" }))
	hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)

-- Resizing
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Special keybinds
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && " .. V_notify .. " vol"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && " .. V_notify .. " vol"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle && " .. V_notify .. " vol"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ lock = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+ && " .. V_notify .. " brightness"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%- && " .. V_notify .. " brightness"),
	{ locked = true, repeating = true }
)
hl.bind("XF86Display", hl.dsp.exec_cmd("dpms-off"))

-- Submaps
local function reset()
	return hl.dsp.submap("reset")
end

-- Settings Submap
hl.bind("SUPER + I", hl.dsp.submap("settings"))
hl.define_submap("settings", function()
	hl.bind("L", function()
		hl.exec_cmd("hyprlock")
		reset()
	end)
	hl.bind("M", hl.dsp.exec_cmd("~/.config/hypr/scripts/cycle_monitors"))
	hl.bind("S", hl.dsp.submap("shaders"))
	hl.bind("SUPER + I", reset())
	hl.bind("ESCAPE", reset())
end)

-- Shaders Submap
hl.define_submap("shaders", function()
	hl.bind("M", function()
		hl.config({ decoration = { screen_shader = "~/.config/hypr/shaders/main.glsl" } })
	end)
	hl.bind("R", function()
		hl.config({ decoration = { screen_shader = "~/.config/hypr/shaders/reading_mode.glsl" } })
	end)
	hl.bind("N", function()
		hl.config({ decoration = { screen_shader = "~/.config/hypr/shaders/night.glsl" } })
	end)
	hl.bind("O", function()
		hl.config({ decoration = { screen_shader = "~/.config/hypr/shaders/outdoor.glsl" } })
	end)
	hl.bind("G", function()
		hl.config({ decoration = { screen_shader = "~/.config/hypr/shaders/greens.glsl" } })
	end)
	hl.bind("ESCAPE", reset())
end)

-- Window Submap
hl.bind("SUPER + W", hl.dsp.submap("window"))
hl.define_submap("window", function()
	hl.bind("L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
	hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	hl.bind("J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
	hl.bind("K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
	hl.bind("ESCAPE", hl.dsp.submap("reset"))
	hl.bind("SUPER + W", hl.dsp.submap("reset"))
end)
