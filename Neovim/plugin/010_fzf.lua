require("fzf-lua").setup({ "default" })

vim.keymap.set("n", "<Leader>ff", function() require("fzf-lua").files() end, { desc = "Find files" })
vim.keymap.set("n", "<Leader>fg", function() require("fzf-lua").live_grep() end, { desc = "Grep files" })
