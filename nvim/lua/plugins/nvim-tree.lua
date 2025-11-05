-- File tree sidebar
return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    lazy = false,
    config = function()
        -- Sort files naturally (respecting numbers within files names)
        -- 1, 2, 3, ... 10, 20, 30 instead of 1, 10, 2, 20, 3, 30 ...
        local function sort_by_natural(left, right)
            if left.type ~= 'directory' and right.type == 'directory' then
                return false
            elseif left.type == 'directory' and right.type ~= 'directory' then
                return true
            end
            left = left.name:lower()
            right = right.name:lower()

            if left == right then
                return false
            end

            for i = 1, math.max(string.len(left), string.len(right)), 1 do
                local l = string.sub(left, i, -1)
                local r = string.sub(right, i, -1)

                if type(tonumber(string.sub(l, 1, 1))) == 'number' and type(tonumber(string.sub(r, 1, 1))) == 'number' then
                    local l_number = tonumber(string.match(l, '^[0-9]+'))
                    local r_number = tonumber(string.match(r, '^[0-9]+'))

                    if l_number ~= r_number then
                        return l_number < r_number
                    end
                elseif string.sub(l, 1, 1) ~= string.sub(r, 1, 1) then
                    return l < r
                end
            end
        end

        -- Automatically open file upon creation
        local api = require('nvim-tree.api')
        api.events.subscribe(api.events.Event.FileCreated, function(file)
            vim.cmd('edit ' .. file.fname)
        end)

        local my_opts = {
            --[[
            -- NOTE: Keep netrw but without the file browser features
            -- It helps to use features like spell and the automatic download of .spl &.sug files
            --]]
            disable_netrw = false,
            hijack_netrw = true,
            hijack_cursor = true,
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
            diagnostics = {
                enable = true,
                show_on_dirs = true,
            },
            git = {
                timeout = 1000,
            },
            help = {
                sort_by = 'desc',
            },
            filters = {
                custom = { '^.git$' },
                git_ignored = false,
            },
            live_filter = {
                always_show_folders = false,
            },
            renderer = {
                group_empty = true,
                hidden_display = 'simple',
                highlight_clipboard = 'all',
                icons = {
                    show = {
                        folder_arrow = false,
                    },
                    git_placement = 'after',
                },
                indent_markers = {
                    enable = true,
                },
            },
            select_prompts = true,
            sort_by = function(nodes)
                table.sort(nodes, sort_by_natural)
            end,
            view = {
                side = 'right',
                preserve_window_proportions = true,
                width = 50,
            },
        }

        require('nvim-tree').setup(my_opts)
    end,
    keys = {
        { '<leader>ee', ':NvimTreeToggle<CR>', desc = 'Open [e]xplor[e]r Nvimtree' },
        { '<leader>ef', ':NvimTreeFindFileToggle<CR>', desc = 'Open [e]xplorer at current [f]ile' },
    },
}
