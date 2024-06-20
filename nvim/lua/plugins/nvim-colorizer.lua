return {
    'NvChad/nvim-colorizer.lua',
    opts = {
        user_default_options = {
            css = true,
            sass = { enable = true },
            tailwind = true,
        },
    },
    lazy = false,
    keys = {
        { '<leader>ct', ':ColorizerToggle<CR>', desc = 'Toggle highlight colors' },
    },
}
