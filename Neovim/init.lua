require("config.lazy")
require("config.options")
require("config.keymap")
require("config.variables")
require("config.diagnostics")
require("config.lsp")

vim.lsp.enable({
    "plsql",

    -- For possible future integration with new Neovim 0.11+ LSP API
    -- Manual JDTLS loading and configuration via `nvim/lua/config/java.lua`
    --"jdtls",
})
