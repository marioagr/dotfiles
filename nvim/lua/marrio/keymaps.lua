--[[
    "Native" keymaps for Neovim
    NO PLUGINS
--]]

---@param keybind string Which keys will trigger it
---@param rhs string|function What it will do
---@param opts? table See: vim.api.nvim_set_keymap opts
---@param mode? string|string[] Mode "short-name"
---@see vim.api.nvim_set_keymap
-- stylua: ignore start
__setKeymap = function(keybind, rhs, opts, mode)
    vim.keymap.set(mode or 'n', keybind, rhs, opts or {})
end
-- stylua: ignore end

-- Do nothing when space key is pressed
__setKeymap('<Space>', '<NOP>', { silent = true }, { 'n', 'v' })

__setKeymap('<Esc><Esc>', '<C-\\><C-n>', { desc = 'Easily escape Terminal mode' }, 't')

---@param forward boolean
local function search_and_center(forward)
    if forward then
        vim.cmd([[silent! normal! n]])
    else
        vim.cmd([[silent! normal! N]])
    end
    vim.cmd([[normal! zz]])
end
__setKeymap('n', function() search_and_center(true) end, { desc = 'Search and center vertically' })
__setKeymap('N', function() search_and_center(false) end, { desc = 'Search and center vertically' })

-- Save buffer
__setKeymap('<leader>w', ':w<CR>', { desc = '[w]rite buffer' })

-- Toggle wrap
__setKeymap('<leader>tw', function() vim.cmd([[setlocal wrap!]]) end, { desc = '[t]oggle [w]rap' })

-- When text is wrapped, move by terminal rows instead, not lines, unless a count is provided.
__setKeymap('<C-Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = 'Move up by rows, not lines, unless count is provided' })
__setKeymap('<C-Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = 'Move down by rows, not lines, unless count is provided' })

-- Diagnostic keymaps
__setKeymap('<leader>dl', vim.diagnostic.setloclist, { desc = 'Open [d]iagnostics [l]ist' })
__setKeymap('<leader>td', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled(), { bufnr = 0 }) end, { desc = '[t]oggle [d]iagnostics' })

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
-- NOTE: With LuaSnip when this was with the mode 'v', it caused a problem that pasted text
-- instead of just inserting a p
__setKeymap('p', '"_dP', { desc = 'Preserve yank without replacing it by the selected text' }, 'x')

-- Easy insertion of a trailing ; or ,
__setKeymap(',,', '<Esc>A,<Esc>', { desc = 'Insert [,] at the eol' })
__setKeymap(',,', '<Esc>A,', { desc = 'Insert [,] at the eol' }, 'i')
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
end, { desc = 'Act as {} or []' })

-- Toggle spelling
__setKeymap('<leader>ts', function() vim.cmd([[setlocal spell!]]) end, { desc = '[S]pelling checking' })

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

    if not file then
        return
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

__setKeymap('<leader><C-r>', function()
    local file_path = vim.fn.getcwd() .. '/nvim_commands.sh'
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local previewers = require('telescope.previewers')

    local function ensure_script_with_template(path)
        local created_or_emptied = false

        local function write_template(p)
            local template = table.concat({
                '#!/usr/bin/env bash',
                '# File: ' .. p,
                '# Description: Command list to execute in Neovim.',
                '#',
                '# Instructions:',
                '#    - Write a command per line.',
                '#    - The comment lines (starting with #) will be ignored.',
                '#    - Empty lines will be ignored.',
                '#    - " && \\" will be appended automatically',
                '#',
                '# Examples:',
                '# echo "Start"',
                '# ls -la',
                '# echo "Finish"',
                '',
                '',
            }, '\n')

            local f, err = io.open(p, 'w')
            if not f then
                vim.notify('File could not be created: ' .. (err or ''), vim.log.levels.ERROR)
                return false
            end
            f:write(template)
            f:close()

            pcall(function()
                if vim.fn.has('win32') == 0 and vim.fn.executable('chmod') == 1 then
                    vim.fn.system({ 'chmod', '+x', p })
                end
            end)

            return true
        end

        if vim.fn.filereadable(path) == 0 then
            created_or_emptied = write_template(path)
        else
            local stat = vim.uv.fs_stat(path)
            if stat and stat.size == 0 then
                created_or_emptied = write_template(path)
            end
        end

        if created_or_emptied then
            vim.cmd('edit ' .. vim.fn.fnameescape(path))
            return true
        end
        return false
    end

    if ensure_script_with_template(file_path) then
        return
    end

    local raw_lines = {}
    for line in io.lines(file_path) do
        if not line:match('^%s*#') then
            table.insert(raw_lines, line)
        end
    end

    local commands = {}
    for _, l in ipairs(raw_lines) do
        if not l:match('^%s*$') then
            table.insert(commands, l)
        end
    end

    if #commands == 0 then
        vim.cmd('edit ' .. vim.fn.fnameescape(file_path))
        return
    end

    for i = 1, #commands - 1 do
        commands[i] = commands[i] .. ' && \\'
    end

    local preview_content = table.concat(commands, '\n')

    pickers
        .new({}, {
            prompt_title = 'Commands to be executed',
            finder = finders.new_table({
                results = { 'No', 'Yes' },
            }),
            previewer = previewers.new_buffer_previewer({
                define_preview = function(self, _, _)
                    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(preview_content, '\n'))
                    vim.api.nvim_set_option_value('filetype', 'sh', {
                        scope = 'local',
                        buf = self.state.bufnr,
                    })
                end,
            }),
            layout_strategy = 'vertical',
            layout_config = {
                vertical = {
                    preview_height = 0.8,
                },
            },
            attach_mappings = function(_, map)
                map('i', '<CR>', function(prompt_bufnr)
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)

                    if selection[1] == 'Yes' then
                        vim.cmd('split | terminal')

                        for _, cmd in ipairs(commands) do
                            vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. '\n')
                        end

                        -- vim.cmd('startinsert')
                    else
                        print('Operation canceled.')
                    end
                end)
                return true
            end,
        })
        :find()
end, { desc = 'Run commands from file nvim_commands.txt' })
