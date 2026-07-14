return {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        { 'windwp/nvim-ts-autotag', opts = {} },
        -- NOTE: Not sure if it is necessary, but not included by now
        -- 'JoosepAlviste/nvim-ts-context-commentstring',
        -- An alternative could be
        -- 'folke/ts-comments.nvim'
    },
    build = ':TSUpdate',
    main = 'nvim-treesitter',
    init = function()
        local ensure_installed = {
            'blade',
            'css',
            'diff',
            'git_config',
            'git_rebase',
            'gitattributes',
            'gitcommit',
            'gitignore',
            'html',
            'javascript',
            'jsdoc',
            'json',
            'jsonc',
            'lua',
            'luadoc',
            'markdown',
            'markdown_inline',
            'php',
            'php_only',
            'phpdoc',
            'query',
            'regex',
            'toml',
            'tsx',
            'typescript',
            'xml',
            'yaml',
        }

        local alreadyInstalled = require('nvim-treesitter.config').get_installed()
        local parsersToInstall = vim.iter(ensure_installed):filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end):totable()
        require('nvim-treesitter').install(parsersToInstall)

        ---@param buf integer
        ---@param language string
        local function treesitter_try_attach(buf, language)
            -- Check if a parser exists and load it
            if not vim.treesitter.language.add(language) then
                return
            end
            -- Enable syntax highlighting and other treesitter features
            vim.treesitter.start(buf, language)

            -- Enable treesitter based folds
            -- For more info on folds see `:help folds`
            -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            -- vim.wo.foldmethod = 'expr'

            -- Check if treesitter indentation is available for this language, and if so enable it
            -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
            local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

            -- Enable treesitter based indentation
            if has_indent_query then
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end

        local available_parsers = require('nvim-treesitter').get_available()
        vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
                local buf, filetype = args.buf, args.match

                local language = vim.treesitter.language.get_lang(filetype)
                if not language then
                    return
                end

                local installed_parsers = require('nvim-treesitter').get_installed('parsers')

                if vim.tbl_contains(installed_parsers, language) then
                    -- Enable the parser if it is already installed
                    treesitter_try_attach(buf, language)
                elseif vim.tbl_contains(available_parsers, language) then
                    -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
                    require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language) end)
                else
                    -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
                    treesitter_try_attach(buf, language)
                end
            end,
        })
    end,
    -- NOTE: To make the incremental selection Mini.ai was also configured
    keys = {
        {
            '<C-space>',
            'vin',
            mode = 'n',
            desc = 'Start incremental selection',
            remap = true,
        },
        {
            '<C-space>',
            'an',
            mode = 'x',
            desc = 'Expand incremental selection',
            remap = true,
        },
        {
            '<BS>',
            'in',
            mode = 'x',
            desc = 'Shrink incremental selection',
            remap = true,
        },
    },
}
