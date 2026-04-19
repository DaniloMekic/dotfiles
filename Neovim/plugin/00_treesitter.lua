require("nvim-treesitter").install({
    "awk",
    "bash",
    "c",
    "css",
    "csv", -- CSV, PSV, TSV
    "dockerfile",
    "git_config",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
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
    pattern = {
        "awk",
        "bash",
        "c",
        "css",
        "csv",
        "dockerfile",
        "gitattributes",
        "gitcommit",
        "gitconfig",
        "gitrebase",
        "html",
        "hurl",
        "hyprlang",
        "java",
        "javascript",
        "jq",
        "json",
        "lua",
        "markdown",
        "passwd",
        "python",
        "rust",
        "sql",
        "sshconfig",
        "tmux",
        "toml",
        "vim",
        "xml",
        "yaml",
    },
    callback = function()
        vim.treesitter.start()
    end,
})

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})
