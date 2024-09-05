-- Display indentation lines
return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
        local highlight = {
            'RainbowRed',
            'RainbowYellow',
            'RainbowBlue',
            'RainbowOrange',
            'RainbowGreen',
            'RainbowViolet',
            'RainbowCyan',
        }

        local hooks = require('ibl.hooks')
        -- create the highlight groups in the highlight setup hook, so they are reset
        -- every time the colorscheme changes
        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
            vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
            vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
            vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
            vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
            vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
            vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
        end)

        require('ibl').setup({
            indent = {
                char = '▏',
                -- IDK looks pretty but...
                -- highlight = highlight,
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
