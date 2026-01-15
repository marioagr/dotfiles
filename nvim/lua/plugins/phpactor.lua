return {
    'phpactor/phpactor',
    ft = 'php',
    build = 'composer install --no-dev --optimize-autoloader',
    config = function() __setKeymap('<leader>pm', ':PhpactorContextMenu<CR>', { desc = '[p]hpactor' }) end,
}
