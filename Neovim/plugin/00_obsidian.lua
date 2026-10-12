---@type obsidian.config
local opts = {
    legacy_commands = false,
    workspaces = {
        {
            name = 'notes',
            path = '~/repos/notes',
        },
    },

    ---@type fun(title: string|?, path: obsidian.Path|?): string
    note_id_func = function(title)
        local timestamp = os.date('%Y%m%d%H%M')

        if title ~= nil then
            -- If a title is provided, convert it to a lowercase, hyphen-separated slug
            local slug = title:gsub(' ', '_'):gsub('[^A-Za-z0-9-_]', ''):lower()
            return timestamp .. '-' .. slug
        end

        -- If no title is given, fall back to just the timestamp
        return timestamp
    end,
}

require('obsidian').setup(opts)
