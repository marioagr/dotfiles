-- Delete Neovim buffers without losing window layout
return {
    'ojroques/nvim-bufdel',
    config = function()
        require('bufdel').setup({
            quit = false, -- quit Neovim when last buffer is closed
        })
    end,
    keys = {
        { '<leader>q', ':BufDel<CR>', desc = 'Close buffer' },
        { '<leader>Qa', ':BufDelAll<CR>', desc = 'Close all buffers' },
        { '<leader>Qq', ':BufDelOthers<CR>', desc = 'Close other buffers' },
    },
}
