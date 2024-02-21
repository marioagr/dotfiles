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
    },
    keys = {
        { '<Leader>tt', ':NvimTreeToggle<CR>', desc = 'Toggle NvimTree' },
        --[[
            Currently not being used.
            Reason: <C-w>(<Left>|<Right>) to change between buffer windows.
            { '<Leader>tf', ':NvimTreeFocus<CR>', desc = 'Focus NvimTree' },
        --]]
        { '<Leader>tc', ':NvimTreeFindFileToggle<CR>', desc = 'Focus current file in NvimTree' },
    }
}
