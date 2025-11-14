return {
    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            'nvim-telescope/telescope-live-grep-args.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable('make') == 1
                end,
            },
            'nvim-telescope/telescope-ui-select.nvim',
        },
        config = function()
            local actions = require('telescope.actions')
            local builtin = require('telescope.builtin')
            local themes = require('telescope.themes')
            local action_layouts = require('telescope.actions.layout')
            local lga_actions = require('telescope-live-grep-args.actions')

            local common_mappings = {
                ['<C-d>'] = actions.results_scrolling_down,
                ['<C-u>'] = actions.results_scrolling_up,

                ['<PageDown>'] = actions.preview_scrolling_down,
                ['<PageUp>'] = actions.preview_scrolling_up,

                ['<M-Down>'] = actions.cycle_history_next,
                ['<M-Up>'] = actions.cycle_history_prev,
                ['<M-p>'] = action_layouts.toggle_preview,
            }

            require('telescope').setup({
                defaults = {
                    file_ignore_patterns = { '%.git/' },
                    layout_strategy = 'flex',
                    layout_config = {
                        width = 0.9,
                    },
                    mappings = {
                        n = common_mappings,
                        i = vim.tbl_extend('keep', common_mappings, {
                            ['<esc>'] = actions.close,
                        }),
                    },
                    path_display = {
                        truncate = 1,
                    },
                    preview = {
                        timeout = 500,
                    },
                    prompt_prefix = '  ',
                    scroll_strategy = 'limit',
                    selection_caret = ' ',
                },
                pickers = {
                    buffers = {
                        previewer = false,
                        theme = 'ivy',
                        layout_config = {
                            height = 15,
                        },
                    },
                    old_files = {
                        prompt_title = 'History',
                    },
                    lsp_references = {
                        previewer = false,
                        theme = 'ivy',
                    },
                },
                extensions = {
                    live_grep_args = {
                        -- auto_quoting = true, -- enable/disable auto-quoting
                        -- define mappings, e.g.
                        mappings = { -- extend mappings
                            i = {
                                ['<C-\\>'] = lga_actions.quote_prompt(),
                                ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
                                -- -- freeze the current list and start a fuzzy search in the frozen list
                                -- ['<C-space>'] = lga_actions.to_fuzzy_refine,
                            },
                        },
                    },
                    ['ui-select'] = {
                        themes.get_cursor(),
                    },
                },
            })

            require('telescope').load_extension('fzf')
            require('telescope').load_extension('live_grep_args')
            require('telescope').load_extension('ui-select')

            local function search_in_buffer()
                builtin.current_buffer_fuzzy_find(themes.get_ivy({
                    previewer = false,
                    layout_config = {
                        height = 20,
                    },
                }))
            end

            local function telescope_live_grep_open_files()
                builtin.live_grep(themes.get_ivy({
                    grep_open_files = true,
                    previewer = false,
                    prompt_title = 'Live Grep in Open Files',
                }))
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
                require('telescope').extensions.live_grep_args.live_grep_args({
                    prompt_title = 'Live Grep',
                    -- TODO: Check why this does not work
                    glob_pattern = {
                        '!**/composer.lock',
                        '!**/package-lock.json',
                        '!**/bun.lockb',
                    },
                    additional_args = {
                        '--hidden',
                    },
                })
            end

            local function grep_search_advanced()
                require('telescope').extensions.live_grep_args.live_grep_args({
                    prompt_title = 'Live Grep ALL',
                    additional_args = { '-u', '-u' },
                })
            end

            local function text_suggestions()
                builtin.spell_suggest(themes.get_ivy({
                    layout_config = {
                        height = 20,
                    },
                }))
            end

            __setKeymap('<leader>so', oldfiles_in_cwd, { desc = '[s]earch recently [o]pened files' })
            __setKeymap('<leader><leader>', builtin.buffers, { desc = '[s]earch existing buffers' })
            __setKeymap('<leader>/', search_in_buffer, { desc = '[ ][ ] Fuzzily search in current buffer' })
            __setKeymap('<leader>s/', telescope_live_grep_open_files, { desc = '[s]earch [/] in Open Files' })
            __setKeymap('<leader>ss', builtin.builtin, { desc = '[s]earch [s]elect Telescope' })
            -- __set_keybind('<leader>gf', builtin.git_files, { desc = 'Search [g]it [f]iles' })
            __setKeymap('<leader>sf', search_files, { desc = '[s]earch [f]iles' })
            __setKeymap('<leader>sF', search_all_files, { desc = '[s]earch all [F]iles' })
            __setKeymap('<leader>sh', builtin.help_tags, { desc = '[s]earch [h]elp' })
            __setKeymap('<leader>sk', builtin.keymaps, { desc = '[s]earch [k]eymaps' })
            __setKeymap('<leader>sw', builtin.grep_string, { desc = '[s]earch current [w]ord' })
            __setKeymap('<leader>sg', grep_search_simple, { desc = '[s]earch by [g]rep' })
            __setKeymap('<leader>sG', grep_search_advanced, { desc = '[s]earch by [G]rep on all files' })
            __setKeymap('<leader>sd', builtin.diagnostics, { desc = '[s]earch [d]iagnostics' })
            __setKeymap('<leader>sr', builtin.resume, { desc = '[s]earch [r]esume' })
            __setKeymap('<leader>sz', text_suggestions, { desc = 'Open [t]elescope with [s]pell suggestions' })
        end,
    },
}
