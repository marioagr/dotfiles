local default_user_commands = require('laravel.options.user_commands')

local new_commands = vim.tbl_deep_extend('force', default_user_commands, {
    composer = {
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
})

return new_commands
