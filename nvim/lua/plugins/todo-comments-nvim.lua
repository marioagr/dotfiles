-- Highlight TODO comments and provides a search box
return {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require('todo-comments').setup({
            highlight = {
                keyword = 'wide',
                pattern = { [[.*<(KEYWORDS)\s*:]], [[.*\@(KEYWORDS)\s*]] },
            },
            signs = false,
        })
        __setKeymap('<leader>tl', ':TodoTelescope<CR>', { desc = '[t]odo [l]ist' })
    end,
}
