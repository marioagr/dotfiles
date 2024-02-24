return {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
            'L3MON4D3/LuaSnip',
            build = (function()
                -- Build Step is needed for regex support in snippets
                -- This step is not supported in many windows environments
                -- Remove the below condition to re-enable on windows
                if vim.fn.has 'win32' == 1 then
                    return
                end
                return 'make install_jsregexp'
            end)(),
        },
        'saadparwaiz1/cmp_luasnip',

        -- Adds LSP completion capabilities
        'hrsh7th/cmp-nvim-lsp',                -- For Neovim's built-in language server client
        'hrsh7th/cmp-path',                    -- For filesystem paths
        'hrsh7th/cmp-nvim-lsp-signature-help', -- For displaying function signatures with the current parameter emphasized
        -- 'hrsh7th/cmp-calc', -- Math calculations, has to be enabled below on cmp.setup.sources
        'hrsh7th/cmp-omni',                    -- Guess this helps with the omnifunc function?

        -- Adds a number of user-friendly snippets
        'rafamadriz/friendly-snippets',

        -- Add VSCode-like pictograms to Neovim built-in lsp
        'onsails/lspkind.nvim',
    },
    -- Recommended config
    event = { 'InsertEnter', 'CmdlineEnter' },
    config = function()
        -- [[ Configure nvim-cmp ]]
        -- See `:help cmp`
        local cmp = require 'cmp'
        local lspkind = require('lspkind')
        local luasnip = require 'luasnip'
        require('luasnip.loaders.from_vscode').lazy_load()
        luasnip.config.setup {}

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            completion = {
                --[[
                    Recommended to be disabled but meh
                        autocomplete = false,
                    Can be overriden instead of vim.opt.completeopt
                        completeopt = 'menu,menuone,preview',
                --]]
            },
            formatting = {
                format = lspkind.cmp_format({
                    mode = 'symbol_text',
                    show_labelDetails = true,
                }),
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-Up>'] = cmp.mapping.scroll_docs(-4),
                ['<C-Down>'] = cmp.mapping.scroll_docs(4),
                -- Same as <C-e>
                ['<Esc>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.abort()
                    else
                        fallback()
                    end
                end, { 'i' }, { desc = 'Close cmp completion window' }),
                ['<C-Space>'] = cmp.mapping.complete {},
                ['<CR>'] = cmp.mapping.confirm {},
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'path' },
                { name = 'nvim_lsp_signature_help' },
                {
                    name = 'omni',
                    option = {
                        disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' },
                    },
                },
            },
        }

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' },
            },
        })

        local function cmp_complete()
            require('cmp').complete()
        end

        vim.keymap.set('i', '<C-x><C-o>', cmp_complete, { desc = 'Show cmp completion' })
    end,
}
