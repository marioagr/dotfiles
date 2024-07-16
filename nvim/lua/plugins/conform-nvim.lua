return { -- Lightweight yet powerful formatter plugin for Neovim
    'stevearc/conform.nvim',
    lazy = false,
    config = function()
        local conform = require('conform')
        conform.setup({
            -- notify_on_error = false,
            format_on_save = function(bufnr)
                -- [[
                --  Disable with a global or buffer-local variable
                --  Disable "format_on_save lsp_fallback" for languages that don't
                --      have a well standardized coding style. You can add additional
                --      languages here or re-enable it for the disabled ones.
                -- ]]
                local disable_filetypes = { c = true, cpp = true }

                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return {}
                end

                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                blade = { 'blade-formatter' },
                css = { 'prettierd', 'prettier' },
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                javascript = { { 'prettierd', 'prettier' } },
                lua = { 'stylua' },
                php = { 'pint' },
                -- Conform can also run multiple formatters sequentially
                -- python = { "isort", "black" },
                yml = { 'yamlls' },
            },
        })

        vim.api.nvim_create_user_command('FormatDisable', function(args)
            if args.bang then
                -- FormatDisable! will disable formatting just for this buffer
                vim.b.disable_autoformat = true
            else
                vim.g.disable_autoformat = true
            end
        end, {
            desc = 'Disable autoformat-on-save(!)',
            bang = true,
        })

        vim.api.nvim_create_user_command('FormatEnable', function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
        end, {
            desc = 'Re-enable autoformat-on-save',
        })

        vim.api.nvim_create_user_command('FormatStatus', function()
            function isDisabled(case)
                if vim[case].disable_autoformat == true then
                    return 'disabled'
                else
                    return 'enabled'
                end
            end

            vim.notify('Formatter is ' .. isDisabled('g'), vim.log.levels.INFO, { title = 'Global' })
            vim.notify('Formatter is ' .. isDisabled('b'), vim.log.levels.INFO, { title = 'Buffer' })
        end, {
            desc = 'Check status for formatter',
        })
    end,
    keys = {
        {
            '<leader>ff',
            function()
                require('conform').format({ async = true, lsp_fallback = true })
            end,
            mode = { 'n', 'v' },
            desc = '[N]ormal: Format buffer, [V]isual: Format selection',
        },
    },
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
