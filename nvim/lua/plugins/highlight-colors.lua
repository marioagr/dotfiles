return {
    'brenoprata10/nvim-highlight-colors',
    opts = {
        enable_tailwind = true,
    },
    lazy = false,
    keys = {
        { '<leader>ct', ':HighlightColors Toggle<CR>', desc = 'Toggle highlight colors' },
    },
}
