-- Highlight TODO comments and provides a search box
return {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        colors = {
            info = { '#82aaff' },
        },
        highlight = {
            keyword = 'wide',
            pattern = { [[.*<(KEYWORDS)\s*:]], [[.*\@(KEYWORDS)\s*]] },
        },
        keywords = {
            DANGER = {
                icon = ' ',
                color = 'error',
            },
            INFO = {
                icon = ' ',
                color = 'info',
            },
            NOTE = {
                alt = {},
            },
            REVIEW = {
                icon = ' ',
            },
        },
        search = {
            command = 'rg',
            args = {
                -- Defaults
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',

                -- Ignore any comments in vendor folders
                '-g=!**/vendor/**',
            },
            pattern = [[\b(KEYWORDS):]],
        },
    },
    keys = {
        {
            '<leader>st',
            ':TodoTelescope keywords=TODO,FIX,DANGER,REVIEW<CR>',
            desc = '[s]earch [t]odos',
        },
        {
            '<leader>sT',
            ':TodoTelescope<CR>',
            desc = '[s]earch all [T]odos',
        },
    },
}
