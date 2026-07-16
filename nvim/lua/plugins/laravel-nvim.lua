-- Ease some things with Laravel projects
return {
    'adalessa/laravel.nvim',
    dependencies = {
        'MunifTanjim/nui.nvim',
        'nvim-lua/plenary.nvim',
        'nvim-neotest/nvim-nio',
        'kevinhwang91/promise-async',
    },
    ft = { 'php', 'blade' },
    event = { 'BufEnter composer.json' },
    keys = {
        -- stylua: ignore start
        { "<leader>lL", function() Laravel.pickers.laravel() end,               desc = "Laravel: Open Laravel Picker" },
        { '<leader>la', function() Laravel.pickers.artisan() end,               desc = 'Open Artisan menu' },
        { '<leader>lc', function() Laravel.pickers.commands() end,              desc = 'Execute a user [c]ommand' },
        { '<leader>l+', function() Laravel.commands.run('env:configure') end,   desc = 'Open configuration for this project' },
        { "<leader>lD", function() Laravel.run("artisan docs") end,             desc = "Laravel: Open Documentation" },
        { '<leader>lf', function() Laravel.pickers.related() end,               desc = 'Show related [f]iles' },
        { '<leader>lh', function() Laravel.pickers.history() end,               desc = 'Show [h]istory of commands' },
        { "<leader>lH", function() Laravel.commands.run("hub") end,             desc = "Laravel Artisan [H]ub" },
        { '<leader>ll', ':sp storage/logs/laravel.log<CR>',                     desc = 'Open [l]ogs' },
        { '<leader>lm', function() Laravel.pickers.make() end,                  desc = 'Available content to [m]ake' },
        { "<leader>lp", function() Laravel.commands.run("command_center") end,  desc = "Laravel: Open Command Center" },
        {
            "<leader>lt",
            function()
                local tinker_files = vim.fn.glob(vim.fn.getcwd() .. "/*.tinker", false, true)
                if #tinker_files > 1 then
                    Laravel.commands.run("tinker:select")
                else
                    Laravel.commands.run("tinker:open")
                end
            end,
            desc = "Laravel: Open Tinker Playground",
        },
        { '<leader>lr', function() Laravel.pickers.routes() end,                desc = 'Show current [r]outes of the project' },
        { '<leader>lR', function() Laravel.pickers.resources() end,             desc = 'Go to a [R]esource of the project' },
        { "<leader>l.", function() Laravel.commands.run("actions") end,         desc = "Laravel: Open Actions Picker" },
        { "<c-g>",      function() Laravel.commands.run("view:finder") end,     desc = "Laravel: Open View Finder" },
        -- stylua: ignore end
        {
            'gf',
            function()
                if Laravel.app('gf').cursorOnResource() then
                    return "<cmd>lua Laravel.commands.run('gf')<cr>"
                end
                return 'gf'
            end,
            expr = true,
            noremap = true,
            desc = 'Laravel: Go to resource',
        },
    },
    opts = {
        extensions = {
            artisan_hub = {
                commands = {
                    {
                        name = 'Pail',
                        cmd = 'artisan pail --timeout=0',
                    },
                    {
                        name = 'Logs',
                        class = 'laravel.extensions.artisan_hub.log_command',
                    },
                },
            },
            -- composer_info = { enable = false },
            model_info = { enable = false },
        },
        resources = {
            Enums = 'app/Enums',
            Lang = 'lang',
            Rules = 'app/Rules',
            Services = 'app/Services',
            ['Filament Actions'] = 'app/Filament/Actions',
            ['Filament Pages'] = 'app/Filament/Pages',
            ['Filament Resources'] = 'app/Filament/Resources',
            ['Filament Widgets'] = 'app/Filament/Widgets',
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
                ['blueprint:build'] = {
                    cmd = { 'blueprint:build', '-m' },
                    desc = 'Use draft.yml to generate files (overwrites migrations)',
                },
                ['boost:install'] = {
                    cmd = { 'boost:install', '--guidelines', '--mcp', '--skills' },
                    desc = 'Install Laravel Boost with guidelines, MCP and skills',
                },
                ['boost:update'] = {
                    cmd = { 'boost:update', '--discover' },
                    desc = 'Update Laravel Boost using discovery',
                },
                ['db:fresh --seed'] = {
                    cmd = { 'migrate:fresh', '--seed' },
                    desc = "Re-creates the db and seed's it",
                },
                ['db:migrate:step'] = {
                    cmd = { 'migrate', '--step' },
                    desc = 'Runs missing migrations step by step',
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
                ['composer:install'] = {
                    cmd = { 'install' },
                    desc = 'Run composer install',
                },
                ['composer:update'] = {
                    cmd = { 'update' },
                    desc = 'Run composer update',
                },
                ['composer:update:withAllDependencies'] = {
                    cmd = { 'update', '--with-all-dependencies' },
                    desc = 'Run composer update with all dependencies',
                },
                ['composer:ide-helper'] = {
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
                ['sail:start:dettached'] = {
                    cmd = { 'up', '-d' },
                    desc = 'Start Sail dettached',
                },
                ['sail:stop'] = {
                    cmd = { 'stop' },
                    desc = 'Stop Sail',
                },
                ['sail:build:--no-cache'] = {
                    cmd = { 'build', '--no-cache' },
                    desc = 'Build Sail with no cache',
                },
            },
        },
    },
}
