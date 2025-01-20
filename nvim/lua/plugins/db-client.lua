-- Interactive DB client
return {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
        { 'tpope/vim-dadbod', lazy = true },
        { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
        'DBUI',
        'DBUIToggle',
        'DBUIAddConnection',
        'DBUIFindBuffer',
    },
    init = function()
        vim.g.vim_dadbod_completion_mark = ' '
        vim.g.db_ui_use_nerd_fonts = 1
    end,
    keys = {
        {
            '<leader>db',
            ':DBUIToggle<CR>',
            desc = 'Toggle vim-dadbod-ui',
        },
    },
}
