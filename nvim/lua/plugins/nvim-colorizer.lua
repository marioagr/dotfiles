-- Highlight colors
return {
    'NvChad/nvim-colorizer.lua',
    opts = {
        parsers = {
            css = true, -- preset: enables names, hex, rgb, hsl, oklch, css_var
            css_fn = true, -- preset: enables rgb, hsl, oklch
            hex = {
                rrggbbaa = true, -- #RRGGBBAA (8-digit)
            },
            rgb = { enable = true }, -- rgb()/rgba() functions
            hsl = { enable = true }, -- hsl()/hsla() functions
            oklch = { enable = true }, -- oklch() function
            hwb = { enable = true }, -- hwb() function (CSS Color Level 4)
            lab = { enable = true }, -- lab() function (CIE Lab)
            lch = { enable = true }, -- lch() function (CIE LCH)
            css_color = { enable = true }, -- color() function (srgb, display-p3, a98-rgb, etc.)
            tailwind = {
                enable = true, -- parse Tailwind color names
                update_names = true, -- feed LSP colors back into name parser (requires both enable + lsp.enable)
                lsp = { -- accepts boolean, true is shortcut for { enable = true, disable_document_color = true }
                    enable = true, -- use Tailwind LSP documentColor
                },
            },
            sass = {
                enable = true, -- parse Sass color variables
            },
            xterm = { enable = true }, -- xterm 256-color codes (#xNN, \e[38;5;NNNm)
            ls_colors = { enable = true }, -- LS_COLORS/SGR snippets (e.g. =38;5;196, =48;2;0;0;255)
            css_var_rgb = { enable = true }, -- CSS vars with R,G,B (e.g. --color: 240,198,198)
        },
    },
    keys = {
        { '<leader>tc', ':ColorizerToggle<CR>', desc = 'highlight [c]olors' },
    },
}
