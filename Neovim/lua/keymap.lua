-- Explore `h: defaults`
-- Useful defaults:
---- Display hover info about symbol under the cursor: `:help K` and `:help vim.lsp.buf.hover()`
---- Go to definition: `:help gd`
---- Comment lines: `:help gc`
---- References: `:help grr`

vim.g.mapleader = " "

vim.keymap.set("n", "<Leader>w", ":write<CR>")

-- QuickFix List
-- See `:help default-mappings`; `:help [q`; `:help ]q`
vim.keymap.set(
    "n",
    "<Leader>q",
    function ()
        if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
            vim.cmd("cclose")
        else
            vim.cmd("copen")
        end
    end,
    { desc = "Toggle quickfix window" })

--- Global LSP Configuration
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(e)
    local bufopts = { buffer = e.buf }
    -- See :help lsp-defaults
    vim.keymap.set("n", "grd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "grD", vim.lsp.buf.declaration, bufopts)
  end
})
