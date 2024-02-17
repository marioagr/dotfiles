return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    opts = {},
    config = function()
        -- register which-key VISUAL mode
        -- required for visual <leader>hs (hunk stage) to work
        require('which-key').register({
            ['<leader>'] = { name = 'VISUAL <leader>' },
            ['<leader>h'] = { 'Git [H]unk' },
        }, { mode = 'v' })
    end
}
