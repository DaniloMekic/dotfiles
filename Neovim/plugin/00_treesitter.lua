require("nvim-treesitter").install({
    "awk",
    "bash",
    "c",
    "css",
    "csv", -- CSV, PSV, TSV
    "dockerfile",
    "git_config",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "git_rebase",
    "html",
    "hurl",
    "hyprlang", -- Hyprland Configuration Language
    "java",
    "javadoc",
    "javascript",
    "jq",
    "json",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "passwd",
    "properties", -- Java Properties File
    "python",
    "query",
    "rust",
    "sql",
    "ssh_config",
    "tmux",
    "toml",
    "vim", -- Vimscript
    "vimdoc",
    "xml",
    "yaml",
})

-- Enable syntax highlighting
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "hurl" },
    callback = function()
        vim.treesitter.start()
    end,
})
