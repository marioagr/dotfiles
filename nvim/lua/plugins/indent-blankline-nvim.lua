-- Display indentation lines
return {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
        exclude = {
            filetypes = {
                'help',
                'terminal',
                'dashboard',
                'packer',
                'lspinfo',
                'TelescopePrompt',
                'TelescopeResults',
            },
            buftypes = {
                'terminal',
                'NvimTree',
            },
        }
    }
}
