-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 4

-- Number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 4

-- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
vim.opt.softtabstop = 4

vim.opt.smartindent = true

vim.opt.wrap = false

-- Print the line number in front of each line.
vim.opt.number = true
vim.opt.relativenumber = true

-- Complete the longest common match, and allow tabbing the results to fully complete them
vim.opt.wildmode = 'longest:full,full'

-- A comma-separated list of options for Insert mode completion |ins-completion|.
vim.opt.completeopt = 'menuone,longest,preview'

vim.opt.title = true
vim.opt.mouse = 'a' -- enable mouse for all modes

vim.opt.termguicolors = true

vim.opt.spell = true

-- Ignore case in search patterns.
vim.opt.ignorecase = true
-- Override the 'ignorecase' option if the search pattern contains upper case characters.
vim.opt.smartcase = true

vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = '▸ ', trail = '·' }
-- Remove the ~ from the end buffer
-- May be unnecessary because OneDark theme has the option "ending_tildes"
vim.opt.fillchars:append({ eob = ' ' })

vim.opt.splitbelow = true
vim.opt.splitright = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- The minimal number of screen columns to keep to the left and to the right of the cursor if 'nowrap' is set.
vim.opt.sidescrolloff = 5

-- Sync clipboard between OS and Neovim
-- TODO Check the compatibility between WSL and Neovim clipboard
vim.opt.clipboard = 'unnamedplus'

-- When and how to draw the signcolumn. always, with fixed space for 2 signs
vim.opt.signcolumn = 'yes:2'

-- Ask for confirmation instead of showing errors
vim.opt.confirm = true

-- Persistent undo
vim.opt.undofile = true

-- Automatically save a backup file
vim.opt.backup = true

-- Keep backups out of the current directory
vim.opt.backupdir:remove('.')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
  group = highlight_group,
  pattern = '*',
})
