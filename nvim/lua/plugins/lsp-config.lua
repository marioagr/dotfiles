return {
    {
        'williamboman/mason-lspconfig.nvim',
        opts = {
            ensure_installed = { 'intelephense', 'jsonls', 'lua_ls' },
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim',       opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',

            -- Universal JSON schema store, where schemas for popular JSON documents can be found.
            'b0o/schemastore.nvim',
        },
        config = function()
            -- Almost all of this was copied from Kickstart.Nvim
            -- This function gets run when an LSP connects to a particular buffer.
            local on_attach = function(_, bufnr)
                -- NOTE: Remember that lua is a real programming language, and as such it is possible
                -- to define small helper and utility functions so you don't have to repeat yourself
                -- many times.
                --
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local nmap = function(keys, func, desc)
                    if desc then
                        desc = 'LSP: ' .. desc
                    end

                    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                end

                nmap('<leader>rn', vim.lsp.buf.rename, '[r]e[n]ame')
                nmap('<leader>ca', function()
                    vim.lsp.buf.code_action({ context = { only = { 'quickfix', 'refactor', 'source' } } })
                end, '[c]ode [a]ction')

                nmap('gd', require('telescope.builtin').lsp_definitions, '[g]oto [d]efinition')
                nmap('gr', require('telescope.builtin').lsp_references, '[g]oto [r]eferences')
                nmap('gi', require('telescope.builtin').lsp_implementations, '[g]oto [i]mplementation')
                nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[d]ocument [s]ymbols')
                nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[w]orkspace [s]ymbols')

                -- See `:help K` for why this keymap
                nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
                nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

                -- Lesser used LSP functionality
                nmap('gD', vim.lsp.buf.declaration, '[g]oto [D]eclaration')
                nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[w]orkspace [a]dd Folder')
                nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[w]orkspace [r]emove Folder')
                nmap('<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, '[w]orkspace [l]ist Folders')

                -- Create a command `:Format` local to the LSP buffer
                -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                -- vim.lsp.buf.format()
                -- end, { desc = 'Format current buffer with LSP' })

                vim.keymap.set('n', '<leader>ft', vim.lsp.buf.format, { desc = 'Format code using None-LSP' })
            end
            -- mason-lspconfig requires that these setup functions are called in this order
            -- before setting up the servers.
            require('mason').setup()
            require('mason-lspconfig').setup()

            -- Sign configuration
            vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
            vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
            vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
            vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })

            -- Enable the following language servers
            --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
            --
            --  Add any additional override configuration in the following tables. They will be passed to
            --  the `settings` field of the server config. You must look up that documentation yourself.
            --
            --  If you want to override the default filetypes that your language server will attach to you can
            --  define the property 'filetypes' to the map in question.
            local servers = {
                -- clangd = {},
                -- gopls = {},
                -- pyright = {},
                -- rust_analyzer = {},
                -- tsserver = {},
                html = { filetypes = { 'html', 'twig', 'hbs', 'php' } },
                intelephense = {},
                -- https://github.com/b0o/schemastore.nvim
                jsonls = {
                    json = {
                        schemas = require('schemastore').json.schemas(),
                        validate = { enable = true },
                    },
                },
                lua_ls = {
                    Lua = {
                        workspace = { checkThirdParty = false },
                        telemetry = { enable = false },
                        -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },

                        -- Formatting options
                        -- https://luals.github.io/wiki/formatter/
                        -- https://github.com/CppCXY/EmmyLuaCodeStyle/blob/master/docs/format_config_EN.md
                        format = {
                            defaultConfig = {
                                align_continuous_assign_statement = 'false',
                                max_line_length = '180',
                                quote_style = 'single',
                                trailing_table_separator = 'smart',
                            },
                        },
                    },
                },
            }
            -- Setup neovim lua configuration
            require('neodev').setup()
            -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

            -- Ensure the servers above are installed
            local mason_lspconfig = require('mason-lspconfig')

            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(servers),
            })

            mason_lspconfig.setup_handlers({
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = servers[server_name],
                        filetypes = (servers[server_name] or {}).filetypes,
                    })
                end,
            })
        end,
    },
}
