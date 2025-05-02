return {
    'phpactor/phpactor',
    ft = 'php',
    build = 'composer install --no-dev --optimize-autoloader',
    opts = {},
    keys = {
        { '<leader>pm', ':PhpactorContextMenu<CR>', desc = '[p]hpactor [m]enu' },
    },
}
