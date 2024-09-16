local wezterm = require("wezterm")
local mux = wezterm.mux
local gpu_adapters = require("utils.gpu_adapter")

-- TODO: Do error handling while setting config table
local config = wezterm.config_builder()

wezterm.on("gui-startup", function()
	local _, _, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

config.color_scheme = "Tokyo Night"

config.background = {
	{
		source = {
			Color = "#16161e",
		},
		width = "100%",
		height = "100%",
		repeat_x = "NoRepeat",
		repeat_y = "NoRepeat",
		opacity = 1.0,
	},
}

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.default_cursor_style = "SteadyBar"
config.font_size = 12
config.enable_tab_bar = false
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.window_padding = {
	left = 5,
	right = 0,
	top = 10,
	bottom = 0,
}
config.animation_fps = 60
config.max_fps = 60
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.webgpu_preferred_adapter = gpu_adapters:pick_best()
config.audible_bell = "Disabled"
config.term = "wezterm"

return config
