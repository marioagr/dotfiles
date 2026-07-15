local translations_completion = {}

---@param loader laravel_nvim.translations.loader
---@param params table
---@param callback fun(items: table)
function translations_completion.complete(loader, params, callback)
    local translations, err = loader:load()

    if err or not translations then
        return callback({
            items = {},
            isIncomplete = false,
        })
    end

    return callback({
        items = vim.iter(translations)
            :map(function(translation)
                return {
                    label = translation.key,
                    insertText = translation.key,
                    kind = vim.lsp.protocol.CompletionItemKind.Value,
                    documentation = {
                        kind = 'markdown',
                        -- stylua: ignore start
                        value = string.format(
                            '󰗊: %s\n: %s\n󰈔: %s',
                            translation.value or '',
                            translation.key,
                            translation.file or ''
                        ),
                        -- stylua: ignore end
                    },
                }
            end)
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
