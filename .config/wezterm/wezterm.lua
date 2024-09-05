local wezterm = require("wezterm")
local gpu_adapters = require("utils.gpu_adapter")

-- TODO: Do error handling while setting config table
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"
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
config.window_background_opacity = 0.85
config.macos_window_background_blur = 20
config.animation_fps = 60
config.max_fps = 60
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.webgpu_preferred_adapter = gpu_adapters:pick_best()
config.audible_bell = "Disabled"
config.term = "wezterm"

return config
