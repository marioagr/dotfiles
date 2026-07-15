local app = require('laravel.core.app')
local nio = require('nio')

---@class blink.cmp.Source
local source = {}

function source.new(opts)
    local self = setmetatable({}, { __index = source })
    self.opts = opts or {}
    return self
end

function source:enabled()
    local ok, env = pcall(function() return app('laravel.core.env') end)

    if not ok or not env then
        return false
    end

    return env:isActive() and vim.tbl_contains({ 'tinker', 'blade', 'php' }, vim.bo.filetype)
end

function source:get_trigger_characters() return { "'", '"' } end

function source:get_completions(ctx, callback)
    local bounds = ctx.get_bounds('prefix')
    local text = bounds.line:sub(1, bounds.start_col)

    nio.run(function()
        app:singletonIf('laravel.loaders.translations_loader', function()
            local loader_module = require('laravel-nvim.translations.loader')

            return loader_module:new(app('laravel.services.code'), app('laravel.services.path'), app('laravel.core.watcher'))
        end)

        local completion = require('laravel-nvim.translations.completion')

        if completion.shouldComplete(text) then
            return completion.complete(app('laravel.loaders.translations_loader'), self.opts, callback)
        end

        callback({ items = {} })
    end)

    return function() end
end

function source:resolve(item, callback) callback(item) end

function source:execute(ctx, item, callback, default_implementation)
    default_implementation()
    callback()
end

return source
