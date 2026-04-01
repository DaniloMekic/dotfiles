---@type @LazySpec
return {
    "mfussenegger/nvim-dap-python",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    opts = {
        python = vim.fn.expand("$MASON") .. "/packages/debugpy/venv/bin/python"
    },
    config = function(_, opts)
        require("dap-python").setup(opts.python)
    end
}
