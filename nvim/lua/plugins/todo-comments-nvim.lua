return {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('todo-comments').setup({
            highlight = {
                keyword = 'bg',
                pattern = { [[.*<(KEYWORDS)\s*:]], [[.*\@(KEYWORDS)\s*]] }, -- pattern or table of patterns, used for highlighting (vim regex)
            },
            search = {
                -- Don't know why I used this
                -- pattern = [[\b(KEYWORDS)]],
            },
            signs = false,
        })
        vim.keymap.set('n', '<leader>lt', ':TodoTelescope<CR>', { desc = '[l]ist [t]odo comments' })
    end,
}
