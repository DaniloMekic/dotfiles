return {{
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    config = function () 
        local treesitter = require("nvim-treesitter")

        treesitter.install({
            -- Languages
            "c",
            "java",
            "python",
            "lua",
            "javascript",
            "vim", -- Vimscript
            "sql",
            "bash",
            "awk",
            -- Markup
            "markdown",
            "markdown_inline",
            "html",
            "css",
            "json",
            "jq",
            "yaml",
            "toml",
            "csv", -- CSV, PSV, TSV
            "xml",
            -- Configs & Configuration Languages
            "git_config", "gitattributes", "gitcommit", "gitignore", "git_rebase",
            "ssh_config",
            "tmux",
            "passwd",
            "hyprlang", -- Hyprland Configuration Language
            "properties", -- Java Properties File
            "dockerfile",
            -- Docs
            "vimdoc",
            "javadoc",
            "luadoc",
            "query"
        })
    end
}}
