require("mason-nvim-lint").setup({
    ignore_install = { "npm-groovy-lint" }, -- Installed via mason-tool-installer, since mason-nvim-lint/mapping.lua does not have mapping for this linter.
})
