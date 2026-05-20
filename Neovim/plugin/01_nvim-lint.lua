require("lint").linters_by_ft = {
    -- Linters are automatically installed via mason-nvim-lint
    groovy = { "npm-groovy-lint" },
    javascript = { "eslint_d" },
    python = { "ruff" },
    typescript = { "eslint_d" },
}
