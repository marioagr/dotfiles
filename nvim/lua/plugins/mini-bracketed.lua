return {
    'echasnovski/mini.bracketed',
    version = false,
    event = 'VeryLazy',
    config = function()
        -- https://github.com/echasnovski/mini.nvim/issues/235#issuecomment-1462367177
        -- See nvim/lua/marrio/keymaps.lua
        require('mini.bracketed').setup()
    end,
}
