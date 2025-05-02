-- Display indentation lines
return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
        indent = {
            char = '▏',
        },
        exclude = {
            filetypes = {
                'help',
                'terminal',
                'dashboard',
                'packer',
                'TelescopePrompt',
                'TelescopeResults',
            },
            buftypes = {
                'terminal',
                'NvimTree',
            },
        },
    },
}
