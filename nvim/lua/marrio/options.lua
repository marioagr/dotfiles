-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 4

-- Number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 4

-- Number of spaces that a <Tab> counts for while performing editing operations, like inserting a <Tab> or using <BS>.
vim.opt.softtabstop = 4

-- Decrease update time
-- Used for highlight on CursorHold/CursorHoldI
vim.opt.updatetime = 2000

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Do smart autoindenting when starting a new line.
vim.opt.smartindent = true

-- This option changes how text is displayed.  It doesn't change the text in the buffer, see 'textwidth' for that.
vim.opt.wrap = false

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Every wrapped line will continue visually indented (same amount of space as the beginning of that line), thus preserving horizontal blocks of text.
vim.opt.breakindent = true

-- Print the line number in front of each line.
vim.opt.number = true
vim.opt.relativenumber = true

-- Complete the longest common match, and allow tabbing the results to fully complete them
vim.opt.wildmode = 'longest:full,full'

-- A comma-separated list of options for Insert mode completion |ins-completion|.
vim.opt.completeopt = 'menuone,longest,noselect'

vim.opt.title = true
vim.opt.mouse = 'a' -- enable mouse for all modes

vim.opt.termguicolors = true

vim.opt.spell = false
vim.opt.spelllang = 'en_us,es_mx'
vim.opt.spellfile = vim.fn.expand('~/.local/share/nvim/site/spell/en.utf-8.add') .. ',' .. vim.fn.expand('~/.local/share/nvim/site/spell/es.utf-8.add')

-- Ignore case in search patterns.
vim.opt.ignorecase = true
-- Override the 'ignorecase' option if the search pattern contains upper case characters.
vim.opt.smartcase = true

vim.opt.list = true -- enable the below listchars
vim.opt.listchars = { tab = '▸ ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Remove the ~ from the end buffer
-- May be unnecessary because OneDark theme has the option "ending_tildes"
vim.opt.fillchars:append({ eob = ' ' })

-- Configure how new splits should be opened
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 5

-- The minimal number of screen columns to keep to the left and to the right of the cursor if 'nowrap' is set.
vim.opt.sidescrolloff = 5

-- Sync clipboard between OS and Neovim
-- Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- When and how to draw the signcolumn. always, with fixed space for 2 signs
vim.opt.signcolumn = 'yes:3'

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
vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank({ timeout = 250 })
    end,
})

-- Change from dynamic due to a ¿performance? issue
vim.g.omni_sql_default_compl_type = 'syntax'

vim.diagnostic.config({ virtual_text = true })

vim.diagnostic.config({
    float = {
        border = 'rounded',
    },
})

--[[
--- NOTE: Maybe wait for the isses/pull requests about winborder
--- @see https://github.com/nvim-telescope/telescope.nvim/issues/3436
--- @see https://github.com/nvim-lua/plenary.nvim/pull/649
--]]
-- vim.opt.winborder = 'rounded'
