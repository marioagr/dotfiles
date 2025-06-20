-- Set lualine as statusline
return {
    'nvim-lualine/lualine.nvim',
    config = function()
        local dbui = {
            filetypes = { 'dbui' },
            sections = {
                lualine_a = {
                    'mode',
                },
                lualine_b = {
                    'filename',
                    'searchcount',
                },
            },
        }

        local grug_far = {
            filetypes = { 'grug-far', 'gurg-far-history', 'grug-far-help' },
            sections = {
                lualine_a = {
                    'mode',
                },
                lualine_b = {
                    'filename',
                },
            },
        }

        local function status_formatter()
            local buffer_autoformat_disabled_icon = '󰯮 '
            local buffer_autoformat_enabled_icon = '󰬉 '
            local buffer_icon = buffer_autoformat_enabled_icon

            local global_autoformat_disabled_icon = '󰯽 '
            local global_autoformat_enabled_icon = '󰬎 '
            local global_icon = global_autoformat_enabled_icon

            if vim.b.DisableAutoFormat == 1 then
                buffer_icon = buffer_autoformat_disabled_icon
            else
                vim.b.DisableAutoFormat = 0
            end

            if vim.g.DisableAutoFormatGlobally == 1 then
                global_icon = global_autoformat_disabled_icon
            end

            return require('string').format('%s%s', buffer_icon, global_icon)
        end

        require('lualine').setup({
            options = {
                icons_enabled = true,
                component_separators = '|',
                section_separators = '',
            },
            sections = {
                lualine_a = {
                    'mode',
                },
                lualine_b = {
                    'branch',
                    'diff',
                    '" " .. tostring(#vim.tbl_keys(vim.lsp.get_clients()))',
                    { 'diagnostics', sources = { 'nvim_diagnostic' } },
                },
                lualine_c = {
                    { 'filename', path = 1 },
                    'searchcount',
                },
                lualine_x = {
                    'filetype',
                    { 'encoding', show_bomb = true },
                    'fileformat',
                },
                lualine_y = {
                    status_formatter,
                    '(vim.bo.expandtab and "␠ " or "⇥ ") .. vim.bo.shiftwidth',
                },
                lualine_z = {
                    'location',
                    'progress',
                },
            },
            extensions = {
                'lazy',
                'mason',
                'nvim-tree',
                dbui,
                grug_far,
            },
        })
    end,
}
