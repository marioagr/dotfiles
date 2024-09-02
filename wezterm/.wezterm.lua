-- Wezterm API
local wt = require('wezterm')
local config = wt.config_builder()

config.color_scheme = 'Ubuntu'
-- config.color_scheme = 'tokyonight_moon'
config.font = wt.font('Cascadia Mono NF')
config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 5000
config.ui_key_cap_rendering = 'WindowsSymbols'
config.window_decorations = 'RESIZE'
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Use WSL by default
-- config.default_prog = { 'wsl.exe', '-d', 'Ubuntu' }
config.default_domain = 'WSL:Ubuntu'

-- Disable GPU rendering?
config.front_end = 'Software'
-- config.animation_fps = 1
-- config.cursor_blink_ease_in = 'Constant'
-- config.cursor_blink_ease_out = 'Constant'

-- Instead of pressing AltGr+{<space> twice to insert just "^",
-- use this config to press without space and inserts it directly
config.use_dead_keys = false

-- Normalize pasted newlines
-- config.canonicalize_pasted_newlines

-- https://wezfurlong.org/wezterm/config/lua/config/debug_key_events.html
-- config.debug_key_events = true

-- https://wezfurlong.org/wezterm/faq.html?h=underline#how-do-i-enable-undercurl-curly-underlines
-- https://wezfurlong.org/wezterm/multiplexing.html#connecting-into-windows-subsystem-for-linux

return config
