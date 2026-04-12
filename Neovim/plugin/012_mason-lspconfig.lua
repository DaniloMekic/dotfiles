require("mason-lspconfig").setup({
        ---@type string[]
        ensure_installed = {
            -- Valid LSP Names: github.com/neovim/nvim-lspconfig/tree/master/lsp
            "awk_ls",                  -- AWK
            "basedpyright",            -- Python LSP
            "bashls",                  -- Bash
            "clangd",                  -- C, C++
            "cssls",                   -- CSS
            "docker_language_server",  -- Docker
            "html",                    -- HTML
            "jdtls",                   -- Java
            "jsonls",                  -- JSON
            "lemminx",                 -- XML
            "lua_ls",                  -- Lua
            "markdown_oxide",          -- Markdown
            "postgres_lsp",            -- PostgreSQL
            "ruff",                    -- Python Linter/Code Formatter
            "rust_analyzer",           -- Rust
            "sqls",                    -- SQL
            "taplo",                   -- TOML
            "texlab",                  -- LaTeX
            "ts_ls",                   -- TypeScript
            "vimls",                   -- VimScript
            "yamlls",                  -- YAML
        },
        ---@type boolean | string[] | { exclude: string[] }
        automatic_enable = {
            exclude = { "jdtls" } -- See `nvim/ftplugin/java.lua`
        }
})
