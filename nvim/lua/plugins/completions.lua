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
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        require('blink-cmp').setup({
            appearance = {
                nerd_font_variant = 'mono',
            },
            fuzzy = {
                implementation = 'prefer_rust_with_warning',
                sorts = {
                    'exact',
                    'score',
                    'sort_text',
                },
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
                    max_items = 250,
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
                                    local icon = ctx.kind_icon

                                    if ctx.source_name == 'Path' then
                                        local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                                        if dev_icon then
                                            icon = dev_icon
                                        end
                                    elseif ctx.source_name == 'Blade-nav' then
                                        icon = ''
                                    else
                                        icon = require('lspkind').symbolic(ctx.kind, { mode = 'symbol' })
                                    end

                                    return icon .. ctx.icon_gap
                                end,
                                highlight = function(ctx)
                                    local hl = 'BlinkCmpKind' .. ctx.kind or require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx)

                                    if ctx.source_name == 'Path' then
                                        local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                                        if dev_icon then
                                            hl = dev_hl
                                        end
                                    elseif ctx.source_name == 'Blade-nav' then
                                        hl = 'BlinkCmpKindBladeNav'
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
                    max_height = 20,
                },
            },
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
            cmdline = {
                keymap = {
                    preset = 'cmdline',
                    ['<C-Space>'] = { 'show', 'hide', 'fallback' },

                    ['<M-CR>'] = { 'select_and_accept', 'fallback' },

                    ['<C-Up>'] = { 'select_prev' },
                    ['<C-Down>'] = { 'select_next' },

                    ['<Right>'] = { 'fallback' },
                    ['<Left>'] = { 'fallback' },
                },
                -- completion = { menu = { auto_show = true } },
            },
            signature = {
                enabled = true,
                window = {
                    show_documentation = false,
                },
            },
            sources = {
                per_filetype = {
                    blade = { inherit_defaults = true, 'blade-nav' },
                    sql = { 'dadbod', 'buffer' },
                    lua = { 'lazydev', inherit_defaults = true },
                },
                providers = {
                    lsp = { fallbacks = {} },
                    buffer = { max_items = 25 },
                    snippets = { max_items = 25 },
                    dadbod = { module = 'vim_dadbod_completion.blink' },
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100,
                    },
                    ['blade-nav'] = {
                        module = 'blade-nav.blink',
                        opts = {
                            close_tag_on_complete = false,
                        },
                        score_offset = 100,
                    },
                },
            },
            snippets = { preset = 'luasnip' },
        })

        require('luasnip.loaders.from_vscode').lazy_load()
    end,
}
