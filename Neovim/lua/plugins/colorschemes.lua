return {
  {
    "ellisonleao/gruvbox.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {},
    init = function ()
        vim.cmd([[colorscheme gruvbox]])
    end
  },
  {
    "sainnhe/gruvbox-material",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {},
    init = function ()
        vim.g.gruvbox_material_enable_italic = true
        vim.g.gruvbox_material_background = "hard"
        vim.g.gruvbox_material_foreground = "material"
        vim.cmd([[colorscheme gruvbox-material]])
    end
  },
  {
    "rebelot/kanagawa.nvim",
    url = "https://github.com/rebelot/kanagawa.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {
      theme = "wave"
    },
    init = function ()
        vim.cmd([[colorscheme kanagawa-wave]])
    end
  },
  {
    "catppuccin/nvim",
    url = "https://github.com/catppuccin/nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    name = "catppuccin",
    opts = {}
  },
  {
    "folke/tokyonight.nvim",
    url = "https://github.com/folke/tokyonight.nvim",
    enabled = false,
    lazy = false,
    priority = 1000,
    opts = {}
  }
}
