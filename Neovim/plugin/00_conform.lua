---@module "conform"
require('conform').setup({
    ---@type conform.setupOpts
    -- Formatters are automatically installed with Mason via mason-conform plugin
    formatters_by_ft = {
        -- clangd LSP embeds clang-format, a code formatter for C/C++/C# and other languages
        -- Styling options can be controlled with .clang-format file
        -- https://clang.llvm.org/docs/ClangFormatStyleOptions.html
        -- Since LSP formatting is disabled globally, clang-format needs to be added separately
        bash = { 'shfmt' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        groovy = { 'npm-groovy-lint' },
        java = { 'google-java-format' },
        javascript = { 'prettierd', 'prettier' },
        javascriptreact = { 'prettierd', 'prettier' },
        json = { 'jq' },
        kdl = { 'kdlfmt' },
        lua = { 'stylua' },
        perl = { 'perltidy ' },
        python = { 'isort', 'black' },
        rust = { 'rustfmt' },
        sh = { 'shfmt' },
        tex = { 'tex-fmt' },
        typst = { 'typstyle' },
        typescript = { 'prettierd', 'prettier' },
        typescriptreact = { 'prettierd', 'prettier' },
        xml = { 'xmllint' },
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
        xmllint = {
            -- https://gnome.pages.gitlab.gnome.org/libxml2/xmllint.html
            env = {
                XMLLINT_INDENT = '    ',
            },
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
