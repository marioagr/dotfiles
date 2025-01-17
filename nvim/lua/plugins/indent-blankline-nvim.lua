-- Display indentation lines
return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
        require('ibl').setup({
            indent = {
                char = '▏',
            },
            exclude = {
                filetypes = {
                    'help',
                    'terminal',
                    'dashboard',
                    'packer',
                    'lspinfo',
                    'TelescopePrompt',
                    'TelescopeResults',
                },
                buftypes = {
                    'terminal',
                    'NvimTree',
                },
            },
            scope = {
                -- This seems to solve the problem of the highlight but
                -- I'll leave the workaround below if I need it
                -- with other highlights (see note below)
                -- show_start = false,
            },
        })

        -- NOTE: With the current wezterm (WSL2) config this highlight is...
        -- Maybe switch to mini.indentscope or not use it at all sources:
        --  https://github.com/lukas-reineke/indent-blankline.nvim/issues/754
        --  https://github.com/lukas-reineke/indent-blankline.nvim/issues/686
        -- vim.api.nvim_set_hl(0, '@ibl.scope.underline.1', { underline = true, bold = true })
    end,
}
