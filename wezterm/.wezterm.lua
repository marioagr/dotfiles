-- Wezterm API
local wezterm = require('wezterm')
local mux = wezterm.mux
local config = wezterm.config_builder()

config.color_scheme = 'Ubuntu'
-- config.color_scheme = 'tokyonight_moon'
config.font = wezterm.font_with_fallback({ 'Cascadia Mono', 'Symbols Nerd Font Mono' })
config.font_size = 12
config.hide_tab_bar_if_only_one_tab = true
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

-- Disable GPU rendering?
config.front_end = 'Software'
-- config.animation_fps = 1
-- config.cursor_blink_ease_in = 'Constant'
-- config.cursor_blink_ease_out = 'Constant'

-- Instead of pressing AltGr+{<space> twice to insert just "^",
-- use this config to press without space and inserts it directly
-- config.use_dead_keys = false

config.keys = {
    -- Disable debug keymap and send it to the terminal
    {
        key = 'L',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.DisableDefaultAssignment,
    },
    -- https://wezfurlong.org/wezterm/config/lua/keyassignment/PromptInputLine.html#example-of-interactively-picking-a-name-and-creating-a-new-workspace
    {
        key = 'E',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.PromptInputLine({
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                -- line will be `nil` if they hit escape without entering anything
                -- An empty string if they just hit enter
                -- Or the actual line of text they wrote
                if line then
                    window:active_tab():set_title(line)
                end
            end),
        }),
    },
}

-- Normalize pasted newlines
-- config.canonicalize_pasted_newlines

-- https://wezfurlong.org/wezterm/config/lua/config/debug_key_events.html
-- config.debug_key_events = true

-- https://wezfurlong.org/wezterm/faq.html?h=underline#how-do-i-enable-undercurl-curly-underlines
-- https://wezfurlong.org/wezterm/multiplexing.html#connecting-into-windows-subsystem-for-linux

wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

return config
