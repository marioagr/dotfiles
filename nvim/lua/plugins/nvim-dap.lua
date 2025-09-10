--Based on https://github.com/nvim-lua/kickstart.nvim/blob/master/lua/kickstart/plugins/debug.lua

return {
    'mfussenegger/nvim-dap',
    dependencies = {
        -- Creates a beautiful debugger UI
        'rcarriga/nvim-dap-ui',

        -- Required dependency for nvim-dap-ui
        'nvim-neotest/nvim-nio',

        -- Installs the debug adapters for you
        'mason-org/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',
    },
    keys = {
        {
            '<F1>',
            function()
                require('dapui').eval(nil, { enter = true })
            end,
            desc = 'Debug: See last session result.',
        },
        {
            '<F5>',
            function()
                require('dap').continue()
            end,
            desc = 'Debug: Start/Continue',
        },
        {
            '<F8>',
            function()
                require('dap').toggle_breakpoint()
            end,
            desc = 'Debug: [t]oggle [b]reakpoint',
        },
        {
            '<F20>', -- Shift+F8
            function()
                require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
            end,
            desc = 'Debug: Set Breakpoint',
        },
        {
            '<F10>',
            function()
                require('dap').step_over()
            end,
            desc = 'Debug: Step Over',
        },
        {
            '<F11>',
            function()
                require('dap').step_into()
            end,
            desc = 'Debug: Step Into',
        },
        {
            '<F23>',
            function()
                require('dap').step_out()
            end,
            desc = 'Debug: Step Out',
        },
        -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
        {
            '<F12>',
            function()
                require('dapui').toggle()
            end,
            desc = 'Debug: See last session result.',
        },
    },
    config = function()
        local dap = require('dap')
        local dapui = require('dapui')

        require('mason-nvim-dap').setup({
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_installation = true,

            -- You can provide additional configuration to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},

            ensure_installed = {
                'php',
            },
        })

        -- NOTE: Maybe use https://github.com/lucaSartore/nvim-dap-exception-breakpoints
        dap.defaults.php.exception_breakpoints = { 'Notice', 'Warning', 'Error', 'Exception' }

        dap.configurations.php = {
            {
                name = 'Listen for Xdebug w/mapping',
                type = 'php',
                request = 'launch',
                port = 9003,
                pathMappings = {
                    ['/var/www/html'] = '${workspaceFolder}',
                },
            },
            {
                name = 'Listen for Xdebug w/mapping wo/vendor',
                type = 'php',
                request = 'launch',
                port = 9003,
                skipFiles = {
                    '**/vendor/**/*.php',
                },
                pathMappings = {
                    ['/var/www/html'] = '${workspaceFolder}',
                },
            },
            {
                name = 'Listen for Xdebug no mapping',
                type = 'php',
                request = 'launch',
                port = 9003,
            },
            -- {
            --     name = 'Launch currently open script',
            --     type = 'php',
            --     request = 'launch',
            --     program = '${file}',
            --     cwd = '${fileDirname}',
            --     port = 0,
            --     runtimeArgs = {
            --         '-dxdebug.start_with_request=yes',
            --     },
            --     env = {
            --         XDEBUG_MODE = 'debug,develop',
            --         XDEBUG_CONFIG = 'client_port=${port}',
            --     },
            -- },
            -- {
            --     name = 'Launch Built-in web server',
            --     type = 'php',
            --     request = 'launch',
            --     runtimeArgs = {
            --         '-dxdebug.mode=debug',
            --         '-dxdebug.start_with_request=yes',
            --         '-S',
            --         'localhost:0',
            --     },
            --     program = '',
            --     cwd = '${workspaceRoot}',
            --     port = 9003,
            --     serverReadyAction = {
            --         pattern = 'Development Server \\(http://localhost:({0-9}+)\\) started',
            --         uriFormat = 'http://localhost:%s',
            --         action = 'openExternally',
            --     },
            -- },
        }

        -- Dap UI setup
        -- For more information, see |:help nvim-dap-ui|
        dapui.setup({
            layouts = {
                {
                    elements = {
                        { id = 'breakpoints', size = 0.35 },
                        { id = 'scopes', size = 0.35 },
                        { id = 'watches', size = 0.15 },
                        { id = 'stacks', size = 0.15 },
                    },
                    size = 70,
                    position = 'right',
                },
                {
                    elements = {
                        'repl',
                        { id = 'console', size = 0.35 },
                    },
                    size = 0.2,
                    position = 'bottom',
                },
            },
            icons = { current_frame = '*' },
        })

        -- Change breakpoint icons
        vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
        vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
        local breakpoint_icons = { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        for type, icon in pairs(breakpoint_icons) do
            local tp = 'Dap' .. type
            local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
            vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
        end

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end,
}
