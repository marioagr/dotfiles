-- Use spaces instead of tabs
vim.o.expandtab = true

-- Number of spaces to use for each step of (auto)indent.
vim.o.shiftwidth = 4

-- Number of spaces that a <Tab> in the file counts for.
vim.o.tabstop = 4

-- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
vim.o.softtabstop = 4

-- Decrease update time
-- Used for highlight on CursorHold/CursorHoldI
vim.o.updatetime = 2000

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Do smart autoindenting when starting a new line.
vim.o.smartindent = true

-- This option changes how text is displayed.  It doesn't change the text in the buffer, see 'textwidth' for that.
vim.o.wrap = false

-- Don't show the mode, since it's already in status line
vim.o.showmode = false

-- Every wrapped line will continue visually indented (same amount of space as the beginning of that line), thus preserving horizontal blocks of text.
vim.o.breakindent = true

-- Print the line number in front of each line.
vim.o.number = true
vim.o.relativenumber = true

-- Complete the longest common match, and allow tabbing the results to fully complete them
vim.o.wildmode = 'longest:full,full'

-- A comma-separated list of options for Insert mode completion |ins-completion|.
vim.o.completeopt = 'menuone,longest,noselect'

vim.o.title = true
vim.o.mouse = 'a' -- enable mouse for all modes

vim.o.termguicolors = true

vim.o.spell = false
vim.o.spelllang = 'en_us,es_mx'
vim.o.spellfile = table.concat({
    vim.fn.expand('~/.local/share/nvim/site/spell/en.utf-8.add'),
    vim.fn.expand('~/.local/share/nvim/site/spell/es.utf-8.add'),
}, ',')

-- Ignore case in search patterns.
vim.o.ignorecase = true
-- Override the 'ignorecase' option if the search pattern contains upper case characters.
vim.o.smartcase = true

vim.o.list = true -- enable the below listchars
vim.o.listchars = 'eol:↩,tab:↹ ,trail:•,nbsp:␣'
vim.o.showbreak = '↪'

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Remove the ~ from the end buffer
-- May be unnecessary because OneDark theme has the option "ending_tildes"
vim.opt.fillchars:append({ eob = ' ' })

-- Configure how new splits should be opened
vim.o.splitbelow = true
vim.o.splitright = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 3

-- The minimal number of screen columns to keep to the left and to the right of the cursor if 'nowrap' is set.
vim.o.sidescrolloff = 5

-- Sync clipboard between OS and Neovim
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

-- When and how to draw the signcolumn. always, with fixed space for 2 signs
vim.o.signcolumn = 'yes:3'

-- Ask for confirmation instead of showing errors
vim.o.confirm = true

-- Persistent undo
vim.o.undofile = true

-- Automatically save a backup file
vim.o.backup = true
-- Keep backups out of the current directory
vim.opt.backupdir:remove('.')

-- [[ Highlight on yank ]]
-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank({ timeout = 250 }) end,
})

-- Change from dynamic due to a ¿performance? issue
vim.g.omni_sql_default_compl_type = 'syntax'

vim.diagnostic.config({ virtual_text = true })

vim.o.winborder = 'rounded'

-- Keep the default values and append the "globals" to save pinned buffers
vim.opt_global.sessionoptions:append('globals')
vim.g.DisableAutoFormatGlobally = 0
