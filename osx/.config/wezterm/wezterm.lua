local wezterm = require 'wezterm'
local config = {}
config.color_scheme = "Catppuccin Mocha"
config.font_size = 14
config.freetype_render_target = "HorizontalLcd"
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 5000
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.window_background_opacity = 0.85
config.macos_window_background_blur = 5
config.window_decorations = "RESIZE"

return config

