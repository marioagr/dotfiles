-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
    'lewis6991/gitsigns.nvim',
    opts = {
        numhl = true,
        on_attach = function(bufnr)
            local gs = require('gitsigns')

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map({ 'n', 'v' }, ']h', function()
                -- if vim.wo.diff then
                --     return ']c'
                -- end
                vim.schedule(function()
                    gs.next_hunk()
                end)
                return '<Ignore>'
            end, { expr = true, desc = 'Jump to next hunk' })

            map({ 'n', 'v' }, '[h', function()
                -- if vim.wo.diff then
                --     return '[c'
                -- end
                vim.schedule(function()
                    gs.prev_hunk()
                end)
                return '<Ignore>'
            end, { expr = true, desc = 'Jump to previous hunk' })

            -- Actions

            -- Visual mode
            map('v', '<leader>hs', function()
                gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = '[s]tage git hunk' })
            map('v', '<leader>hr', function()
                gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end, { desc = '[r]eset git hunk' })

            -- Normal mode
            map('n', '<leader>hs', gs.stage_hunk, { desc = 'git [s]tage hunk' })
            map('n', '<leader>hr', gs.reset_hunk, { desc = 'git [r]eset hunk' })
            map('n', '<leader>hS', gs.stage_buffer, { desc = 'git [S]tage buffer' })
            map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[u]ndo stage hunk' })
            map('n', '<leader>hR', gs.reset_buffer, { desc = 'git [R]eset buffer' })
            map('n', '<leader>hp', gs.preview_hunk, { desc = '[p]review git hunk' })
            map('n', '<leader>hb', function()
                gs.blame_line({ full = false })
            end, { desc = 'git [b]lame line' })
            map('n', '<leader>hd', gs.diffthis, { desc = 'git [d]iff against index' })
            map('n', '<leader>hD', function()
                gs.diffthis('~')
            end, { desc = 'git [D]iff against last commit' })

            -- Toggles
            -- TODO: Toggle line and word along with colorizer
            map('n', '<leader>gsl', gs.toggle_linehl, { desc = '[g]it[s]igns [l]ine highlight' })
            map('n', '<leader>gsw', gs.toggle_word_diff, { desc = '[g]it[s]igns [w]ord diff' })
            map('n', '<leader>gsb', gs.toggle_current_line_blame, { desc = '[g]it[s]igns [b]lame line' })
            map('n', '<leader>gsd', gs.toggle_deleted, { desc = '[g]it[s]igns show [d]eleted' })

            -- Text object
            map({ 'o', 'x' }, 'sh', ':<C-U>Gitsigns select_hunk<CR>', { desc = '[s]elect git hunk' })
        end,
    },
}
