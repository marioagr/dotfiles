return {
    -- {
    --     'navarasu/onedark.nvim',
    --     priority = 1000,
    --     init = function()
    --         local onedark = require('onedark')
    --         onedark.setup({
    --             style = 'warmer',
    --         })
    --         onedark.load()
    --     end,
    -- },
    {
        -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require('tokyonight').setup({
                style = 'moon',
                dim_inactive = true,
                on_highlights = function(highlights, colors)
                    highlights.GitSignsAdd = {
                        fg = '#a4cf69',
                    }
                    highlights.GitSignsChange = {
                        fg = '#63c1e6',
                    }
                    highlights.GitSignsDelete = {
                        fg = '#d74f56',
                    }
                end,
            })
            -- Load the colorscheme here
            vim.cmd.colorscheme('tokyonight')

            -- You can configure highlights by doing something like
            -- vim.cmd.hi 'Comment gui=none'
            -- or using tokyonight property
        end,
    },
}
