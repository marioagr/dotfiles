local wezterm = require('wezterm')
local act = wezterm.action
local M = {}

local leader_key = { key = 'Space', mods = 'ALT', timeout_milliseconds = 1000 }
local keys = {
    -- Send the Alt+Space combination to the terminal when pressing twice the combination
    { key = 'Space', mods = 'LEADER|ALT', action = wezterm.action.SendKey({ key = 'Space', mods = 'ALT' }) },

    -- Font related
    { key = '+', mods = 'SUPER', action = act.IncreaseFontSize },
    { key = '-', mods = 'SUPER', action = act.DecreaseFontSize },
    { key = '0', mods = 'SUPER', action = act.ResetFontSize },

    -- Miscellaneous
    { key = 'k', mods = 'SUPER', action = act.ClearScrollback('ScrollbackOnly') },
    { key = 'n', mods = 'SUPER', action = act.SpawnWindow },
    -- TODO: Check how to configure this correctly
    { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo('Clipboard') },
    { key = 'v', mods = 'CTRL|SHIFT', action = act.PasteFrom('Clipboard') },
    { key = 'f', mods = 'CTRL|SHIFT', action = act.Search('CurrentSelectionOrEmptyString') },
    { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
    { key = 'x', mods = 'CTRL|SHIFT', action = act.ActivateCopyMode },
    { key = 'phys:Space', mods = 'CTRL|SHIFT', action = act.QuickSelect },

    -- Tabs without LEADER
    { key = 'PageDown', mods = 'CTRL', action = act.ActivateTabRelative(1) },
    { key = 'PageUp', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(-1) },
    { key = 'PageDown', mods = 'CTRL|SHIFT', action = act.MoveTabRelative(1) },
    { key = 'PageUp', mods = 'CTRL', action = act.ActivateTabRelative(-1) },

    -- Scroll
    { key = 'UpArrow', mods = 'SHIFT', action = act.ScrollByLine(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = act.ScrollByLine(1) },
    { key = 'PageDown', mods = 'SHIFT', action = act.ScrollByPage(1) },
    { key = 'PageUp', mods = 'SHIFT', action = act.ScrollByPage(-1) },

    -- Disable debug keymap and send it to the terminal
    { key = 'L', mods = 'CTRL|SHIFT', action = act.DisableDefaultAssignment },

    -- Show debug overlay
    { key = 'D', mods = 'LEADER', action = act.ShowDebugOverlay },

    -- [w]orkspace "mode" by pressing LEADER+w
    {
        key = 'w',
        mods = 'LEADER',
        action = act.ActivateKeyTable({
            name = 'workspace',
            one_shot = false,
        }),
    },

    -- [t]abs "mode" by pressing LEADER+t
    {
        key = 't',
        mods = 'LEADER',
        action = act.ActivateKeyTable({
            name = 'tabs',
        }),
    },

    -- [p]ane "mode" by pressing LEADER+p
    {
        key = 'p',
        mods = 'LEADER',
        action = act.ActivateKeyTable({
            name = 'panes',
            one_shot = false,
        }),
    },
}

local key_tables = {
    -- TODO: Clean this
    copy_mode = {
        { key = 'Tab', mods = 'NONE', action = act.CopyMode('MoveForwardWord') },
        { key = 'Tab', mods = 'SHIFT', action = act.CopyMode('MoveBackwardWord') },
        { key = 'Enter', mods = 'NONE', action = act.CopyMode('MoveToStartOfNextLine') },
        { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
        { key = 'Space', mods = 'NONE', action = act.CopyMode({ SetSelectionMode = 'Cell' }) },
        { key = '$', mods = 'NONE', action = act.CopyMode('MoveToEndOfLineContent') },
        { key = '$', mods = 'SHIFT', action = act.CopyMode('MoveToEndOfLineContent') },
        { key = ',', mods = 'NONE', action = act.CopyMode('JumpReverse') },
        { key = '0', mods = 'NONE', action = act.CopyMode('MoveToStartOfLine') },
        { key = ';', mods = 'NONE', action = act.CopyMode('JumpAgain') },
        { key = 'F', mods = 'NONE', action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
        { key = 'F', mods = 'SHIFT', action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
        { key = 'G', mods = 'NONE', action = act.CopyMode('MoveToScrollbackBottom') },
        { key = 'G', mods = 'SHIFT', action = act.CopyMode('MoveToScrollbackBottom') },
        { key = 'H', mods = 'NONE', action = act.CopyMode('MoveToViewportTop') },
        { key = 'H', mods = 'SHIFT', action = act.CopyMode('MoveToViewportTop') },
        { key = 'L', mods = 'NONE', action = act.CopyMode('MoveToViewportBottom') },
        { key = 'L', mods = 'SHIFT', action = act.CopyMode('MoveToViewportBottom') },
        { key = 'M', mods = 'NONE', action = act.CopyMode('MoveToViewportMiddle') },
        { key = 'M', mods = 'SHIFT', action = act.CopyMode('MoveToViewportMiddle') },
        { key = 'O', mods = 'NONE', action = act.CopyMode('MoveToSelectionOtherEndHoriz') },
        { key = 'O', mods = 'SHIFT', action = act.CopyMode('MoveToSelectionOtherEndHoriz') },
        { key = 'T', mods = 'NONE', action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
        { key = 'T', mods = 'SHIFT', action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
        { key = 'V', mods = 'NONE', action = act.CopyMode({ SetSelectionMode = 'Line' }) },
        { key = 'V', mods = 'SHIFT', action = act.CopyMode({ SetSelectionMode = 'Line' }) },
        { key = '^', mods = 'NONE', action = act.CopyMode('MoveToStartOfLineContent') },
        { key = '^', mods = 'SHIFT', action = act.CopyMode('MoveToStartOfLineContent') },
        { key = 'b', mods = 'NONE', action = act.CopyMode('MoveBackwardWord') },
        { key = 'b', mods = 'ALT', action = act.CopyMode('MoveBackwardWord') },
        { key = 'b', mods = 'CTRL', action = act.CopyMode('PageUp') },
        { key = 'c', mods = 'CTRL', action = act.CopyMode('Close') },
        { key = 'd', mods = 'CTRL', action = act.CopyMode({ MoveByPage = 0.5 }) },
        { key = 'e', mods = 'NONE', action = act.CopyMode('MoveForwardWordEnd') },
        { key = 'f', mods = 'NONE', action = act.CopyMode({ JumpForward = { prev_char = false } }) },
        { key = 'f', mods = 'ALT', action = act.CopyMode('MoveForwardWord') },
        { key = 'f', mods = 'CTRL', action = act.CopyMode('PageDown') },
        { key = 'g', mods = 'NONE', action = act.CopyMode('MoveToScrollbackTop') },
        { key = 'g', mods = 'CTRL', action = act.CopyMode('Close') },
        { key = 'h', mods = 'NONE', action = act.CopyMode('MoveLeft') },
        { key = 'j', mods = 'NONE', action = act.CopyMode('MoveDown') },
        { key = 'k', mods = 'NONE', action = act.CopyMode('MoveUp') },
        { key = 'l', mods = 'NONE', action = act.CopyMode('MoveRight') },
        { key = 'm', mods = 'ALT', action = act.CopyMode('MoveToStartOfLineContent') },
        { key = 'o', mods = 'NONE', action = act.CopyMode('MoveToSelectionOtherEnd') },
        { key = 'q', mods = 'NONE', action = act.CopyMode('Close') },
        { key = 't', mods = 'NONE', action = act.CopyMode({ JumpForward = { prev_char = true } }) },
        { key = 'u', mods = 'CTRL', action = act.CopyMode({ MoveByPage = -0.5 }) },
        { key = 'v', mods = 'NONE', action = act.CopyMode({ SetSelectionMode = 'Cell' }) },
        { key = 'v', mods = 'CTRL', action = act.CopyMode({ SetSelectionMode = 'Block' }) },
        { key = 'w', mods = 'NONE', action = act.CopyMode('MoveForwardWord') },
        { key = 'y', mods = 'NONE', action = act.Multiple({ { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } }) },
        { key = 'PageUp', mods = 'NONE', action = act.CopyMode('PageUp') },
        { key = 'PageDown', mods = 'NONE', action = act.CopyMode('PageDown') },
        { key = 'End', mods = 'NONE', action = act.CopyMode('MoveToEndOfLineContent') },
        { key = 'Home', mods = 'NONE', action = act.CopyMode('MoveToStartOfLine') },
        { key = 'LeftArrow', mods = 'NONE', action = act.CopyMode('MoveLeft') },
        { key = 'LeftArrow', mods = 'ALT', action = act.CopyMode('MoveBackwardWord') },
        { key = 'RightArrow', mods = 'NONE', action = act.CopyMode('MoveRight') },
        { key = 'RightArrow', mods = 'ALT', action = act.CopyMode('MoveForwardWord') },
        { key = 'UpArrow', mods = 'NONE', action = act.CopyMode('MoveUp') },
        { key = 'DownArrow', mods = 'NONE', action = act.CopyMode('MoveDown') },
    },

    search_mode = {
        { key = 'Enter', mods = 'NONE', action = act.CopyMode('PriorMatch') },
        { key = 'Escape', mods = 'NONE', action = act.CopyMode('Close') },
        { key = 'n', mods = 'CTRL', action = act.CopyMode('NextMatch') },
        { key = 'p', mods = 'CTRL', action = act.CopyMode('PriorMatch') },
        { key = 'r', mods = 'CTRL', action = act.CopyMode('CycleMatchType') },
        { key = 'u', mods = 'CTRL', action = act.CopyMode('ClearPattern') },
        { key = 'PageUp', mods = 'NONE', action = act.CopyMode('PriorMatchPage') },
        { key = 'PageDown', mods = 'NONE', action = act.CopyMode('NextMatchPage') },
        { key = 'UpArrow', mods = 'NONE', action = act.CopyMode('PriorMatch') },
        { key = 'DownArrow', mods = 'NONE', action = act.CopyMode('NextMatch') },
    },

    workspace = {
        -- Cancel the mode by pressing escape
        { key = 'Escape', action = act.PopKeyTable },

        -- Prompt for a name to use for a new workspace and switch to it.
        {
            key = 'n',
            action = act.PromptInputLine({
                description = wezterm.format({
                    { Attribute = { Intensity = 'Bold' } },
                    { Foreground = { AnsiColor = 'Green' } },
                    { Text = 'Enter name for new workspace:' },
                }),
                action = wezterm.action_callback(function(window, pane, line)
                    -- line will be `nil` if they hit escape without entering anything
                    -- An empty string if they just hit enter or the actual line of text they wrote
                    if line then
                        window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
                    end
                end),
            }),
        },

        -- NOTE: Maybe use InputSelector?
        -- Show the launcher in fuzzy selection mode and have it list all workspaces and allow activating one.
        {
            key = 'w',
            action = act.ShowLauncherArgs({
                flags = 'FUZZY|WORKSPACES',
            }),
        },

        -- Select next workspace
        { key = 'RightArrow', mods = 'LEADER', action = act.SwitchWorkspaceRelative(1) },

        -- Select previous workspace
        { key = 'LeftArrow', mods = 'LEADER', action = act.SwitchWorkspaceRelative(-1) },

        -- Related to session_manager plugin
        { key = 's', mods = 'LEADER', action = act({ EmitEvent = 'save_session' }) },
        { key = 'l', mods = 'LEADER', action = act({ EmitEvent = 'load_session' }) },
        { key = 'r', mods = 'LEADER', action = act({ EmitEvent = 'restore_session' }) },
    },

    tabs = {
        { key = 'n', mods = '', action = act.SpawnTab('CurrentPaneDomain') },
        { key = 'x', mods = '', action = act.CloseCurrentTab({ confirm = true }) },
        { key = 'l', mods = '', action = act.ShowTabNavigator },

        -- Rename tab
        {
            key = 'r',
            mods = '',
            action = act.PromptInputLine({
                description = wezterm.format({
                    { Attribute = { Intensity = 'Bold' } },
                    { Foreground = { AnsiColor = 'Green' } },
                    { Text = 'Enter new name for tab:' },
                }),
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
    },

    panes = {
        -- Cancel the mode by pressing escape
        { key = 'Escape', action = act.PopKeyTable },

        { key = 'v', mods = '', action = act.SplitVertical({ domain = 'CurrentPaneDomain' }) },
        { key = 'h', mods = '', action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },

        -- Toggle "full screen" of current pane
        -- TODO: Show in right-status when its in full mode and other panes exist
        { key = 'z', mods = '', action = act.TogglePaneZoomState },

        -- Select pane
        { key = 'LeftArrow', mods = 'CTRL', action = act.ActivatePaneDirection('Left') },
        { key = 'RightArrow', mods = 'CTRL', action = act.ActivatePaneDirection('Right') },
        { key = 'UpArrow', mods = 'CTRL', action = act.ActivatePaneDirection('Up') },
        { key = 'DownArrow', mods = 'CTRL', action = act.ActivatePaneDirection('Down') },

        -- Change height/width of pane
        { key = 'LeftArrow', mods = 'ALT', action = act.AdjustPaneSize({ 'Left', 1 }) },
        { key = 'RightArrow', mods = 'ALT', action = act.AdjustPaneSize({ 'Right', 1 }) },
        { key = 'UpArrow', mods = 'ALT', action = act.AdjustPaneSize({ 'Up', 1 }) },
        { key = 'DownArrow', mods = 'ALT', action = act.AdjustPaneSize({ 'Down', 1 }) },
    },
}

-- define a function in the module table.
-- Only functions defined in `module` will be exported to
-- code that imports this module.
-- The suggested convention for making modules that update
-- the config is for them to export an `apply_to_config`
-- function that accepts the config object, like this:
function M.apply_to_config(config)
    config.disable_default_key_bindings = true
    config.leader = leader_key
    config.keys = keys
    config.key_tables = key_tables
end

return M
