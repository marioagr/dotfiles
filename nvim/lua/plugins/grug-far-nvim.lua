-- Find and Replace plugin
-- NOTE: Requires ripgrep
return {
    'MagicDuck/grug-far.nvim',
    opts = {
        keymaps = {
            swapEngine = false,
        },
    },
    keys = {
        {
            '<leader>Ss',
            function()
                require('grug-far').grug_far()
            end,
            mode = { 'n', 'v' },
            desc = 'Grug find! Grug replace! Grug happy!',
        },
        {
            '<leader>Sc',
            function()
                require('grug-far').grug_far({ prefills = { paths = vim.fn.expand('%') } })
            end,
            mode = { 'n', 'v' },
            desc = 'Find & Replace in current file',
        },
        {
            '<leader>Sg',
            function()
                require('grug-far').toggle_instance({ instanceName = 'global_search_replace', staticTitle = 'Find and Replace (All files)' })
            end,
            mode = { 'n', 'v' },
            desc = 'Find & Replace in all files (toggleable)',
        },
    },
}
