---@module "conform"
require('conform').setup({
    ---@type conform.setupOpts
    -- Formatters are automatically installed with Mason via mason-conform plugin
    formatters_by_ft = {
        -- clangd LSP embeds clang-format, a code formatter for C/C++/C# and other languages
        -- Styling options can be controlled with .clang-format file
        -- https://clang.llvm.org/docs/ClangFormatStyleOptions.html
        bash = { 'shfmt', lsp_format = 'fallback' },
        c = { lsp_format = 'prefer' },
        cpp = { lsp_format = 'prefer' },
        groovy = { 'npm-groovy-lint' },
        java = { 'google-java-format', lsp_format = 'fallback' },
        javascript = { 'prettierd', 'prettier' },
        json = { 'jq' },
        lua = { 'stylua' },
        python = { 'isort', 'black' },
        rust = { 'rustfmt', lsp_format = 'fallback' },
        sh = { 'shfmt', lsp_format = 'fallback' },
        tex = { 'tex-fmt' },
    },

    formatters = {
        ['google-java-format'] = {
            -- Use 4 space indents per Android Open Source Project (AOSP), instead of 2 per Google Java Style Guide
            prepend_args = { '--aosp' },
        },
        stylua = {
            prepend_args = { '--indent-type', 'Spaces', '--quote-style', 'AutoPreferSingle' },
        },
        -- shfmt man page
        -- https://github.com/mvdan/sh/blob/master/cmd/shfmt/shfmt.1.scd
        shfmt = {
            -- Google's Shell Style Guide
            -- https://google.github.io/styleguide/shellguide.html
            prepend_args = { '-i', '2', '-ci', '-bn' },
        },
    },

    -- Setup autocommand for BufWritePre event
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = 'never',
    },

    stop_after_first = true,
})

-- See `:help gq`
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
