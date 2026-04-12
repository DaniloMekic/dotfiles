require("dapui").setup()

vim.keymap.set("n", "<Leader>du", function() require("dapui").toggle() end, { desc = "Debugging: UI" })
vim.keymap.set("n", "<Leader>de", function() require("dapui").eval() end, { desc = "Debugging: Evaluate Expression" })
