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
    cmd = { 'Laravel' },
    keys = {
        { '<leader>la', ':Laravel artisan<cr>', desc = 'Open Artisan menu' },
        { '<leader>lc', ':Laravel commands<cr>', desc = 'Execute a user [c]ommand' },
        { '<leader>le', ':e .env<CR>', desc = 'Open [e]nv file' },
        { '<leader>lf', ':Laravel related<cr>', desc = 'Show related [f]iles' },
        { '<leader>lh', ':Laravel history<cr>', desc = 'Show [h]istory of commands' },
        { '<leader>ll', ':e storage/logs/laravel.log<CR>', desc = 'Open [l]ogs' },
        { '<leader>lm', ':Laravel make<cr>', desc = 'Available content to [m]ake' },
        { '<leader>lr', ':Laravel routes<cr>', desc = 'Show current [r]outes of the project' },
        { '<leader>lR', ':Laravel resources<cr>', desc = 'Go to a [R]esource of the project' },
        {
            'gf',
            function()
                if require('laravel').app('gf').cursor_on_resource() then
                    return '<cmd>Laravel gf<CR>'
                else
                    return 'gf'
                end
            end,
            noremap = false,
            expr = true,
        },
    },
    event = { 'VeryLazy' },
    config = function()
        -- local default_user_commands = require('laravel.options.user_commands')
        local opts = {
            lsp_server = 'intelephense',
            features = {
                model_info = {
                    enable = false,
                },
            },
            ui = {
                nui_opts = {
                    split = {
                        position = 'bottom',
                        win_options = {
                            signcolumn = 'no',
                        },
                    },
                },
            },
            user_commands = require('marrio.extras.laravel.user-commands'),
            user_providers = {
                require('marrio.extras.laravel.history-provider'),
            },
        }

        require('laravel').setup(opts)
    end,
}
