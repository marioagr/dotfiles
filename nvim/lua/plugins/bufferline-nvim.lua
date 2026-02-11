-- Display buffers as tabs
return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    lazy = false,
    config = function()
        ---@type bufferline.UserConfig
        local my_opts = {
            options = {
                custom_areas = {
                    left = function()
                        return {
                            { text = '  ', fg = '#5fb950' },
                        }
                    end,
                },
                custom_filter = function(buf)
                    local omit_these = { 'grug-far', 'gurg-far-history', 'grug-far-help', 'qf' }

                    if vim.tbl_contains(omit_these, vim.bo[buf].filetype) then
                        return false
                    end

                    return true
                end,
                diagnostics = 'nvim_lsp',
                diagnostics_indicator = function(count, level)
                    local icon = level:match('error') and '' or ''
                    return count .. icon
                end,
                groups = {
                    items = {
                        require('bufferline.groups').builtin.pinned:with({ icon = '󰐃' }),
                    },
                },
                left_trunc_marker = '󰁎',
                max_name_length = 15,
                modified_icon = '●',
                offsets = {
                    {
                        filetype = 'NvimTree',
                        highlight = 'StatusLine',
                        text = ' Files',
                        text_align = 'left',
                    },
                },
                right_trunc_marker = '󰁕',
                show_buffer_close_icons = false,
            },
        }

        require('bufferline').setup(my_opts)
    end,
    keys = {
        {
            '[b',
            function() vim.cmd('BufferLineCyclePrev') end,
            desc = 'Navigate to previous buffer',
        },
        {
            ']b',
            function() vim.cmd('BufferLineCycleNext') end,
            desc = 'Navigate to next buffer',
        },
        {
            '[B',
            function() require('bufferline').go_to(1) end,
            desc = 'Navigate to first buffer',
        },
        {
            ']B',
            function() require('bufferline').go_to(-1) end,
            desc = 'Navigate to last buffer',
        },
        {
            '<M-PageUp>',
            function() vim.cmd('BufferLineMovePrev') end,
            desc = 'Move buffer backwards',
        },
        {
            '<M-PageDown>',
            function() vim.cmd('BufferLineMoveNext') end,
            desc = 'Move buffer forwards',
        },
        {
            '<leader>tb',
            function() vim.cmd('BufferLineTogglePin') end,
            desc = '[t]oggle pin [b]uffer',
        },
    },
}
