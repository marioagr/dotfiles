--[[
    "Native" keymaps for Neovim
    NO PLUGINS
--]]

---@param keybind string Which keys will trigger it
---@param rhs string|function What it will do
---@param opts? table See: vim.api.nvim_set_keymap opts
---@param mode? string|string[] Mode "short-name"
---@see vim.api.nvim_set_keymap
__setKeymap = function(keybind, rhs, opts, mode)
    vim.keymap.set(mode or 'n', keybind, rhs, opts or {})
end

-- Do nothing when space key is pressed
__setKeymap('<Space>', '<NOP>', { silent = true }, { 'n', 'v' })

__setKeymap('<Esc><Esc>', '<C-\\><C-n>', { desc = 'Easily escape Terminal mode' }, 't')

-- Save buffer
__setKeymap('<leader>w', ':w<CR>', { desc = '[w]rite buffer' })

-- When text is wrapped, move by terminal rows instead, not lines, unless a count is provided.
__setKeymap('k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Move up by rows, not lines, unless count is provided' })
__setKeymap('j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Move down by rows, not lines, unless count is provided' })

-- Diagnostic keymaps
__setKeymap('<leader>dl', vim.diagnostic.setloclist, { desc = 'Open [d]iagnostics [l]ist' })

-- Re-select visual selection after indenting.
__setKeymap('<', '<gv', { desc = 'De-indent without losing selection' }, 'v')
__setKeymap('>', '>gv', { desc = 'Indent without losing selection' }, 'v')

-- Maintain the cursor position when yanking a visual selection.
-- [M]ark at [y] position then use [`y] and go to that mark
__setKeymap('y', 'myy`y', { desc = 'Maintain cursor position when yanking a visual selection' }, 'v')

-- Disable annoying command line history typo.
-- __setKeybind('q:', 'q:')

-- Paste replace visual selection without copying it.
-- ["] choose the [_] register (which acts like a black-hole) then [d]elete it and [P]aste it
__setKeymap('p', '"_dP', { desc = 'Preserve yank without replacing it by the selected text' }, 'v')

-- Easy insertion of a trailing ; or ,
__setKeymap(';;', '<Esc>A;<Esc>', { desc = 'Insert [;] at the eol' })
__setKeymap(';;', '<Esc>A;', { desc = 'Insert [;] at the eol' }, 'i')

-- Quickly clear search highlighting.
__setKeymap('<leader>k', ':nohlsearch<CR>', { desc = 'Clear search highlighting' })

-- These mappings control the size of splits
-- Alt + ([w]ider || [n]arrow || [t]aller || [s]horter)
__setKeymap('<M-w>', '<c-w>5>', { desc = 'Increase width' })
__setKeymap('<M-n>', '<c-w>5<', { desc = 'Decrease width' })
__setKeymap('<M-t>', '<C-W>+', { desc = 'Increase height' })
__setKeymap('<M-s>', '<C-W>-', { desc = 'Increase height' })

-- Move lines up and down
__setKeymap('<M-Down>', '<Esc>:move .+1<CR>==gi', { desc = 'Move line down in Insert mode' }, 'i')
__setKeymap('<M-Up>', '<Esc>:move .-2<CR>==gi', { desc = 'Move line up in Insert mode' }, 'i')
__setKeymap('<M-Down>', ":move '>+1<CR>gv=gv", { desc = 'Move line down in Visual mode' }, 'v')
__setKeymap('<M-Up>', ":move '<-2<CR>gv=gv", { desc = 'Move line up in Visual mode' }, 'v')

--[[
--  NOTE: To be able to use vim-unimpaired or mini.bracketed
--  Ideally this could be achieved setting the option langmap (plus langremap as per the help)
--  vim.o.langmap = '{[,}],[{,]}' -- In normal mode remaps { to [, } to ], [ to {, ] to }
--  vim.o.langremap = false --  By default is off but just to be sure
--  But due to a bug in vim (https://github.com/echasnovski/mini.nvim/issues/235#issuecomment-1462367177)
--  this is the recommended way
--]]
__setKeymap('{', '[', { remap = true })
__setKeymap('}', ']', { remap = true })

__setKeymap('<leader>t{}', function()
    if vim.fn.mapcheck('{', 'n') == '' then
        __setKeymap('{', '[', { remap = true })
        __setKeymap('}', ']', { remap = true })
    else
        vim.keymap.del('n', '{')
        vim.keymap.del('n', '}')
    end
    local function curly_braces_state()
        if vim.fn.mapcheck('{', 'n') == '' then
            return 'Original'
        else
            return 'Altered'
        end
    end
    CurlyBracesNotification = vim.notify(curly_braces_state(), nil, {
        title = 'Curly Braces',
        replace = CurlyBracesNotification,
        on_close = function()
            CurlyBracesNotification = nil
        end,
    })
end)

-- Toggle spelling
__setKeymap('<leader>tS', function()
    vim.cmd([[setlocal spell!]])
    local function spelling_status()
        -- I feel like its a bit hacky to use "._value" but meh
        if vim.opt_local.spell._value then
            return 'Enabled'
        else
            return 'Disabled'
        end
    end
    SpellNotification = vim.notify(spelling_status(), nil, {
        title = 'Spelling',
        replace = SpellNotification,
        on_close = function()
            SpellNotification = nil
        end,
    })
end, { desc = '[t]oggle [S]pelling checking' })

-- Go to /.../file:line under cursor
-- NOTE: This may end up as a black hole for this kind of gf/grd alternatives
__setKeymap('<M-Enter>', function()
    local file_w_line = vim.fn.expand('<cWORD>')
    -- Pattern /.../file:123
    local file, line = string.match(file_w_line, '([^:]+):(%d+)')

    if not line then
        -- Pattern /.../file(123)
        file, line = string.match(file_w_line, '([^%(]+)%((%d+)%)')
    end

    local is_in_docker = vim.fn.filereadable('docker-compose.yml') == 1
    local cwd = vim.fn.getcwd()

    if is_in_docker then
        file = file:gsub('^/var/www/html', cwd)
    end

    local is_readable = vim.fn.filereadable(file) == 1

    if is_readable then
        if line ~= '' then
            vim.cmd(string.format('edit +%s %s', line, file))
        else
            vim.cmd(string.format('edit %s', file))
        end
    else
        print('File not found: ' .. file)
    end
end, { desc = 'Go to file:line under cursor' })
