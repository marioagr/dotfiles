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
            custom = { '^.git$' },
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
        },
        view = {
            side = 'right',
            preserve_window_proportions = true,
            width = 50,
        },
    },
    keys = {
        { '<leader>ee', ':NvimTreeToggle<CR>', desc = 'Open [e]xplor[e]r Nvimtree' },
        { '<leader>ef', ':NvimTreeFindFileToggle<CR>', desc = 'Open [e]xplorer looking at current [f]ile' },
    },
}
