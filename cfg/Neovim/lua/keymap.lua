-- https://neovim.io/doc/user/map/
-- https://neovim.io/doc/user/lua/#vim.keymap.set()

vim.g.mapleader = ' '

-- Factory Function: Toggle
local function toggle(opt, name)
    return function()
        vim.opt_local[opt] = not vim.opt_local[opt]:get()
        vim.notify(name .. ': ' .. (vim.opt_local[opt]:get() and 'On' or 'Off'))
    end
end

vim.keymap.set('n', '<Leader>w', '<Cmd>write<CR>')
-- Yank to system clipboard
vim.keymap.set({ 'n', 'x' }, '<Leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<Leader>Y', '"+yy', { desc = 'Yank line(s) to system clipboard' })
-- Put from system clipboard, without clobbering unnamed register
vim.keymap.set('n', '<Leader>p', '"+p', { desc = 'Put from system clipboard after the cursor' })
vim.keymap.set('n', '<Leader>P', '"+P', { desc = 'Put from system clipboard before the cursor' })
vim.keymap.set('x', '<Leader>p', '"_d"+P', { desc = 'Put from system clipboard' })
vim.keymap.set('x', '<Leader>P', '"_d"+P', { desc = 'Put from system clipboard' })

-- Open jump list
vim.keymap.set('n', '<Leader>j', '<cmd>jumps<CR>', { desc = 'Jump list' })

-- Indentation
vim.keymap.set('v', '<', '<gv', { desc = 'Indent line and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Re-indent line and reselect' })

-- UI
vim.keymap.set('n', '<Leader>uw', toggle('wrap', 'Wrap'), { desc = 'Toggle wrap' })
vim.keymap.set('n', '<Leader>uh', '<Cmd>nohlsearch<CR>', { desc = 'Stop highlighting search matches' })
vim.keymap.set(
    'n',
    '<Leader>uH',
    toggle('hlsearch', 'Highlight Search Matches'),
    { desc = 'Toggle highlight search matches' }
)
vim.keymap.set('n', '<Leader>us', toggle('spell', 'Spell Check'), { desc = 'Toggle spell check' })
vim.keymap.set('n', '<Leader>un', toggle('number', 'Line Numbers'), { desc = 'Toggle line numbers' })
vim.keymap.set(
    'n',
    '<Leader>ur',
    toggle('relativenumber', 'Relative Line Numbers'),
    { desc = 'Toggle relative line numbers' }
)
vim.keymap.set('n', '<leader>ut', vim.treesitter.inspect_tree, { desc = 'Inspect tree-sitter tree' })
vim.keymap.set('n', '<Leader>uu', function()
    require('undotree').open()
end, { desc = 'Toggle undo tree' })

-- Toggle QuickFix List
-- See `:help default-mappings`; `:help [q`; `:help ]q`
vim.keymap.set('n', '<Leader>q', function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd('cclose')
    else
        vim.cmd('copen')
    end
end, { desc = 'Toggle quickfix window' })

-- Toggle Location List
vim.keymap.set('n', '<Leader>l', function()
    if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
        vim.cmd('lclose')
    else
        vim.cmd('lopen')
    end
end, { desc = 'Toggle location list' })

-- Toggle Terminal Window
---- Preserved terminal's buffer ID between key presses
local terminal_buffer
vim.keymap.set('n', '<Leader>t', function()
    -- Look for a window displaying terminal_buffer:
    ---- If terminal_buffer is truthy—it contains a buffer ID—return window ID that displays terminal_buffer,
    ---- or return -1 if terminal buffer is not displayed—in the current tab.
    local terminal_window = terminal_buffer and vim.fn.bufwinid(terminal_buffer) or -1

    -- If terminal_window is visible (value ≠ -1),
    -- stop terminal input mode, and hide window displaying terminal buffer,
    -- while preserving terminal_buffer and the shell.
    if terminal_window ~= -1 then
        vim.cmd('stopinsert')
        vim.api.nvim_win_hide(terminal_window)

        -- Return in order to prevent immediate reoping of the terminal_window
        return
    end

    -- If no window displays terminal_buffer,
    -- open new window in a horizontal split below current window.
    vim.cmd('belowright split')
    -- If saved terminal_buffer still exists, display it in the current window (0),
    -- otherwise, launch new terminal and the shell, and preserve terminal_buffer
    if terminal_buffer and vim.api.nvim_buf_is_valid(terminal_buffer) then
        vim.api.nvim_win_set_buf(0, terminal_buffer)
    else
        vim.cmd('terminal')
        terminal_buffer = vim.api.nvim_get_current_buf()
    end

    -- Set terminal window to 20% of Neovim's total height
    vim.api.nvim_win_set_height(0, math.max(1, math.floor(vim.o.lines * 0.2)))
    -- Enter input mode as soon terminal is launched
    vim.cmd('startinsert')
end, { desc = 'Toggle terminal split' })

-- Global LSP Configuration
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(e)
        local bufopts = { buffer = e.buf }
        -- See :help lsp-defaults
        vim.keymap.set('n', 'grd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, bufopts)
    end,
})

-- Markdown rendering with `leaf`
-- https://github.com/RivoLink/leaf
vim.keymap.set(
    'n',
    '<Leader>rm',
    '<Cmd>vertical botright terminal leaf -w %<CR>',
    { desc = 'Render markdown with Leaf' }
)
