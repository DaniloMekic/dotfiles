-- Explore `h: defaults`
-- Useful defaults:
---- Display hover info about symbol under the cursor: `:help K` and `:help vim.lsp.buf.hover()`
---- Go to definition: `:help gd`
---- Comment lines: `:help gc`
---- References: `:help grr`

vim.g.mapLeader = " "

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
