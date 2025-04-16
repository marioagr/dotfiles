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
            config = function()
                require('luasnip.loaders.from_vscode').lazy_load()
            end,
        },
        {
            'xzbdmw/colorful-menu.nvim',
            opts = {},
        },
        -- Add VSCode-like pictograms to Neovim built-in lsp
        'onsails/lspkind.nvim',
        'folke/lazydev.nvim',
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'default',
            -- Override default
            ['<Up>'] = {},
            ['<Down>'] = {},

            ['<C-Up>'] = { 'select_prev' },
            ['<C-Down>'] = { 'select_next' },

            ['<C-k>'] = {},
            ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },

            ['<C-y>'] = {},
            ['<C-Right>'] = { 'accept', 'fallback' },
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

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lsp', 'buffer', 'snippets', 'path', 'lazydev' },
            per_filetype = { sql = { 'dadbod' } },
            providers = {
                dadbod = { module = 'vim_dadbod_completion.blink' },
                lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
            },
        },

        snippets = { preset = 'luasnip' },

        -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = {
            implementation = 'prefer_rust_with_warning',
            sorts = {
                'exact',
                'score',
                'sort_text',
            },
        },

        -- Shows a signature help window while you type arguments for a function
        signature = {
            enabled = true,
            window = {
                -- TODO: Try this
                show_documentation = false,
            },
        },
    },
    opts_extend = { 'sources.default' },
}
