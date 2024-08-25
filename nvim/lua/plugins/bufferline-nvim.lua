-- Display buffers as tabs
return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'kyazdani42/nvim-web-devicons',
        -- 'onedark.nvim',
    },
    config = function()
        ---@type bufferline.UserConfig
        local my_opts = {
            options = {
                custom_areas = {
                    left = function()
                        return {
                            { text = '  ', fg = '#3e93d3' },
                        }
                    end,
                },
                custom_filter = function(buf, bufnums)
                    local omit_these = { 'grug-far', 'gurg-far-history', 'grug-far-help' }

                    if vim.tbl_contains(omit_these, vim.bo[buf].filetype) then
                        return false
                    end

                    return true
                end,
                diagnostics = 'nvim_lsp',
                -- Show indicators in tabs
                diagnostics_indicator = function(count, level, diagnostics_dict, context)
                    local icon = level:match('error') and ' ' or ' '
                    return ' ' .. icon .. count
                end,
                max_name_length = 25,
                numbers = 'ordinal',
                offsets = {
                    {
                        filetype = 'NvimTree',
                        highlight = 'StatusLine',
                        text = ' Files',
                        text_align = 'left',
                    },
                },
                separator_style = 'slope',
            },
        }

        require('bufferline').setup(my_opts)
    end,
}
