-- Highlight colors
return {
    'NvChad/nvim-colorizer.lua',
    opts = {
        user_default_options = {
            css = true,
            -- Disabled due to some problem when [g]oing to [d]efinition on PHP files
            -- sass = { enable = true, parsers = 'css' },
            tailwind = true,
        },
    },
    lazy = false,
    keys = {
        { '<leader>tc', ':ColorizerToggle<CR>', desc = '[t]oggle highlight [c]olors' },
    },
}
