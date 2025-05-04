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
    keys = {
        { '<leader>tc', ':ColorizerToggle<CR>', desc = 'highlight [c]olors' },
    },
}
