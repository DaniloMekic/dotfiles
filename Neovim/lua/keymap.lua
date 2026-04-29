-- Explore `h: defaults`
-- Useful defaults:
---- Display hover info about symbol under the cursor: `:help K` and `:help vim.lsp.buf.hover()`
---- Go to definition: `:help gd`
---- Comment lines: `:help gc`
---- References: `:help grr`

vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>w", ":write<CR>")

-- Indentation
vim.keymap.set("v", "<", "<gv", { desc = "Indent line and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Re-indent line and reselect" })

-- Move lines and indent
vim.keymap.set("n", "<M-j>", ":move .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<M-k>", ":move .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<M-j>", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<M-k>", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })

-- QuickFix List
-- See `:help default-mappings`; `:help [q`; `:help ]q`
vim.keymap.set("n", "<Leader>q", function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end, { desc = "Toggle quickfix window" })

--- Global LSP Configuration
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(e)
        local bufopts = { buffer = e.buf }
        -- See :help lsp-defaults
        vim.keymap.set("n", "grd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "grD", vim.lsp.buf.declaration, bufopts)
    end,
})
