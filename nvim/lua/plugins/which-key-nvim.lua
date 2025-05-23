return {
    -- An alternative can be mini-clue
    -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-clue.md
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
        preset = 'modern',
        delay = 500,
        expand = 1,
        spec = {
            { '<leader>b', group = '[b]ufferline', mode = { 'n' } },
            { '<leader>d', group = '[d]adbod-ui', mode = { 'n' } },
            { '<leader>e', group = 'file [e]xplorer', mode = { 'n' } },
            { '<leader>g', group = '[g]it', mode = { 'n' } },
            { '<leader>gs', group = '[g]it [s]igns' },
            { '<leader>h', group = 'Git [h]unk', mode = { 'n', 'v' } },
            { '<leader>l', group = '[l]aravel' },
            { '<leader>ls', group = '[s]ail' },
            { '<leader>n', group = '[n]otifications' },
            { '<leader>N', group = '[N]pm (Laravel)' },
            { '<leader>p', group = 'parameter | phpactor' },
            { '<leader>s', group = '[s]earch' },
            { '<leader>S', group = 'Grug [S]earch', mode = { 'n', 'v' } },
            { '<leader>t', group = '[t]oggle' },
            { '<leader>W', group = '[W]orkspace' },
            { '<leader>*', group = 'Quickfix list word or selection in cwd', mode = { 'n', 'v' } },
        },
    },
}
