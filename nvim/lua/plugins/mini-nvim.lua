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

        -- Animate common Neovim actions
        require('mini.animate').setup()
    end,
}
