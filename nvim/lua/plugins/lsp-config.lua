return {
    'neovim/nvim-lspconfig',
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for neovim
        -- NOTE: Must be loaded before dependants
        {
            'mason-org/mason.nvim',
            ---@module 'mason.settings'
            ---@type MasonSettings
            ---@diagnostic disable-next-line: missing-fields
            opts = {
                ui = {
                    border = 'rounded',
                    icons = {
                        package_installed = '✓',
                        package_pending = '...',
                        package_uninstalled = '✗',
                    },
                    width = 0.9,
                },
            },
        },
        'mason-org/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',

        -- Universal JSON schema store, where schemas for popular JSON documents can be found.
        'b0o/schemastore.nvim',

        -- Useful status updates for LSP
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim', opts = {} },

        -- lazydev configures Lua LSP for your Neovim config, runtime and plugins
        {
            'folke/lazydev.nvim',
            ft = 'lua',
            ---@module "lazydev"
            ---@type lazydev.Config
            ---@diagnostic disable-next-line: missing-fields
            opts = {
                library = {
                    -- Load luvit types when the `vim.uv` word is found
                    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
                },
            },
        },

        -- Allows extra capabilities provided by blink.cmp
        'saghen/blink.cmp',
    },
    config = function()
        -- Brief Aside: **What is LSP?**
        --
        -- LSP is an acronym you've probably heard, but might not understand what it is.
        --
        -- LSP stands for Language Server Protocol. It's a protocol that helps editors
        -- and language tooling communicate in a standardized fashion.
        --
        -- In general, you have a "server" which is some tool built to understand a particular
        -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc). These Language Servers
        -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
        -- processes that communicate with some "client" - in this case, Neovim!
        --
        -- LSP provides Neovim with features like:
        --  - Go to definition
        --  - Find references
        --  - Autocompletion
        --  - Symbol Search
        --  - and more!
        --
        -- Thus, Language Servers are external tools that must be installed separately from
        -- Neovim. This is where `mason` and related plugins come into play.
        --
        -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
        -- and elegantly composed help section, :help lsp-vs-treesitter

        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
            callback = function(event)
                --  NOTE: Remember that lua is a real programming language, and as such it is possible
                --  to define small helper and utility functions so you don't have to repeat yourself
                --  many times.
                --
                --  In this case, we create a function that lets us more easily define mappings specific
                --  for LSP related items. It sets the mode, buffer and description for us each time.
                local map = function(keys, func, desc, mode)
                    mode = mode or 'n'
                    __setKeymap(keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }, mode)
                end

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                map('grn', vim.lsp.buf.rename, '[r]e[n]ame')

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map('gra', vim.lsp.buf.code_action, '[c]ode [a]ction', { 'n', 'x' })

                -- Find references for the word under your cursor.
                map('grr', require('telescope.builtin').lsp_references, '[rr]eferences')

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map('gri', require('telescope.builtin').lsp_implementations, '[r]ead [i]mplementation(s)')

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map('grd', require('telescope.builtin').lsp_definitions, '[r]ead [d]efinition')

                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

                -- Fuzzy find all the symbols in your current workspace
                --  Similar to document symbols, except searches over your whole project.
                map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open [W]orkspace Symbols')

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                map('grt', require('telescope.builtin').lsp_type_definitions, '[r]ead [t]ype Definition')

                -- Opens a popup that displays documentation about the word under your cursor
                --  See `:help K` for why this keymap
                map('<C-s>', vim.lsp.buf.signature_help, 'Signature Help')

                -- map('<leader>Wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [a]dd Folder')
                -- nmap('<leader>Wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove Folder')
                map('<leader>WL', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[W]orkspace [l]ist Folders')

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                    local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })
                end

                vim.api.nvim_create_autocmd('LspDetach', {
                    group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                    callback = function(event)
                        vim.lsp.buf.clear_references()
                        vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event.buf })
                    end,
                })

                -- The following autocommand is used to enable inlay hints in your
                -- code, if the language server you are using supports them
                --
                -- This may be unwanted, since they displace some of your code
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
                    map('<leader>th', function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, 'inlay [h]ints')
                end
            end,
        })

        -- Sign configuration
        ---@see vim.diagnostic.Opts.Signs
        vim.diagnostic.config({
            severity_sort = true,
            float = { border = 'rounded', source = 'if_many' },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '󰅚 ',
                    [vim.diagnostic.severity.WARN] = '󰀪 ',
                    [vim.diagnostic.severity.INFO] = '󰋽 ',
                    [vim.diagnostic.severity.HINT] = '󰌶 ',
                },
            } or {},
            virtual_text = {
                source = 'if_many',
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        [vim.diagnostic.severity.WARN] = diagnostic.message,
                        [vim.diagnostic.severity.INFO] = diagnostic.message,
                        [vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP Specification.
        --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
        -- TODO: In theory this is no longer neccessary with new Neovim 0.11+ vim.lsp.config
        -- local capabilities = require('blink.cmp').get_lsp_capabilities()

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --    For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
            -- clangd = {},
            -- gopls = {},
            -- pyright = {},
            -- rust_analyzer = {},
            -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
            --
            -- Some languages (like typescript) have entire language plugins that can be useful:
            --    https://github.com/pmizio/typescript-tools.nvim
            --
            -- But for many setups, the LSP (`ts_ls`) will work just fine

            -- antlersls = {},
            cssls = {
                filetypes = vim.list_extend(require('lspconfig.configs.cssls').default_config.filetypes, {
                    -- 'antlers',
                    'blade',
                    'html',
                }),
            },
            emmet_language_server = {
                filetypes = vim.list_extend(require('lspconfig.configs.emmet_language_server').default_config.filetypes, {
                    -- 'antlers',
                    'blade',
                }),
            },
            html = {
                filetypes = vim.list_extend(require('lspconfig.configs.html').default_config.filetypes, {
                    -- 'antlers',
                    'hbs',
                    'php',
                    'twig',
                }),
            },
            intelephense = {},
            jsonls = {
                settings = {
                    json = {
                        -- https://github.com/b0o/schemastore.nvim
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                    },
                },
            },
            lua_ls = {
                -- cmd = {...},
                -- filetypes = { ...},
                -- capabilities = {},
                settings = {
                    Lua = {
                        telemetry = { enable = false },
                        -- Formatting options
                        -- https://luals.github.io/wiki/formatter/
                        -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                        completion = {
                            callSnippet = 'Replace',
                        },
                        codeLens = {
                            enable = true,
                        },
                        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
            },
            tailwindcss = {
                -- filetypes = {
                --     'antlers',
                -- },
                settings = {
                    tailwindCSS = {
                        classAttributes = vim.list_extend(require('lspconfig.configs.tailwindcss').default_config.settings.tailwindCSS.classAttributes, { 'class:input' }),
                        emmetCompletions = true,
                        -- includeLanguages = {
                        --     antlers = 'html',
                        -- },
                    },
                },
            },
            ts_ls = {},
            -- In case I need to configure it deeply
            -- https://www.arthurkoziel.com/json-schemas-in-neovim/
            yamlls = {
                settings = {
                    yaml = {
                        format = {
                            enable = true,
                            singleQuote = true,
                            bracketSpacing = true,
                        },
                        completion = true,
                        schemaStore = {
                            enable = true,
                        },
                    },
                },
            },
        }

        -- Set border globally instead of per client
        --- @see https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#borders
        local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
        ---@diagnostic disable-next-line: duplicate-set-field
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or 'rounded'
            return orig_util_open_floating_preview(contents, syntax, opts, ...)
        end

        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})

        vim.lsp.config('*', {
            root_markers = { '.git' },
        })

        for server_name, config in pairs(servers) do
            vim.lsp.config(server_name, config)
            -- This is handled by mason-config
            -- vim.lsp.enable(server_name)
        end

        ---@diagnostic disable-next-line: missing-fields
        require('mason-lspconfig').setup({
            ensure_installed = ensure_installed,
            automatic_enable = true,
        })

        -- NOTE: Used in conform-nvim
        local mason_extras = {
            'prettierd',
            'tailwindcss',
            'blade-formatter',
            'stylua',
            'mdslw',
            'pint',
        }

        require('mason-tool-installer').setup({ ensure_installed = mason_extras })
    end,
}
