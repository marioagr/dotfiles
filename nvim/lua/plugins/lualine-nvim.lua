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
                    {
                        function() return #vim.tbl_keys(vim.lsp.get_clients()) end,
                        icon = '',
                    },
                    {
                        'diagnostics',
                        sources = { 'nvim_diagnostic' },
                        cond = function() return vim.diagnostic.is_enabled({ bufnr = 0 }) end,
                    },
                },
                lualine_c = {
                    { 'filename', path = 1 },
                    'searchcount',
                },
                lualine_x = {
                    'filetype',
                    {
                        'encoding',
                        show_bomb = true,
                        cond = function()
                            if vim.bo.fileencoding ~= 'utf-8' then
                                return true
                            end
                        end,
                    },
                    {
                        'fileformat',
                        cond = function()
                            if vim.bo.fileformat ~= 'unix' then
                                return true
                            end
                        end,
                    },
                },
                lualine_y = {
                    -- Spelling
                    {
                        function() return '󰓆' end,
                        cond = function() return vim.wo.spell end,
                    },
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
                                    is_disabled_in = is_disabled_in .. ' G'
                                else
                                    is_disabled_in = 'G'
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
                    -- Spaces/Tab && width
                    {
                        function()
                            local icon = '␠ '
                            if not vim.bo.expandtab then
                                icon = '↹ '
                            end

                            return icon .. vim.bo.shiftwidth
                        end,
                        cond = function()
                            if not vim.bo.expandtab or vim.bo.shiftwidth ~= 4 then
                                return true
                            end
                        end,
                    },
                    -- Braces "config"
                    {
                        icon = '{ ¶ }',
                        cond = function()
                            if vim.fn.mapcheck('{', 'n') == '' then
                                return true
                            end
                        end,
                    },
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
