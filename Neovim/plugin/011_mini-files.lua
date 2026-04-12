require("mini.files").setup({
	version = false,
})

vim.keymap.set("n", "<Leader>e", function() MiniFiles.open() end, { desc = "Explore" })
