--[[
    "Native" keymaps for neovim
    NO PLUGINS
--]]

-- When text is wrapped, move by terminal rows instead, not lines, unless a count is provided.
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Move up by rows, not lines, unless count is provided' })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Move down by rows, not lines, unless count is provided' })

-- Reselect visual selection after indenting.
vim.keymap.set('v', '<', '<gv', { desc = 'De-indent without losing selection'})
vim.keymap.set('v', '>', '>gv', { desc = 'Indent without losing selection'})

-- Maintain the cursor position when yanking a visual selection.
-- [M]ark at [y] position then use [`y] and go to that mark
vim.keymap.set('v', 'y', 'myy`y', { desc = 'Maintain cursor position when yanking a visual selection'})

-- Disable annoying command line history typo.
-- vim.keymap.set('n', 'q:', 'q:')

-- Paste replace visual selection without copying it.
-- ["] choose the [_] register (which acts like a black-hole) then [d]elete it and [P]aste it
vim.keymap.set('v', 'p', '"_dP', { desc = 'Preserve yank without replacing it by the selected text' })

-- Easy insertion of a trailing ; or , from insert mode.
vim.keymap.set('i', ';;', '<Esc>A;', { desc = 'Insert [;] at the eol' })
vim.keymap.set('i', ',,', '<Esc>A,', { desc = 'Insert [,] at the eol' })

-- Quickly clear search highlighting.
vim.keymap.set('n', '<Leader>k', ':nohlsearch<CR>', { desc = 'Clear search highlighting' })

-- Move lines up and down using Alt+[j|k].
vim.keymap.set('i', '<A-j>', '<Esc>:move .+1<CR>==gi', { desc = 'Move line down in Insert mode' })
vim.keymap.set('i', '<A-k>', '<Esc>:move .-2<CR>==gi', { desc = 'Move line up in Insert mode' })
vim.keymap.set('n', '<A-j>', ':move .+1<CR>==', { desc = 'Move line down in Normal mode' })
vim.keymap.set('n', '<A-k>', ':move .-2<CR>==', { desc = 'Move line up in Normal mode' })
vim.keymap.set('v', '<A-j>', ":move '>+1<CR>gv=gv", { desc = 'Move line down in Visual mode' })
vim.keymap.set('v', '<A-k>', ":move '<-2<CR>gv=gv", { desc = 'Move line up in Visual mode' })

