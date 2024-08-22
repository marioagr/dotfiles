-- Lightweight yet powerful formatter plugin for Neovim
---@return nil|conform.FormatOpts
local function custom_opts_for_format(bufnr)
    bufnr = bufnr or 0

    ---@type conform.FormatOpts
    local do_not_apply_formatting_opts = { dry_run = true } -- Do not apply formatting

    -- [[
    --  Disable with a global or buffer-local variable
    --  Disable format_on_save "lsp_fallback" for languages that don't
    --      have a well standardized coding style. You can add additional
    --      languages here or re-enable it for the disabled ones.
    -- ]]
    local disable_filetypes = { 'c', 'cpp' }
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat or vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
        return do_not_apply_formatting_opts
    end

    -- Disable autoformat for files in certain paths
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local cwd = vim.fn.getcwd() -- Maybe get rid of this? In case I'm editing a file that is outside of the workspace
    if bufname:match(cwd .. '/node_modules/') or bufname:match(cwd .. '/vendor/') then
        return do_not_apply_formatting_opts
    end

    ---@type conform.FormatOpts
    return {
        async = true,
        timeout_ms = 1000,
        lsp_format = 'fallback',
    }
end

return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
        local conform = require('conform')
        conform.setup({
            -- notify_on_error = false,
            format_after_save = custom_opts_for_format,
            -- List of formatters available at
            -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
            -- HACK: Also add the formatter used in the ensure_installed variable at the lsp-config.lua file.
            formatters_by_ft = {
                blade = { 'blade-formatter' },
                -- Conform can also run multiple formatters sequentially
                -- You can use 'stop_after_first' to run the first available formatter from the list
                css = { 'prettierd', 'prettier', stop_after_first = true },
                html = { 'prettierd', 'prettier', stop_after_first = true },
                javascript = { 'prettierd', 'prettier', stop_after_first = true },
                typescript = { 'prettierd', 'prettier', stop_after_first = true },
                lua = { 'stylua' },
                markdown = { 'mdslw' },
                php = { 'pint' },
            },
            formatters = {
                mdslw = {
                    env = {
                        MDSLW_MAX_WIDTH = 120,
                        MDSLW_LANG = 'en es',
                    },
                },
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
            local function is_disabled(option)
                if vim[option].disable_autoformat == true then
                    return 'disabled'
                else
                    return 'enabled'
                end
            end

            vim.notify('Formatter is ' .. is_disabled('g'), vim.log.levels.INFO, { title = 'Global' })
            vim.notify('Formatter is ' .. is_disabled('b'), vim.log.levels.INFO, { title = 'Buffer' })
        end, {
            desc = 'Check status for formatter',
        })
    end,
    keys = {
        {
            '<leader>ff',
            function()
                require('conform').format(custom_opts_for_format())
            end,
            mode = { 'n', 'v' },
            desc = 'Format buffer or selection',
        },
    },
    init = function()
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
}
