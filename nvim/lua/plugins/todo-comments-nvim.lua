-- Highlight TODO comments and provides a search box
return {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module 'todo-comments'
    ---@type TodoOptions
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        highlight = {
            keyword = 'wide',
            pattern = { [[.*<(KEYWORDS)\s*:]], [[.*\@(KEYWORDS)\s*]] },
        },
        keywords = {
            DANGER = {
                icon = ' ',
                color = 'error',
            },
            REVIEW = {
                icon = ' ',
            },
        },
    },
    keys = {
        {
            '<leader>st',
            ':TodoTelescope<CR>',
            desc = '[s]earch [t]odos',
        },
    },
}
