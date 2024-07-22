-- Add/delete/replace surroundings (brackets, quotes, etc.)
return {
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    'echasnovski/mini.surround',
    version = false,
    opts = {
        -- Number of lines within which surrounding is searched
        n_lines = 100,
    },
}
