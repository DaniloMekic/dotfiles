return {
    "stevearc/conform.nvim",

    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        -- Formatters are automatically installed with Mason via mason-conform plugin
        formatters_by_ft = {
            c = { lsp_format = "prefer" },
            cpp = { lsp_format = "prefer" },
            java = { "google-java-format", lsp_format = "fallback" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
            python = { "isort", "black" },
        },

        formatters = {
            ["google-java-format"] = {
                -- Use 4 space indents per Android Open Source Project (AOSP), instead of 2 per Google Java Style Guide
                prepend_args = { "--aosp" },
            },
        },

        -- Setup autocommand for BufWritePre event
        format_on_save = {
            -- These options will be passed to conform.format()
            timeout_ms = 500,
            lsp_format = "never",
        },
    },
}
