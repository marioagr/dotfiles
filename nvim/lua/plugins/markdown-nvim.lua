return {
    'MeanderingProgrammer/markdown.nvim',
    main = 'render-markdown',
    opts = {},
    ft = { 'markdown' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    keys = {
        {
            '<leader>tm',
            function()
                require('render-markdown').toggle()
            end,
            desc = '[t]oggle [m]arkdown',
        },
    },
}
