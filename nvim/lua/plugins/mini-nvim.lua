return {
    -- Full list of modules at: https://github.com/echasnovski/mini.nvim?tab=readme-ov-file#modules
    'echasnovski/mini.nvim',
    version = false,
    config = function()
        -- Better Around/Inside textobjects
        -- Examples:
        --  - va)  - [V]isually select [A]round [)]parenthen
        --  - yinq - [Y]ank [I]nside [N]ext [']quote
        --  - ci'  - [C]hange [I]nside [']quote
        require('mini.ai').setup({
            n_lines = 500,
        })

        -- Add/delete/replace surroundings (brackets, quotes, etc.)
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        -- Number of lines within which surrounding is searched
        require('mini.surround').setup({
            n_lines = 100,
        })

        -- https://github.com/echasnovski/mini.nvim/issues/235#issuecomment-1462367177
        -- See nvim/lua/marrio/keymaps.lua
        require('mini.bracketed').setup()

        -- Split/Join arguments inside (), [], {}
        require('mini.splitjoin').setup()

        -- Session management made easy
        local sessions = require('mini.sessions')
        sessions.setup({
            autoread = true, -- Load local session on startup
        })

        ---@diagnostic disable-next-line: param-type-mismatch
        vim.keymap.set('n', '<leader>Wm', function()
            sessions.write(sessions.config.file)
        end, { desc = '[W[orkspace [m]ake a local Vim session' })

        ---@diagnostic disable-next-line: param-type-mismatch
        vim.keymap.set('n', '<leader>Wr', function()
            sessions.read()
        end, { desc = '[W]orkspace [r]ead a Vim session' })

        ---@diagnostic disable-next-line: param-type-mismatch
        vim.keymap.set('n', '<leader>Wd', function()
            sessions.delete(nil, {
                force = true,
            })
        end, { desc = '[W]orkspace [d]elete a local Vim session' })

        ---@diagnostic disable-next-line: param-type-mismatch
        vim.keymap.set('n', '<leader>Wl', function()
            sessions.select()
        end, { desc = '[W]orkspace [l]ist sessions' })
    end,
}
