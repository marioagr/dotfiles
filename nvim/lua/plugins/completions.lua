-- Autocompletion
return {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
        -- Snippet Engine
        {
            'L3MON4D3/LuaSnip',
            version = '2.*',
            build = 'make install_jsregexp',
        },
        'rafamadriz/friendly-snippets',
        {
            'xzbdmw/colorful-menu.nvim',
            opts = {},
        },
        -- Add VSCode-like pictograms to Neovim built-in lsp
        'onsails/lspkind.nvim',
        'folke/lazydev.nvim',
    },
    config = function()
        require('blink-cmp').setup({
            keymap = {
                preset = 'default',
                -- <C-space> 'show',
                ['<C-e>'] = { 'hide', 'fallback' },
                -- <ctrl-y> select_and_accept
                ['<M-CR>'] = { 'select_and_accept', 'fallback' },

                ['<Up>'] = {},
                ['<Down>'] = {},

                ['<C-Up>'] = { 'select_prev' },
                ['<C-Down>'] = { 'select_next' },

                ['<C-k>'] = {},
                ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },

                ['<M-d>'] = { 'show_documentation', 'hide_documentation' },
            },
            appearance = {
                nerd_font_variant = 'mono',
            },
            completion = {
                accept = {
                    -- How long to wait for the LSP to resolve the item with additional information before continuing as-is
                    resolve_timeout_ms = 250,
                },
                documentation = {
                    auto_show = false,
                    auto_show_delay_ms = 1000,
                },
                list = {
                    selection = {
                        preselect = false,
                    },
                },
                menu = {
                    border = 'rounded',
                    draw = {
                        -- Components to render, grouped by column
                        padding = { 0, 1 },
                        columns = { { 'kind_icon' }, { 'label', gap = 1 }, { 'source_name' } },
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local lspkind = require('lspkind')
                                    local icon = ctx.kind_icon
                                    if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                                        local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                                        if dev_icon then
                                            icon = dev_icon
                                        end
                                    else
                                        icon = lspkind.symbolic(ctx.kind, { mode = 'symbol' })
                                    end

                                    return icon .. ctx.icon_gap
                                end,
                                highlight = function(ctx)
                                    local hl = 'BlinkCmpKind' .. ctx.kind or require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx)
                                    if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                                        local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                                        if dev_icon then
                                            hl = dev_hl
                                        end
                                    end
                                    return hl
                                end,
                            },
                            label = {
                                text = function(ctx)
                                    return require('colorful-menu').blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require('colorful-menu').blink_components_highlight(ctx)
                                end,
                            },
                        },
                        -- Use treesitter to highlight the label text for the given list of sources
                        treesitter = { 'lsp' },
                    },
                },
            },
            sources = {
                default = { 'lsp', 'buffer', 'snippets', 'path', 'lazydev' },
                per_filetype = { sql = { 'dadbod' } },
                providers = {
                    dadbod = { module = 'vim_dadbod_completion.blink' },
                    lazydev = { module = 'lazydev.integrations.blink' },
                },
            },
            fuzzy = {
                implementation = 'prefer_rust_with_warning',
                sorts = {
                    'exact',
                    'score',
                    'sort_text',
                },
            },
            snippets = { preset = 'luasnip' },
            signature = {
                enabled = true,
                window = {
                    show_documentation = false,
                },
            },
        })

        require('luasnip.loaders.from_vscode').lazy_load()
    end,
}
