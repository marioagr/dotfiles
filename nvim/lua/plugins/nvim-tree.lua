-- File tree sidebar
return {
    'kyazdani42/nvim-tree.lua',
    dependencies = {
        'kyazdani42/nvim-web-devicons',
    },
    opts = {
        renderer = {
            group_empty = true,
            icons = {
                show = {
                    folder_arrow = false,
                },
                -- git_placement = 'after',
            },
            indent_markers = {
                enable = true,
            },
        },
        filters = {
            custom = { '^.git$' }
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
        }
    },
    keys = {
        { '<leader>tt', ':NvimTreeToggle<CR>',         desc = 'Toggle NvimTree' },
        --[[
            Currently not being used.
            Reason: <C-w>(h|<Left>|l|<Right>) to change between buffer windows.
            { '<leader>tf', ':NvimTreeFocus<CR>', desc = 'Focus NvimTree' },
        --]]
        { '<leader>tc', ':NvimTreeFindFileToggle<CR>', desc = 'Focus current file in NvimTree' },
    },
}
