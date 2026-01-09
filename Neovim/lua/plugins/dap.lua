return {
    "rcarriga/nvim-dap-ui",
    opts = {},
    dependencies = {
        {
            "mfussenegger/nvim-dap",
            keys = {
                { "<Leader>dt", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
                { "<Leader>dc", function () require("dap").continue() end, desc = "Continue" }
            }
        },
        "nvim-neotest/nvim-nio",
    },
}
