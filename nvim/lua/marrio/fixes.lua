--[[
--  HACK::
--  Below goes the fixes that I don't know where to put them ¿and have to be after Lazy was loaded?
--]]

-- Add patterns for fts and set them to their corresponding language
vim.filetype.add({
    pattern = {
        -- ['.*%.antlers%.html'] = 'antlers',
        ['.*%.blade%.php'] = 'blade',
    },
})
-- Use the HTML treesitter for antlers
vim.treesitter.language.register('html', 'antlers')

--[[
--  For example, when using Zellij, "undercurl" seems to have problems rendering so to fix the problem
--  where some words appear bold and others just "light" (thin) I set the Spell* highlight to
--  "bold,underline" and no other combination because it does not mess the following words
--  https://github.com/zellij-org/zellij/issues?q=is%3Aissue+undercurl
--
--  Example
--      **This words are bold but when** <badSpelling> **this words are bold**
--  If I set to only underline this happens
--      **This words are bold but when** <badSpelling> this words are light
--
--  :filter Spell Highlight
--
--  This issue may be related to the Zellij, so also consider in indent-blankline 
--  setting the option { scope = { start = false } }
--]]

-- I'll leave them this way, at least it shows the words underlined when spelling is on
vim.cmd([[ hi SpellBad cterm=underline gui=underline ]])
vim.cmd([[ hi SpellCap cterm=underline gui=underline ]])
vim.cmd([[ hi SpellRare cterm=underline gui=underline ]])
vim.cmd([[ hi SpellLocal cterm=underline gui=underline ]])
