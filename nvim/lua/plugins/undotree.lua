return {
    'mbbill/undotree',
    config = function()
        vim.g.undotree_WindowLayout = 4
        vim.g.undotree_SplitWidth = 45
    end,
    keys = {
        { '<leader>u', vim.cmd.UndotreeToggle, desc = 'Toggle [u]ndoTree' },
    },
}
