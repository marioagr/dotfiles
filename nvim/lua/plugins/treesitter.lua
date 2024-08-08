return {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
        -- NOTE: Not sure if it is necessary, but not included by now
        -- 'JoosepAlviste/nvim-ts-context-commentstring',
    },
    build = ':TSUpdate',
    opts = {
        -- Add languages to be installed here that you want installed for treesitter
        ensure_installed = 'all',

        -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
        auto_install = true,
        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- List of parsers to ignore installing
        ignore_install = {},
        -- You can specify additional treesitter modules here: -- For example: -- playground = {--enable = true,-- },
        modules = {},
        highlight = {
            enable = true,
            -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
            --  If you are experiencing weird indenting issues, add the language to
            --  the list of additional_vim_regex_highlighting and disabled languages for indent.
            additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<c-space>',
                node_incremental = '<c-space>',
                scope_incremental = '<c-s>',
                node_decremental = '<M-space>',
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ['aa'] = '@parameter.outer',
                    ['ia'] = '@parameter.inner',
                    ['af'] = '@function.outer',
                    ['if'] = '@function.inner',
                    ['ac'] = '@class.outer',
                    ['ic'] = '@class.inner',
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    [']m'] = '@function.outer',
                    [']]'] = '@class.outer',
                },
                goto_next_end = {
                    [']M'] = '@function.outer',
                    [']['] = '@class.outer',
                },
                goto_previous_start = {
                    ['[m'] = '@function.outer',
                    ['[['] = '@class.outer',
                },
                goto_previous_end = {
                    ['[M'] = '@function.outer',
                    ['[]'] = '@class.outer',
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ['<leader>a'] = '@parameter.inner',
                },
                swap_previous = {
                    ['<leader>A'] = '@parameter.inner',
                },
            },
        },
    },
    config = function(_, opts)
        -- [[ Configure treesitter ]] See `:help nvim-treesitter`
        -- Defer treesitter setup after first render to improve startup time of 'nvim {filename}'
        vim.defer_fn(function()
            -- Prefer git instead of curl in order to improve connectivity in some environments
            require('nvim-treesitter.install').prefer_git = true

            require('nvim-treesitter.configs').setup(opts)
            -- require('ts_context_commentstring').setup()

            local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
            ---@diagnostic disable-next-line: inject-field
            parser_config.blade = {
                install_info = {
                    url = 'https://github.com/EmranMR/tree-sitter-blade',
                    files = { 'src/parser.c' },
                    branch = 'main',
                },
                filetype = 'blade',
            }
        end, 0)
    end,
}
