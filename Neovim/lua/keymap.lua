-- Explore `h: defaults`
-- Useful defaults:
---- Display hover info about symbol under the cursor: `:help K` and `:help vim.lsp.buf.hover()`
---- Go to definition: `:help gd`
---- Comment lines: `:help gc`
---- References: `:help grr`

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

-- Indentation
vim.keymap.set('v', '<', '<gv', { desc = 'Indent line and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Re-indent line and reselect' })

-- Move lines and indent
vim.keymap.set('n', '<M-j>', '<Cmd>move .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<M-k>', '<Cmd>move .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<M-j>', "<Cmd>move '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<M-k>', "<Cmd>move '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- UI
vim.keymap.set('n', '<Leader>uw', toggle('wrap', 'Wrap'), { desc = 'Toggle wrap' })
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

-- QuickFix List
-- See `:help default-mappings`; `:help [q`; `:help ]q`
vim.keymap.set('n', '<Leader>q', function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd('cclose')
    else
        vim.cmd('copen')
    end
end, { desc = 'Toggle quickfix window' })

--- Global LSP Configuration
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(e)
        local bufopts = { buffer = e.buf }
        -- See :help lsp-defaults
        vim.keymap.set('n', 'grd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, bufopts)
    end,
})
