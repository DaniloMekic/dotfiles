return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  keys = {
    { "<Leader>ff", function () require("fzf-lua").files() end, desc = "Find file by name" },
    { "<Leader>fg", function() require("fzf-lua").live_grep() end, desc = "Find file contents by grepping" }
  }
}
