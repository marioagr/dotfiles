-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
    'lewis6991/gitsigns.nvim',
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        numhl = true,
        sign_priority = 15,
        on_attach = function(bufnr)
            local gs = require('gitsigns')

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                __setKeymap(l, r, opts, mode)
            end

            -- Navigation
            map({ 'n', 'v' }, '[h', function()
                vim.schedule(function()
                    gs.nav_hunk('prev', {
                        target = 'all',
                    })
                end)
                return '<Ignore>'
            end, { expr = true, desc = 'Jump to previous hunk' })

            map({ 'n', 'v' }, ']h', function()
                vim.schedule(function()
                    gs.nav_hunk('next', {
                        target = 'all',
                    })
                end)
                return '<Ignore>'
            end, { expr = true, desc = 'Jump to next hunk' })

            map({ 'n', 'v' }, '[H', function()
                vim.schedule(function()
                    gs.nav_hunk('first', {
                        target = 'all',
                    })
                end)
                return '<Ignore>'
            end, { expr = true, desc = 'Jump to first hunk' })

            map({ 'n', 'v' }, ']H', function()
                vim.schedule(function()
                    gs.nav_hunk('last', {
                        target = 'all',
                    })
                end)
                return '<Ignore>'
            end, { expr = true, desc = 'Jump to last hunk' })

            -- Actions

            -- Visual mode
            map('v', '<leader>hs', function()
                gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = '[s]tage hunk' })
            map('v', '<leader>hr', function()
                gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = '[r]eset hunk' })

            -- Normal mode
            map('n', '<leader>h_', gs.refresh, { desc = 'gitsigns refresh' })
            map('n', '<leader>hs', gs.stage_hunk, { desc = '[s]tage/un[s]tage hunk' })
            map('n', '<leader>hr', gs.reset_hunk, { desc = '[r]eset hunk' })
            map('n', '<leader>hp', gs.preview_hunk, { desc = '[p]review hunk' })
            map('n', '<leader>hS', gs.stage_buffer, { desc = '[S]tage buffer' })
            map('n', '<leader>hR', gs.reset_buffer, { desc = '[R]eset buffer' })
            map('n', '<leader>hb', function()
                gs.blame_line({ full = false })
            end, { desc = '[b]lame line' })
            map('n', '<leader>hd', gs.diffthis, { desc = '[d]iff against index' })
            map('n', '<leader>hD', function()
                gs.diffthis('~')
            end, { desc = '[D]iff against last commit' })

            -- Toggles
            -- TODO: Toggle line and word along with colorizer
            map('n', '<leader>gsl', gs.toggle_linehl, { desc = '[g]it[s]igns toggle [l]ine highlight' })
            map('n', '<leader>gsw', gs.toggle_word_diff, { desc = '[g]it[s]igns toggle [w]ord diff' })
            map('n', '<leader>gsb', gs.toggle_current_line_blame, { desc = '[g]it[s]igns toggle [b]lame line' })
            map('n', '<leader>gsd', gs.preview_hunk_inline, { desc = '[g]it[s]igns show [d]eleted' })

            -- Text object
            map({ 'o', 'x' }, 'sh', ':<C-U>Gitsigns select_hunk<CR>', { desc = '[s]elect hunk' })
        end,
    },
}
