-- Lightweight yet powerful formatter plugin for Neovim
---@return nil|conform.FormatOpts
local function custom_opts_for_format(bufnr)
    bufnr = bufnr or 0

    ---@type conform.FormatOpts
    local do_not_apply_formatting_opts = { dry_run = true } -- Do not apply formatting

    -- [[
    --  Disable with a global or buffer-local variable
    --  Disable format_on_save "lsp_format" for languages that don't
    --      have a well standardized coding style. You can add additional
    --      languages here or re-enable it for the disabled ones.
    -- ]]
    local disable_filetypes = { 'c', 'cpp' }
    if (vim.g.DisableAutoFormatGlobally == 1) or (vim.b[bufnr].DisableAutoFormat == 1) or vim.tbl_contains(disable_filetypes, vim.bo[bufnr].filetype) then
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
        ---@module "conform"
        ---@type conform.setupOpts
        local opts = {
            log_level = vim.log.levels.DEBUG,
            -- notify_on_error = false,
            format_after_save = custom_opts_for_format,
            -- List of formatters available at
            -- https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
            -- HACK: Also add the formatter used in the ensure_installed variable at the lsp-config.lua file.
            formatters_by_ft = {
                -- antlers = { 'antlersformat' },
                blade = { 'blade-formatter' },
                -- Conform can also run multiple formatters sequentially
                -- You can use 'stop_after_first' to run the first available formatter from the list
                css = { 'prettierd' },
                html = { 'prettierd' },
                javascript = { 'prettierd', stop_after_first = true },
                typescript = { 'prettierd', stop_after_first = true },
                lua = { 'stylua' },
                markdown = { 'mdslw' },
                php = { 'pint' },
            },
            formatters = {
                -- NOTE: Important to install it via npm
                -- npm -g i 'antlers-formatter'
                -- antlersformat = {
                --     command = 'antlersformat',
                --     args = { 'format', '$FILENAME' },
                --     stdin = false,
                -- },
                ['blade-formatter'] = {
                    append_args = {
                        '--sort-tailwindcss-classes',
                        '--sort-html-attributes="custom"', --Needed for ↓
                        string.format(
                            '--custom-html-attributes-order="%s"',
                            table.concat({
                                'id',
                                'name',
                                'type',
                                'class',
                                ':.+',
                                'x-.+',
                                'wire:.+',
                                'data-.+',
                            }, ',')
                        ),
                        '--no-multiple-empty-lines',
                        '--component-prefix="x-,livewire:,flux:"',
                    },
                },
                mdslw = {
                    env = {
                        MDSLW_MAX_WIDTH = 0,
                        MDSLW_LANG = 'en es',
                    },
                },
                prettierd = {
                    env = {
                        PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath('config') .. '/utils/.prettierrc',
                    },
                },
            },
        }

        require('conform').setup(opts)
    end,
    keys = {
        {
            '<leader>ff',
            function()
                require('conform').format(custom_opts_for_format())
            end,
            mode = { 'n', 'v' },
            desc = '[f]ormat',
        },
        {
            '<leader>tf',
            function()
                if vim.b.DisableAutoFormat == 0 then
                    vim.b.DisableAutoFormat = 1
                else
                    vim.b.DisableAutoFormat = 0
                end
            end,
            desc = 'buffer [f]ormatter',
        },
        {
            '<leader>tF',
            function()
                if vim.g.DisableAutoFormatGlobally == 0 then
                    vim.g.DisableAutoFormatGlobally = 1
                else
                    vim.g.DisableAutoFormatGlobally = 0
                end
            end,
            desc = 'Global [F]ormatter',
        },
    },
    init = function()
        vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
    end,
}
