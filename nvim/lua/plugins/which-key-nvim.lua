return {
    -- An alternative can be mini-clue
    -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-clue.md
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
        require('which-key').setup({
            preset = 'modern',
            delay = 750,
            expand = 1,
            spec = {
                { '<leader>h', group = 'Git [h]unk', mode = { 'n', 'v' } },
                { '<leader>l', group = '[l]aravel' },
                { '<leader>ls', group = '[s]ail' },
                { '<leader>n', group = '[n]otifications' },
                { '<leader>gs', group = '[g]it [s]igns' },
                { '<leader>s', group = '[s]earch' },
                { '<leader>w', group = '[w]orkspace' },
            },
            win = {
                wo = {
                    winblend = 10,
                },
            },
        })
    end,
    keys = {
        {
            '<leader>?',
            function()
                require('which-key').show({ global = false })
            end,
            desc = 'Buffer Local Keymaps (which-key)',
        },
    },
}
