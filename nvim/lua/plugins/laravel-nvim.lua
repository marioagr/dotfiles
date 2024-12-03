-- Ease some things with Laravel projects
return {
    'adalessa/laravel.nvim',
    dependencies = {
        'nvim-telescope/telescope.nvim',
        'tpope/vim-dotenv',
        'MunifTanjim/nui.nvim',
        -- 'nvimtools/none-ls.nvim',
        'kevinhwang91/promise-async',
    },
    cmd = { 'Sail', 'Artisan', 'Composer', 'Npm', 'Yarn', 'Laravel' },
    keys = {
        { '<leader>la', ':Laravel artisan<cr>', desc = 'Open Laravel Artisan menu' },
        { '<leader>lh', ':Laravel history<cr>', desc = 'Show history of Laravel commands' },
        { '<leader>lm', ':Laravel related<cr>', desc = 'Show Laravel related files' },
        { '<leader>lr', ':Laravel routes<cr>', desc = 'Show current routes of the project' },
        { '<leader>lst', ':Sail shell<cr>', desc = 'Start a terminal inside the container' },
        { '<leader>lsu', ':Sail up -d<cr>', desc = 'Start Sail dettached' },
        { '<leader>lsr', ':Sail restart<cr>', desc = 'Restart Sail' },
        { '<leader>lsd', ':Sail down<cr>', desc = 'Stop Sail' },
        { '<leader>lss', ':Sail ps<cr>', desc = 'Status of running containers' },
        { '<leader>Nd', ':Npm dev<cr>', desc = 'Run [N]pm [d]ev' },
        { '<leader>Nb', ':Npm build<cr>', desc = 'Run [N]pm [b]uild' },
    },
    event = { 'VeryLazy' },
    opts = {
        lsp_server = 'intelephense',
        ui = {
            nui_opts = {
                split = {
                    position = 'bottom',
                    win_options = {
                        signcolumn = 'no',
                    },
                },
                -- Maybe set the same window option for the popup?
            },
        },
    },
}
