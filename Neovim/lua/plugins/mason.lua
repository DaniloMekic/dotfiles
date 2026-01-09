return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ---@type string[]
        ensure_installed = {
            -- Valid LSP Names: github.com/neovim/nvim-lspconfig/tree/master/lsp
            "vimls",                   -- VimScript
            "jdtls",                   -- Java
            "clangd",                  -- C, C++
            "lua_ls",                  -- Lua
            "html",                    -- HTML
            "cssls",                   -- CSS
            "ts_ls",                   -- TypeScript
            "basedpyright",            -- Python LSP
            "ruff",                    -- Python Linter/Code Formatter
            "bashls",                  -- Bash
            "markdown_oxide",          -- Markdown
            "jsonls",                  -- JSON
            "lemminx",                 -- XML
            "yamlls",                  -- YAML
            "taplo",                   -- TOML
            "docker_language_server",  -- Docker
            "texlab",                  -- LaTeX
            "sqls",                    -- SQL
            "postgres_lsp",            -- PostgreSQL
        },
        ---@type boolean | string[] | { exclude: string[] }
        automatic_enable = {
            exclude = { "jdtls" } -- See `nvim/ftplugin/java.lua`
        }
    },
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            }
        },
        {
            "WhoIsSethDaniel/mason-tool-installer",
            -- Valid names: https://mason-registry.dev/registry/list 
            opts = {
                ensure_installed = {
                    "java-debug-adapter",
                    "java-test",
                    "vscode-spring-boot-tools"
                }
            }
        },
        "neovim/nvim-lspconfig"
    }
}
