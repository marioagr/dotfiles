return {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('todo-comments').setup({
            highlight = {
                pattern = { [[.*<(KEYWORDS)\s*:]], [[.*\@(KEYWORDS)\s*]] }, -- pattern or table of patterns, used for highlighting (vim regex)
            },
            search = {
                pattern = [[\b(KEYWORDS)\b]],
            },
        })
        vim.keymap.set('n', '<leader>lt', ':TodoTelescope<CR>', { desc = '[l]ist [t]odo comments' })
    end,
}
