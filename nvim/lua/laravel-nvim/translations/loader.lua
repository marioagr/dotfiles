local Error = require('laravel.utils.error')

---@class laravel_nvim.translations.loader
---@field code laravel.services.code
---@field path laravel.services.path
---@field watcher laravel.core.watcher
---@field loaded boolean
---@field items table
---@field meta table
local TranslationsLoader = {}
TranslationsLoader.__index = TranslationsLoader

function TranslationsLoader:new(code, path, watcher)
    return setmetatable({
        code = code,
        path = path,
        watcher = watcher,
        items = {},
        meta = {},
        loaded = false,
    }, self)
end

---@return table, table, laravel.error
function TranslationsLoader:load()
    if self.loaded then
        return self.items, self.meta
    end

    local _load = function()
        local template = require('laravel-nvim.translations.template')
        local translations, err = self.code:run(template)

        if err or not translations then
            self.loaded = false
            self.items = {}
            self.meta = {}
            return nil, nil, Error:new('Failed to load translations'):wrap(err)
        end

        self.loaded = true
        self.items = translations.items or {}
        self.meta = translations.meta or {}

        return self.items, self.meta
    end

    local base_path, err = self.path:get('base')
    if err then
        return nil, nil, Error:new('Failed to get base path'):wrap(err)
    end

    local lang_path = self.path:handle(base_path .. '/lang')

    self.watcher.register({ { lang_path, recursive = true } }, '.*%.(php|json)$', _load)

    return _load()
end

return TranslationsLoader
