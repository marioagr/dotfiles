return {
    -- An alternative is 'OXY2DEV/markview.nvim'
    'MeanderingProgrammer/render-markdown.nvim',
    main = 'render-markdown',
    opts = {
        code = {
            border = 'thick',
        },
    },
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    keys = {
        {
            '<leader>tm',
            ':RenderMarkdown toggle<CR>',
            desc = '[t]oggle [m]arkdown',
        },
    },
}
