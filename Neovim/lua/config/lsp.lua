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
