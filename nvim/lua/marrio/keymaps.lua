--[[
    "Native" keymaps for neovim
    NO PLUGINS
--]]

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- When text is wrapped, move by terminal rows instead, not lines, unless a count is provided.
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Move up by rows, not lines, unless count is provided' })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Move down by rows, not lines, unless count is provided' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open [d]iagnostics [l]ist' })

-- Reselect visual selection after indenting.
vim.keymap.set('v', '<', '<gv', { desc = 'De-indent without losing selection' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent without losing selection' })

-- Maintain the cursor position when yanking a visual selection.
-- [M]ark at [y] position then use [`y] and go to that mark
vim.keymap.set('v', 'y', 'myy`y', { desc = 'Maintain cursor position when yanking a visual selection' })

-- Disable annoying command line history typo.
-- vim.keymap.set('n', 'q:', 'q:')

-- Paste replace visual selection without copying it.
-- ["] choose the [_] register (which acts like a black-hole) then [d]elete it and [P]aste it
vim.keymap.set('v', 'p', '"_dP', { desc = 'Preserve yank without replacing it by the selected text' })

-- Easy insertion of a trailing ; or , from insert mode.
-- vim.keymap.set('i', ';;', '<Esc>A;', { desc = 'Insert [;] at the eol' })
-- vim.keymap.set('i', ',,', '<Esc>A,', { desc = 'Insert [,] at the eol' })

-- Quickly clear search highlighting.
vim.keymap.set('n', '<leader>k', ':nohlsearch<CR>', { desc = 'Clear search highlighting' })

-- Move lines up and down using Alt+[j|k].
vim.keymap.set('i', '<A-Down>', '<Esc>:move .+1<CR>==gi', { desc = 'Move line down in Insert mode' })
vim.keymap.set('i', '<A-Up>', '<Esc>:move .-2<CR>==gi', { desc = 'Move line up in Insert mode' })
vim.keymap.set('n', '<A-Down>', ':move .+1<CR>==', { desc = 'Move line down in Normal mode' })
vim.keymap.set('n', '<A-Up>', ':move .-2<CR>==', { desc = 'Move line up in Normal mode' })
vim.keymap.set('v', '<A-Down>', ":move '>+1<CR>gv=gv", { desc = 'Move line down in Visual mode' })
vim.keymap.set('v', '<A-Up>', ":move '<-2<CR>gv=gv", { desc = 'Move line up in Visual mode' })

-- Buffer next and buffer previous
vim.keymap.set('n', '<C-PageDown>', ':bnext<CR>', { desc = 'next _n_ buffer ' })
vim.keymap.set('n', '<C-PageUp>', ':bNext<CR>', { desc = 'Previous _N_ buffer ' })

-- These mappings control the size of splits (height/width)
vim.keymap.set('n', '<M-,>', '<c-w>5<')
vim.keymap.set('n', '<M-.>', '<c-w>5>')
vim.keymap.set('n', '<M-t>', '<C-W>+')
vim.keymap.set('n', '<M-s>', '<C-W>-')

vim.keymap.set('n', '<M-j>', function()
    if vim.opt.diff:get() then
        vim.cmd([[normal! ]c]])
    else
        vim.cmd([[m .+1<CR>==]])
    end
end)

vim.keymap.set('n', '<M-k>', function()
    if vim.opt.diff:get() then
        vim.cmd([[normal! [c]])
    else
        vim.cmd([[m .-2<CR>==]])
    end
end)
