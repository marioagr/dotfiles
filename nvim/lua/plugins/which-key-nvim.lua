return {
    -- An alternative can be mini-clue
    -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-clue.md
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {},
    config = function()
        -- register which-key VISUAL mode
        -- required for visual <leader>hs (hunk stage) to work
        require('which-key').register({
            ['<leader>'] = { name = 'VISUAL <leader>' },
            ['<leader>h'] = { 'Git [h]unk' },
        }, { mode = 'v' })

        require('which-key').register({
            ['<leader>'] = { name = 'VISUAL <leader>' },
            ['<leader>h'] = { 'Git [h]unk' },
            ['<leader>l'] = { '[l]aravel' },
            ['<leader>n'] = { '[n]otifications' },
            ['<leader>gs'] = { '[g]it [s]igns' },
            ['<leader>s'] = { '[s]earch' },
            ['<leader>w'] = { '[w]orkspace' },
        }, { mode = 'n' })
    end,
}
