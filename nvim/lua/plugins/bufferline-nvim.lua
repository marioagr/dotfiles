-- Display buffers as tabs
return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        -- 'onedark.nvim',
    },
    lazy = false,
    config = function()
        ---@type bufferline.UserConfig
        local my_opts = {
            options = {
                modified_icon = '●',
                left_trunc_marker = '',
                right_trunc_marker = '',
                show_buffer_close_icons = false,
                custom_areas = {
                    left = function()
                        return {
                            { text = '   ', fg = '#3e93d3' },
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
                -- Show indicators in tabs
                diagnostics_indicator = function(count, level)
                    local icon = level:match('error') and '' or ''
                    return count .. icon
                end,
                groups = {
                    items = {
                        require('bufferline.groups').builtin.pinned:with({ icon = '󰐃' }),
                    },
                },
                max_name_length = 15,
                offsets = {
                    {
                        filetype = 'NvimTree',
                        highlight = 'StatusLine',
                        text = ' Files',
                        text_align = 'left',
                    },
                },
            },
        }

        require('bufferline').setup(my_opts)
    end,
    keys = {
        {
            '[b',
            function()
                vim.cmd('BufferLineCyclePrev')
            end,
            desc = 'Navigate to previous buffer',
        },
        {
            ']b',
            function()
                vim.cmd('BufferLineCycleNext')
            end,
            desc = 'Navigate to next buffer',
        },
        {
            '[B',
            function()
                require('bufferline').go_to(1)
            end,
            desc = 'Navigate to first buffer',
        },
        {
            ']B',
            function()
                require('bufferline').go_to(-1)
            end,
            desc = 'Navigate to last buffer',
        },
        {
            '<M-PageUp>',
            function()
                vim.cmd('BufferLineMovePrev')
            end,
            desc = 'Move buffer backwards',
        },
        {
            '<M-PageDown>',
            function()
                vim.cmd('BufferLineMoveNext')
            end,
            desc = 'Move buffer forwards',
        },
        {
            '<leader>tb',
            function()
                vim.cmd('BufferLineTogglePin')
            end,
            desc = '[t]oggle pin [b]uffer',
        },
    },
}
