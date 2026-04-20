vim.pack.add({
    { src = "https://github.com/sainnhe/gruvbox-material", name = "gruvbox-material" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2"), name = "luasnip" },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1"), name = "blink.cmp" },
    { src = "https://github.com/neovim/nvim-lspconfig", name = "lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim", name = "mason" },
    { src = "https://github.com/stevearc/conform.nvim", name = "conform" },
    { src = "https://github.com/zapling/mason-conform.nvim", name = "mason-conform" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", name = "mason-tool-installer" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim", name = "mason-lspconfig" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons", name = "web-devicons" },
    { src = "https://github.com/nvim-mini/mini.icons" },
    { src = "https://github.com/nvim-mini/mini.files" },
    { src = "https://github.com/nvim-lualine/lualine.nvim", name = "lualine" },
    { src = "https://github.com/mfussenegger/nvim-lint" },
    { src = "https://github.com/rshkarin/mason-nvim-lint" },
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/mfussenegger/nvim-dap-python" },
    { src = "https://github.com/docker/nvim-dap-docker" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/mfussenegger/nvim-jdtls" },
    { src = "https://github.com/andymass/vim-matchup" },
    { src = "https://github.com/JavaHello/spring-boot.nvim" },
    { src = "https://github.com/lervag/vimtex" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://tangled.org/cuducos.me/yaml.nvim" },
})

require("variables")
require("options")
require("keymap")
require("diagnostics")

vim.cmd([[colorscheme gruvbox-material]])

vim.lsp.enable({
    "plsql",
})
