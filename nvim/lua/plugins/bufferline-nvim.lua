-- Display buffers as tabs
return {
    'akinsho/bufferline.nvim',
    dependencies = {
        'kyazdani42/nvim-web-devicons',
        -- 'onedark.nvim',
    },
    opts = {
        options = {
            show_close_item = false,
            max_name_length = 25,
            numbers = 'ordinal',
            separator_style = 'slope',
            offsets = {
                {
                    filetype = 'NvimTree',
                    text = ' Files',
                    highlight = 'StatusLine',
                    text_align = 'left',
                },
            },
            custom_areas = {
                left = function()
                    return {
                        { text = '  ', fg = '#3e93d3' },
                    }
                end,
            },
            hover = {
                enabled = true,
                delay = 200,
                reveal = { 'close' },
            },
            diagnostics = 'nvim_lsp',
            -- Show indicators in tabs
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                local icon = level:match('error') and ' ' or ' '
                return ' ' .. icon .. count
            end,
        },
    },
}
