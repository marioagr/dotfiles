return {
    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'kyazdani42/nvim-web-devicons',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            'nvim-telescope/telescope-live-grep-args.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function()
                    return vim.fn.executable('make') == 1
                end,
            },
            'nvim-telescope/telescope-ui-select.nvim',
        },
        config = function()
            local actions = require('telescope.actions')

            require('telescope').setup({
                defaults = {
                    path_display = { truncate = 1 },
                    prompt_prefix = '  ',
                    selection_caret = '󰐊 ',
                    layout_config = {
                        prompt_position = 'top',
                    },
                    scroll_strategy = 'limit',
                    sorting_strategy = 'ascending',
                    mappings = {
                        i = {
                            ['<esc>'] = actions.close,
                            ['<C-Down>'] = actions.cycle_history_next,
                            ['<C-Up>'] = actions.cycle_history_prev,
                            ['<C-u>'] = false,
                            ['<C-d>'] = false,
                        },
                    },
                    file_ignore_patterns = { '%.git/' },
                },
                pickers = {
                    buffers = {
                        previewer = false,
                        -- layout_config = {
                        --     width = 88,
                        -- },
                    },
                    old_files = {
                        prompt_title = 'History',
                    },
                    lsp_references = {
                        previewer = false,
                    },
                },
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            })

            require('telescope').load_extension('fzf')
            require('telescope').load_extension('live_grep_args')
            require('telescope').load_extension('ui-select')

            -- See `:help telescope.builtin`
            local builtin = require('telescope.builtin')

            -- Telescope live_grep in git root
            -- Function to find the git root directory based on the current buffer's path
            local function find_git_root()
                -- Use the current buffer's path as the starting point for the git search
                local current_file = vim.api.nvim_buf_get_name(0)
                local current_dir
                local cwd = vim.fn.getcwd()
                -- If the buffer is not associated with a file, return nil
                if current_file == '' then
                    current_dir = cwd
                else
                    -- Extract the directory from the current file's path
                    current_dir = vim.fn.fnamemodify(current_file, ':h')
                end

                -- Find the Git root directory from the current file's path
                local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
                if vim.v.shell_error ~= 0 then
                    print('Not a git repository. Searching on current working directory')
                    return cwd
                end
                return git_root
            end

            -- Custom live_grep function to search in git root
            local function live_grep_git_root()
                local git_root = find_git_root()
                if git_root then
                    builtin.live_grep({
                        search_dirs = { git_root },
                    })
                end
            end

            vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

            local function search_in_buffer()
                -- You can pass additional configuration to telescope to change theme, layout, etc.
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
                    winblend = 10,
                    previewer = false,
                }))
            end
            local function telescope_live_grep_open_files()
                builtin.live_grep({
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                })
            end
            local function search_files()
                builtin.find_files({
                    follow = true,
                })
            end
            local function search_all_files()
                builtin.find_files({
                    follow = true,
                    hidden = true,
                    no_ignore = true,
                    prompt_title = 'All Files (.gitignore & .hidden)',
                })
            end
            local function oldfiles_in_cwd()
                builtin.oldfiles({ only_cwd = true })
            end
            local function grep_search_simple()
                builtin.live_grep({
                    glob_pattern = {
                        '!**/composer.lock',
                        '!**/package-lock.json',
                        '!**/bun.lockb',
                        '!**/vendor/**',
                        '!**/node_modules/**',
                    },
                })
            end

            vim.keymap.set('n', '<leader>so', oldfiles_in_cwd, { desc = '[s]earch recently [o]pened files' })
            vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>/', search_in_buffer, { desc = '[/] Fuzzily search in current buffer' })
            vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[s]earch [/] in Open Files' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[s]earch [s]elect Telescope' })
            vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [g]it [f]iles' })
            vim.keymap.set('n', '<leader>sf', search_files, { desc = '[s]earch [f]iles' })
            vim.keymap.set('n', '<leader>sa', search_all_files, { desc = '[s]earch [a]ll files' })
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
            vim.keymap.set('n', '<leader>sg', grep_search_simple, { desc = '[s]earch by [g]rep' })
            vim.keymap.set('n', '<leader>sG', builtin.live_grep, { desc = '[s]earch by [G]rep on all files' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[s]earch [r]esume' })
            vim.keymap.set('n', '<leader>ts', builtin.spell_suggest, { desc = 'Open [t]elescope with [s]pell suggestions' })
        end,
    },
}
