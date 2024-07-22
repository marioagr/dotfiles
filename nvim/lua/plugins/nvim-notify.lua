-- Fancy notifications
return {
    -- An alternative can be mini-notify
    -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-notify.md
    'rcarriga/nvim-notify',
    priority = 100,
    config = function()
        vim.notify = require('notify')
        ---@diagnostic disable-next-line: missing-fields
        vim.notify.setup({
            fps = 60,
            render = 'compact',
            stages = 'slide',
            timeout = 5000,
        })

        local function dismiss_notifications()
            vim.notify.dismiss({
                silent = false,
                pending = false,
            })
        end

        vim.keymap.set('n', '<leader>nl', ':Telescope notify<CR>', { desc = '[n]otifications [l]ist' })
        vim.keymap.set('n', '<leader>nd', dismiss_notifications, { desc = '[n]otifications [d]ismiss' })
    end,
}
