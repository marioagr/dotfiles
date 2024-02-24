return {
    -- 'nvimtools/none-ls.nvim',
    -- config = function()
    --     local null_ls = require('null-ls')
    --     null_ls.setup({
    --         sources = {
    --             --[[
    --                 DO NOT USE ANY BUILTINS THAT ARE CONFIGURED IN
    --                 nvim/lua/plugins/lsp-config.lua

    --                 For example: Having lua_ls in lsp-config and
    --                 having enabled [null_ls.builtins.formatting.stylua]
    --                 runs double formatting
    --                     First the one in lsp-config.lua loading config options
    --                     Then the one in this file ignoring the previous config options.
    --             --]]
    --             --[[
    --                 It its not necessary due to intelephense being the LSP for PHP
    --                 null_ls.builtins.diagnostics.php,
    --             --]]
    --         },
    --     })
    -- end,
}
