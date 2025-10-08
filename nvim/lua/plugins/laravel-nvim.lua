local laravel_nvim_dev_dir = vim.fn.expand('~/devProjects/laravel-nvim/')
local dir_exists = vim.fn.isdirectory(laravel_nvim_dev_dir)

-- Ease some things with Laravel projects
return {
    'adalessa/laravel.nvim',
    dir = dir_exists and laravel_nvim_dev_dir or nil,
    dependencies = {
        'tpope/vim-dotenv',
        'MunifTanjim/nui.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-neotest/nvim-nio',
        'kevinhwang91/promise-async',
    },
    cmd = { 'Laravel' },
    keys = {
        -- stylua: ignore start
        { '<leader>la', function() Laravel.pickers.artisan() end,               desc = 'Open Artisan menu' },
        { '<leader>lc', function() Laravel.pickers.commands() end,              desc = 'Execute a user [c]ommand' },
        { '<leader>l+', function() Laravel.commands.run('env:configure') end,   desc = 'Open configuration for this project' },
        { "<leader>lD", function() Laravel.run("artisan docs") end,             desc = "Laravel: Open Documentation" },
        -- { '<leader>le', ':vs .env<CR>',                                         desc = 'Open [e]nv file' },
        { '<leader>lf', function() Laravel.pickers.related() end,               desc = 'Show related [f]iles' },
        { '<leader>lh', function() Laravel.pickers.history() end,               desc = 'Show [h]istory of commands' },
        { '<leader>ll', ':sp storage/logs/laravel.log<CR>',                     desc = 'Open [l]ogs' },
        { "<leader>lL", function() Laravel.pickers.laravel() end,               desc = "Laravel: Open Laravel Picker" },
        { '<leader>lm', function() Laravel.pickers.make() end,                  desc = 'Available content to [m]ake' },
        { "<leader>lp", function() Laravel.commands.run("command_center") end,  desc = "Laravel: Open Command Center" },
        { "<leader>lt", function() Laravel.commands.run('tinker:open') end,     desc = "Laravel: Open Tinker Playground" },
        { '<leader>lr', function() Laravel.pickers.routes() end,                desc = 'Show current [r]outes of the project' },
        { '<leader>lR', function() Laravel.pickers.resources() end,             desc = 'Go to a [R]esource of the project' },
        { "<leader>l.", function() Laravel.commands.run("actions") end,         desc = "Laravel: Open Actions Picker" },
        -- { "<c-g>",      function() Laravel.commands.run("view:finder") end,     desc = "Laravel: Open View Finder" },
        -- stylua: ignore end
        {
            'gf',
            function()
                local ok, res = pcall(function()
                    if Laravel.app('gf').cursorOnResource() then
                        return "<cmd>lua Laravel.commands.run('gf')<cr>"
                    end
                end)
                if not ok or not res then
                    return 'gf'
                end
                return res
            end,
            expr = true,
            noremap = true,
        },
    },
    event = { 'VeryLazy' },
    opts = {
        lsp_server = 'intelephense',
        extensions = {
            composer_info = { enable = false },
            model_info = { enable = false },
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
        user_commands = {
            artisan = {
                ['db:fresh'] = {
                    cmd = { 'migrate:fresh', '--seed' },
                    desc = "Re-creates the db and seed's it",
                },
                ['optimize:clear'] = {
                    cmd = { 'optimize:clear' },
                    desc = 'Clear cache and other things',
                },
            },
            composer = {
                autoload = {
                    cmd = { 'dump-autoload' },
                    desc = 'Dumps the composer autoload',
                },
                install = {
                    cmd = { 'install' },
                    desc = 'Run composer install',
                },
                update = {
                    cmd = { 'update' },
                    desc = 'Run composer update',
                },
                ['ide-helper'] = {
                    cmd = { 'ide-helper' },
                    desc = 'Runs ide-helper commands defined in composer.json',
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
