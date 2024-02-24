return {
    'rcarriga/nvim-notify',
    priority = 100,
    config = function()
        vim.notify = require('notify')
        vim.notify.setup({
            stages = 'slide',
            timeout = 5000,
        })

        local function dismiss_notifications()
            require('notify').dismiss({
                silent = false,
                pending = false,
            })
        end

        vim.keymap.set('n', '<leader>nl', ':Telescope notify<CR>', { desc = '[n]otifications [l]ist' })
        vim.keymap.set('n', '<leader>nd', dismiss_notifications, {desc = '[n]otifications [d]ismiss'})
    end,
}
