return {
    'nvim-treesitter/nvim-treesitter-textobjects',
    -- dependencies = {
    --     { 'windwp/nvim-ts-autotag', opts = {} },
    --     -- NOTE: Not sure if it is necessary, but not included by now
    --     -- 'JoosepAlviste/nvim-ts-context-commentstring',
    --     -- An alternative could be
    --     -- 'folke/ts-comments.nvim'
    -- },
    branch = 'main',
    init = function()
        -- Disable entire built-in ftplugin mappings to avoid conflicts.
        -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
        vim.g.no_plugin_maps = true
    end,
    config = function()
        require('nvim-treesitter-textobjects').setup({
            select = {
                enable = true,
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
            },
            swap = {
                enable = true,
            },
        })
    end,
    keys = {
        -- Select textobjects
        {
            'aa',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects') end,
            mode = { 'x', 'o' },
            desc = 'Around p[a]rameter',
        },
        {
            'ia',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects') end,
            mode = { 'x', 'o' },
            desc = 'Inner p[a]rameter',
        },
        {
            'af',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') end,
            mode = { 'x', 'o' },
            desc = 'Around a [f]unction region',
        },
        {
            'if',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') end,
            mode = { 'x', 'o' },
            desc = 'Inside a [f]unction region',
        },
        {
            'ac',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@comment.outer', 'textobjects') end,
            mode = { 'x', 'o' },
            desc = 'Around a [c]omment region',
        },
        {
            'ic',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@comment.inner', 'textobjects') end,
            mode = { 'x', 'o' },
            desc = 'Inside a [c]omment region',
        },
        {
            'aC',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') end,
            mode = { 'x', 'o' },
            desc = 'Around a [C]lass region',
        },
        {
            'iC',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') end,
            mode = { 'x', 'o' },
            desc = 'Inside a [C]lass region',
        },
        {
            'ai',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@conditional.outer', 'textobjects') end,
            mode = { 'x', 'o' },
            desc = 'Around an [i]f (conditional) region',
        },
        {
            'ii',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@conditional.inner', 'textobjects') end,
            mode = { 'x', 'o' },
            desc = 'Inside an [i]f (conditional) region',
        },
        -- You can also use captures from other query groups like `locals.scm`
        {
            'as',
            function() require('nvim-treesitter-textobjects.select').select_textobject('@local.scope', 'locals') end,
            mode = { 'x', 'o' },
            desc = 'Around a [s]cope region',
        },

        -- Move textobjects
        {
            ']a',
            function() require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.inner', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the start of the next parameter',
        },
        {
            ']m',
            function() require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the start of the next function',
        },
        {
            ']]',
            function() require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the start of the next class',
        },
        -- You can also use captures from other query groups like `locals.scm` or `folds.scm`
        {
            ']s',
            function() require('nvim-treesitter-textobjects.move').goto_next_start('@local.scope', 'locals') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the start of the next scope',
        },
        {
            ']A',
            function() require('nvim-treesitter-textobjects.move').goto_next_end('@parameter.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the end of the next parameter',
        },
        {
            ']M',
            function() require('nvim-treesitter-textobjects.move').goto_next_end('@function.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the end of the next function',
        },
        {
            '][',
            function() require('nvim-treesitter-textobjects.move').goto_next_end('@class.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the end of the next class',
        },
        {
            '[a',
            function() require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the start of the previous parameter',
        },
        {
            '[m',
            function() require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the start of the previous function',
        },
        {
            '[[',
            function() require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the start of the previous class',
        },
        {
            '[s',
            function() require('nvim-treesitter-textobjects.move').goto_previous_start('@local.scope', 'locals') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the start of the previous scope',
        },
        {
            '[A',
            function() require('nvim-treesitter-textobjects.move').goto_previous_end('@parameter.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the end of the previous parameter',
        },
        {
            '[M',
            function() require('nvim-treesitter-textobjects.move').goto_previous_end('@function.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the end of the previous function',
        },
        {
            '[]',
            function() require('nvim-treesitter-textobjects.move').goto_previous_end('@class.outer', 'textobjects') end,
            mode = { 'n', 'x', 'o' },
            desc = 'Go to the end of the previous class',
        },

        -- Swap textobjects
        {
            '<leader>ps',
            function() require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner') end,
            mode = 'n',
            desc = '[p]arameter [s]wap with next',
        },
        {
            '<leader>pS',
            function() require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner') end,
            mode = 'n',
            desc = '[p]arameter [S]wap with previous',
        },

        -- Toggle treesitter highlight
        {
            '<leader>tH',
            ':TSToggle highlight<CR>',
            mode = 'n',
            desc = 'tree-sitter [H]ighlight',
        },
    },
}
