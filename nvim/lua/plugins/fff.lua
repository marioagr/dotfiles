return {
    'dmtrKovalenko/fff.nvim',
    build = function()
        -- downloads a prebuilt binary or falls back to cargo build
        require('fff.download').download_or_build_binary()
    end,
    -- for nixos:
    -- build = "nix run .#release",
    opts = {
        -- debug = {
        --     enabled = true,
        --     show_scores = true,
        -- },
        layout = {
            width = 0.9,
        },
        git = {
            status_text_color = true,
        },
    },
    lazy = false, -- the plugin lazy-initialises itself
    keys = {
        { 'sf', function() require('fff').find_files() end, desc = '[s]earch [f]iles using fff' },
        { 'sg', function() require('fff').live_grep() end, desc = '[s]earch [g]rep using fff' },
        -- { 'sz', function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end, desc = 'Live fffuzy grep' },
        { 'srf', function() require('fff').find_files({ resume = true }) end, desc = '[r]esume FFFind [f]iles' },
        { 'srg', function() require('fff').live_grep({ resume = true }) end, desc = '[r]esume LiFFFe [g]rep' },
        { 'sw', function() require('fff').live_grep_under_cursor() end, mode = { 'n', 'x' }, desc = 'Search current word / selection' },
        { '<leader>frf', ':FFFScan<CR>', desc = '[f]ff [r]escan [f]iles' },
        { '<leader>frg', ':FFFRefreshGit<CR>', desc = '[f]ff [r]efresh [g]it status' },
    },
}
