local translations_completion = {}

---@param translation table
---@param meta table
---@param options table
---@return string
local function build_documentation(translation, meta, options)
    local show_all_locales = options.show_all_locales ~= false

    local lines = {
        translation.key,
        '',
    }

    local seen = {}
    local locales = {}

    local function add_locale(locale)
        if not locale or seen[locale] then
            return
        end
        seen[locale] = true
        table.insert(locales, locale)
    end

    -- Default locale first
    add_locale(meta.default_locale)

    -- Fallback locale second, if different from default
    if meta.fallback_locale and meta.fallback_locale ~= meta.default_locale then
        add_locale(meta.fallback_locale)
    end

    -- Remaining locales when showing all
    if show_all_locales then
        local remaining = {}
        for _, locale in ipairs(meta.expected_locales or {}) do
            if locale ~= meta.default_locale and locale ~= meta.fallback_locale then
                table.insert(remaining, locale)
            end
        end
        table.sort(remaining)

        for _, locale in ipairs(remaining) do
            add_locale(locale)
        end
    end

    for i, locale in ipairs(locales) do
        if i > 1 then
            table.insert(lines, '')
        end

        local locale_label = locale == meta.default_locale and '**[' .. locale .. ']**' or '[' .. locale .. ']'
        table.insert(lines, locale_label)

        local value = translation.values and translation.values[locale]
        table.insert(lines, '󰗊 -> ' .. ((value and value ~= '') and value or ' missing '))

        local file = translation.files and translation.files[locale]
        table.insert(lines, '󰈔 -> ' .. ((file and file ~= '') and file or '—'))
    end

    return table.concat(lines, '\n')
end

---@param loader laravel_nvim.translations.loader
---@param params table
---@param callback fun(items: table)
function translations_completion.complete(loader, params, callback)
    local translations, meta, err = loader:load()

    if err or not translations then
        return callback({
            items = {},
            isIncomplete = false,
        })
    end

    return callback({
        items = vim.iter(vim.tbl_values(translations))
            :map(
                function(translation)
                    return {
                        label = translation.key,
                        insertText = translation.key,
                        kind = vim.lsp.protocol.CompletionItemKind.Value,
                        documentation = {
                            kind = 'markdown',
                            value = build_documentation(translation, meta or {}, params or {}),
                        },
                    }
                end
            )
            :totable(),
        isIncomplete = false,
    })
end

---@param text string
---@return boolean
function translations_completion.shouldComplete(text)
    return text:match('trans%([%\'|%"]')
        or text:match('trans_choice%([%\'|%"]')
        or text:match('__%([%\'|%"]')
        or text:match('@lang%([%\'|%"]')
        or text:match('@choice%([%\'|%"]')
        or text:match('Lang::get%([%\'|%"]')
        or text:match('Lang::choice%([%\'|%"]')
end

return translations_completion
