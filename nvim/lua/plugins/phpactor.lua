return {
    'phpactor/phpactor',
    enabled = false,
    ft = 'php',
    build = 'composer install --no-dev --optimize-autoloader',
    config = function()
        __setKeymap('<leader>pm', ':PhpactorContextMenu<CR>', { desc = '[p]hpactor' })

        -- NOTE: From https://phpactor.readthedocs.io/en/master/lsp/vim-lsp.html
        -- using nvim api functions instead of plenary

        vim.cmd([[
            augroup LspPhpactor
              autocmd!
              autocmd Filetype php command! -nargs=0 LspPhpactorReindex lua vim.lsp.buf_notify(0, "phpactor/indexer/reindex",{})
              autocmd Filetype php command! -nargs=0 LspPhpactorConfig lua LspPhpactorDumpConfig()
              autocmd Filetype php command! -nargs=0 LspPhpactorStatus lua LspPhpactorStatus()
              autocmd Filetype php command! -nargs=0 LspPhpactorBlackfireStart lua LspPhpactorBlackfireStart()
              autocmd Filetype php command! -nargs=0 LspPhpactorBlackfireFinish lua LspPhpactorBlackfireFinish()
            augroup END
        ]])

        local function showWindow(title, syntax, contents)
            local out = {}
            for match in string.gmatch(contents, '[^\n]+') do
                table.insert(out, match)
            end

            local buf = vim.api.nvim_create_buf(false, true)

            vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
            vim.api.nvim_set_option_value('filetype', syntax, { buf = buf })

            local ui = vim.api.nvim_list_uis()[1]
            if not ui then
                return
            end

            local width = math.floor(ui.width * 0.8)
            local height = math.floor(ui.height * 0.5)

            local row = math.floor((ui.height - height) / 2)
            local col = math.floor((ui.width - width) / 2)

            local win_config = {
                relative = 'editor',
                width = width,
                height = height,
                row = row,
                col = col,
                title = title,
                title_pos = 'center',
                style = 'minimal',
            }

            local win = vim.api.nvim_open_win(buf, true, win_config)

            vim.api.nvim_set_option_value('winblend', 0, { win = win })

            local opts = { buffer = buf, silent = true }
            vim.keymap.set('n', '<Esc>', '<Cmd>close<CR>', opts)
            vim.keymap.set('n', 'q', '<Cmd>close<CR>', opts)

            local augroup = vim.api.nvim_create_augroup('PhpactorFloatWin', { clear = false })
            vim.api.nvim_create_autocmd('WinClosed', {
                group = augroup,
                buffer = buf,
                callback = function()
                    if vim.api.nvim_buf_is_valid(buf) then
                        vim.api.nvim_buf_delete(buf, { force = true })
                    end
                end,
                once = true,
            })
        end

        function LspPhpactorDumpConfig()
            local results, _ = vim.lsp.buf_request_sync(0, 'phpactor/debug/config', { ['return'] = true })
            for _, res in pairs(results or {}) do
                pcall(showWindow, 'Phpactor LSP Configuration', 'json', res['result'])
            end
        end
        function LspPhpactorStatus()
            local results, _ = vim.lsp.buf_request_sync(0, 'phpactor/status', { ['return'] = true })
            for _, res in pairs(results or {}) do
                pcall(showWindow, 'Phpactor Status', 'text', res['result'])
            end
        end

        -- function LspPhpactorBlackfireStart()
        --     local _, _ = vim.lsp.buf_request_sync(0, 'blackfire/start', {})
        -- end
        -- function LspPhpactorBlackfireFinish()
        --     local _, _ = vim.lsp.buf_request_sync(0, 'blackfire/finish', {})
        -- end
    end,
}
