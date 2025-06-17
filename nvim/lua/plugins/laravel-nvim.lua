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
        user_commands = {
            artisan = {
                ['db:fresh'] = {
                    cmd = { 'migrate:fresh', '--seed' },
                    desc = "Re-creates the db and seed's it",
                },
            },
            npm = {
                build = {
                    cmd = { 'run', 'build' },
                    desc = 'Builds the javascript assets',
                },
                dev = {
                    cmd = { 'run', 'dev' },
                    desc = 'Builds the javascript assets',
                },
            },
            composer = {
                autoload = {
                    cmd = { 'dump-autoload' },
                    desc = 'Dumps the composer autoload',
                },
                ['ide-helper'] = {
                    cmd = { 'ide-helper' },
                    desc = 'Runs ide-helper commands defined in composer.json',
                },
            },
            sail = {
                start = {
                    cmd = { 'up', '-d' },
                    desc = 'Start Sail dettached',
                },
                stop = {
                    cmd = { 'stop' },
                    desc = 'Stop Sail',
                },
                build_no_cache = {
                    cmd = { 'build', '--no-cache' },
                    desc = 'Build Sail with no cache',
                },
            },
        },
    },
}
