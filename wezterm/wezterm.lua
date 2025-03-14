-- Wezterm API
local wezterm = require('wezterm')
local config = wezterm.config_builder()
local mux = wezterm.mux
local my_keys = require('my_keys')

config.color_scheme = 'Ubuntu'
-- config.color_scheme = 'tokyonight_moon'
config.font = wezterm.font_with_fallback({ 'Cascadia Mono', 'Symbols Nerd Font Mono' })
config.font_size = 12
-- config.hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 5000
config.ui_key_cap_rendering = 'WindowsSymbols'
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

config.inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.5,
}

-- Use WSL by default
-- config.default_prog = { 'wsl.exe', '-d', 'Ubuntu' }
config.default_domain = 'WSL:Ubuntu'

-- Disable GPU rendering
-- config.front_end = 'Software'
-- config.animation_fps = 1
-- config.cursor_blink_ease_in = 'Constant'
-- config.cursor_blink_ease_out = 'Constant'

-- Instead of pressing AltGr+{<space> twice to insert just "^",
-- use this config to press without space and inserts it directly
-- config.use_dead_keys = false

---@diagnostic disable-next-line: unused-local
wezterm.on('update-status', function(window, pane)
    window:set_left_status(window:active_workspace())
end)

wezterm.on('update-right-status', function(window, pane)
    local kt_name = window:active_key_table()
    local leader = ''
    local zoomed_text = ''

    if kt_name then
        kt_name = 'Mode: ' .. kt_name
    else
        kt_name = ''
    end

    if window:leader_is_active() then
        leader = 'LEADER'
        if kt_name ~= '' then
            leader = ' - ' .. leader
        end
    end

    if pane.is_zoomed then
        zoomed_text = '󰁌 '
    end

    window:set_right_status(zoomed_text .. '' .. kt_name .. leader)
end)

my_keys.apply_to_config(config)

-- Normalize pasted newlines
-- config.canonicalize_pasted_newlines

-- https://wezfurlong.org/wezterm/config/lua/config/debug_key_events.html
-- config.debug_key_events = true

-- https://wezfurlong.org/wezterm/faq.html?h=underline#how-do-i-enable-undercurl-curly-underlines
-- https://wezfurlong.org/wezterm/multiplexing.html#connecting-into-windows-subsystem-for-linux

wezterm.on('gui-startup', function(cmd)
    ---@diagnostic disable-next-line: unused-local
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

return config
