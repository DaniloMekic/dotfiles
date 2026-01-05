return {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    init = function()
        vim.g.vimtex_general_viewer = "okular"
    end
}
