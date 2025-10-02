-- Set lualine as statusline
return {
    'nvim-lualine/lualine.nvim',
    config = function()
        local nvim_dap = {
            filetypes = { 'dapui_scopes', 'dapui_breakpoints', 'dapui_stacks', 'dapui_watches', 'dap-repl', 'dapui_console' },
            sections = {
                lualine_a = {
                    'mode',
                },
                lualine_b = {
                    'filename',
                },
            },
        }
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
                    -- Is formatting disabled?
                    {
                        function()
                            local is_disabled_in = ''

                            if vim.b.DisableAutoFormat == 1 then
                                is_disabled_in = is_disabled_in .. 'B'
                            else
                                vim.b.DisableAutoFormat = 0
                            end

                            if vim.g.DisableAutoFormatGlobally == 1 then
                                if is_disabled_in ~= '' then
                                    is_disabled_in = is_disabled_in .. ' B'
                                else
                                    is_disabled_in = 'B'
                                end
                            end

                            return is_disabled_in
                        end,
                        icon = '󰉩',
                        cond = function()
                            local disabled_in_buffer = vim.g.DisableAutoFormat or false
                            local disabled_globally = vim.g.DisableAutoFormatGlobally or false

                            if disabled_in_buffer or disabled_globally then
                                return true
                            else
                                return false
                            end
                        end,
                    },
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
                nvim_dap,
            },
        })
    end,
}
