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

        vim.api.nvim_create_autocmd('FileType', {
            callback = function()
                -- Enable treesitter highlighting and disable regex syntax
                pcall(vim.treesitter.start)
                -- Enable treesitter-based indentation
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
