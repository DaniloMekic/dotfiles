---@type vim.lsp.Config
return {
    cmd = {
        "java",
        "-jar",
        vim.fn.expand("~/.local/share/plsql_ls/plsql-ls.jar")
    },
    filetypes = { "plsql" },
}
