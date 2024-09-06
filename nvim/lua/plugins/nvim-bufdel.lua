-- Delete Neovim buffers without losing window layout
return {
    'ojroques/nvim-bufdel',
    config = function()
        require('bufdel').setup({
            quit = false, -- quit Neovim when last buffer is closed
        })
        vim.keymap.set('n', '<leader>q', ':BufDel<CR>', { desc = 'Close buffer' })
    end,
}
