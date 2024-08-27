--[[
    "Native" keymaps for neovim
    NO PLUGINS
--]]

-- Do nothing when space key is pressed
vim.keymap.set({ 'n', 'v' }, '<Space>', '<NOP>', { silent = true })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Easily escape Terminal mode' })

-- Save buffer
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = ':write' })

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

-- Easy insertion of a trailing ; or ,
vim.keymap.set('n', ';;', '<Esc>A;<Esc>', { desc = 'Insert [;] at the eol' })
vim.keymap.set('i', ';;', '<Esc>A;', { desc = 'Insert [;] at the eol' })
-- vim.keymap.set('i', ',,', '<Esc>A,', { desc = 'Insert [,] at the eol' })

-- Quickly clear search highlighting.
vim.keymap.set('n', '<leader>k', ':nohlsearch<CR>', { desc = 'Clear search highlighting' })

-- These mappings control the size of splits
vim.keymap.set('n', '<M-.>', '<c-w>5>') -- Increase width
vim.keymap.set('n', '<M-,>', '<c-w>5<') -- Decrease width
vim.keymap.set('n', '<M-t>', '<C-W>+') -- Increase height
vim.keymap.set('n', '<M-s>', '<C-W>-') -- Decrease height

-- Move lines up and down
vim.keymap.set('n', '<M-Down>', function()
    if vim.opt.diff:get() then
        vim.cmd([[normal! ]c]])
    else
        vim.cmd([[m .+1<CR>==]])
    end
end, { desc = 'diff: next change, normal mode: Move line down' })
vim.keymap.set('n', '<M-Up>', function()
    if vim.opt.diff:get() then
        vim.cmd([[normal! [c]])
    else
        vim.cmd([[m .-2<CR>==]])
    end
end, { desc = 'diff: prev change, normal mode: Move line up' })
vim.keymap.set('i', '<M-Down>', '<Esc>:move .+1<CR>==gi', { desc = 'Move line down in Insert mode' })
vim.keymap.set('i', '<M-Up>', '<Esc>:move .-2<CR>==gi', { desc = 'Move line up in Insert mode' })
vim.keymap.set('v', '<M-Down>', ":move '>+1<CR>gv=gv", { desc = 'Move line down in Visual mode' })
vim.keymap.set('v', '<M-Up>', ":move '<-2<CR>gv=gv", { desc = 'Move line up in Visual mode' })

--[[
--  NOTE: To be able to use vim-unimpaired or mini.bracketed
--  Ideally this could be achieved setting the option langmap (plus langremap as per the help)
--  vim.o.langmap = '{[,}],[{,]}' -- In normal mode remaps { to [, } to ], [ to {, ] to }
--  vim.o.langremap = false --  By default is off but just to be sure
--  But due to a bug in vim (https://github.com/echasnovski/mini.nvim/issues/235#issuecomment-1462367177)
--  this is the recommended way
--]]
vim.keymap.set('n', '{', '[', { remap = true })
vim.keymap.set('n', '}', ']', { remap = true })
