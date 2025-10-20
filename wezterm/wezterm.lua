-- Wezterm API
local wezterm = require('wezterm')
local config = wezterm.config_builder()
local mux = wezterm.mux
local my_keys = require('my_keys')

config.color_scheme = 'Ubuntu'
config.default_domain = 'WSL:Ubuntu'
config.font = wezterm.font_with_fallback({ 'CaskaydiaCove Nerd Font Mono', 'Symbols Nerd Font Mono' })
config.font_size = 13
config.scrollback_lines = 5000
config.ui_key_cap_rendering = 'WindowsSymbols'
config.window_decorations = 'RESIZE'
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

config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.colors = {
    tab_bar = {
        background = '#000000',
        active_tab = {
            bg_color = '#8900ae',
            fg_color = '#ffffff',
        },
        inactive_tab = {
            bg_color = '#330040',
            fg_color = '#aaaaaa',
            intensity = 'Half',
        },
        inactive_tab_hover = {
            bg_color = '#5d0076',
            fg_color = '#909090',
            italic = true,
        },
        new_tab = {
            bg_color = '#000000',
            fg_color = '#bbbbbb',
        },
        new_tab_hover = {
            bg_color = '#5d0076',
            fg_color = '#ffffff',
            italic = true,
        },
    },
}

config.launch_menu = {
    {
        label = 'Powershell',
        domain = { DomainName = 'local' },
        args = { 'pwsh.exe' },
    },
}

-- Instead of pressing AltGr+{<space> twice to insert just "^",
-- use this config to press without space and inserts it directly
-- config.use_dead_keys = false

-- Normalize pasted newlines
-- config.canonicalize_pasted_newlines

my_keys.apply_to_config(config)

-- https://wezfurlong.org/wezterm/config/lua/config/debug_key_events.html
-- config.debug_key_events = true

-- https://wezfurlong.org/wezterm/faq.html?h=underline#how-do-i-enable-undercurl-curly-underlines
-- https://wezfurlong.org/wezterm/multiplexing.html#connecting-into-windows-subsystem-for-linux

---@diagnostic disable-next-line: unused-local
wezterm.on('update-status', function(window, pane)
    local active_kt = window:active_key_table()
    local status_text = {}

    if active_kt then
        table.insert(status_text, { Foreground = { AnsiColor = 'Aqua' } })
        table.insert(status_text, { Text = 'Mode: ' .. active_kt })
    end

    wezterm.log_info(active_kt)
    if window:leader_is_active() then
        if active_kt then
            table.insert(status_text, 'ResetAttributes')
            table.insert(status_text, { Text = ' - ' })
        end
        table.insert(status_text, { Foreground = { AnsiColor = 'Green' } })
        table.insert(status_text, { Text = 'LEADER' })
    end

    table.insert(status_text, { Text = '  ' })

    window:set_left_status(' ' .. window:active_workspace() .. ' ')
    window:set_right_status(wezterm.format(status_text))
end)

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function get_tab_title(tab_info)
    local title = tab_info.tab_title

    if title and #title > 0 then
        return title
    end

    return tab_info.active_pane.title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
    local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider
    local EXPANDED_PANE = wezterm.nerdfonts.md_arrow_expand_all

    local edge_background = '#000000'
    local background = '#330040'
    local foreground = '#aaaaaa'

    if tab.is_active then
        background = '#8900ae'
        foreground = '#ffffff'
    elseif hover then
        background = '#5d0076'
        foreground = '#909090'
    end

    local edge_foreground = background

    local title = get_tab_title(tab)

    if string.match(title, 'n[eo]*vim') then
        title = '  ' .. title
    elseif string.match(title, '[lazy]*git') then
        title = '󰊢  ' .. title
    elseif string.match(title, 'c[ommand]*li[ne]*') or string.match(title, 'opencode') then
        title = '  ' .. title
    elseif string.match(title, 'docker[-compose]*') or title:find('sail') then
        title = '  ' .. title
    elseif string.match(title, '[wW]indows') or string.match(title, 'p[o]*w[er]*sh[ell]*') then
        title = '  ' .. title
    end

    title = string.format('%s: %s', tab.tab_index + 1, title)

    if tab.active_pane.is_zoomed then
        title = title:gsub(':', ' ' .. EXPANDED_PANE .. ' ')
    end

    title = wezterm.truncate_right(title, max_width - 2)

    return {
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_LEFT_ARROW },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Background = { Color = edge_background } },
        { Foreground = { Color = edge_foreground } },
        { Text = SOLID_RIGHT_ARROW },
    }
end)

wezterm.on('gui-startup', function(cmd)
    ---@diagnostic disable-next-line: unused-local
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

return config
