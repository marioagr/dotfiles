-- Fancy notifications
return {
    -- An alternative can be mini-notify
    -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-notify.md
    'rcarriga/nvim-notify',
    lazy = false,
    priority = 100,
    config = function()
        vim.notify = require('notify')
        ---@diagnostic disable-next-line: missing-fields
        vim.notify.setup({
            fps = 60,
            render = 'wrapped-compact',
            stages = 'slide',
            timeout = 3000,
            top_down = false,
        })
    end,
    keys = {
        { '<leader>sn', ':Telescope notify<CR>', desc = '[s]earch [n]otifications' },
        {
            '<leader>nd',
            function()
                vim.notify.dismiss({
                    silent = false,
                    pending = false,
                })
            end,
            desc = '[n]otifications [d]ismiss',
        },
    },
}
