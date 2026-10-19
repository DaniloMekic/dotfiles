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
            return timestamp .. '__' .. slug
        end

        -- If no title is given, fall back to just the timestamp
        return timestamp
    end,
}

-- In WSL variable $XDG_CURRENT_DESKTOP is not set,
-- and xdg-open falls back to launching explorer.exe
-- Documentation:
-- https://wiki.archlinux.org/title/Default_applications
-- https://wiki.archlinux.org/title/Xdg-utils
-- https://wiki.archlinux.org/title/XDG_MIME_Applications
if vim.fn.has('wsl') == 1 then
    opts.open = {
        ---@type fun(uri: string)
        open = {
            func = function(uri)
                vim.system({ 'xdg-open', uri }, {
                    env = { XDG_CURRENT_DESKTOP = 'X-Generic' },
                    detach = true,
                })
            end,
        },
    }
end

require('obsidian').setup(opts)
