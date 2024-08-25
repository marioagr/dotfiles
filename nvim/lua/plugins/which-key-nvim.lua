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
                { '<leader>c', group = '[c]ode', mode = { 'n', 'x' } },
                { '<leader>gs', group = '[g]it [s]igns' },
                { '<leader>h', group = 'Git [h]unk', mode = { 'n', 'v' } },
                { '<leader>l', group = '[l]aravel' },
                { '<leader>ls', group = '[s]ail' },
                { '<leader>n', group = '[n]otifications' },
                { '<leader>N', group = '[N]pm (Laravel)' },
                { '<leader>s', group = '[s]earch' },
                { '<leader>S', group = 'Grug [S]earch', mode = { 'n', 'v' } },
                { '<leader>t', group = '[T]oggle or [T]elescope' },
                { '<leader>W', group = '[W]orkspace' },
            },
            win = {
                wo = {
                    winblend = 10,
                },
            },
        })
    end,
}
