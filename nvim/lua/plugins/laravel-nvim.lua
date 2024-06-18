return {
    'adalessa/laravel.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'tpope/vim-dotenv',
        'MunifTanjim/nui.nvim',
        'nvimtools/none-ls.nvim',
    },
    cmd = { 'Sail', 'Artisan', 'Composer', 'Npm', 'Yarn', 'Laravel' },
    keys = {
        { '<leader>la', ':Laravel artisan<cr>', desc = 'Open Laravel Artisan menu' },
        { '<leader>lr', ':Laravel routes<cr>', desc = 'Show current routes of the project' },
        { '<leader>lm', ':Laravel related<cr>', desc = 'Show Laravel related files' },
        { '<leader>lsu', ':Sail up -d<cr>', desc = 'Start Sail dettached' },
        { '<leader>lsd', ':Sail down<cr>', desc = 'Stop Sail' },
    },
    event = { 'VeryLazy' },
    opts = {
        lsp_server = 'intelephense',
    },
}
