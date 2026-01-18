---@type LazySpec
return {
    "rcarriga/nvim-dap-ui",
    opts = {},
    keys = {
        { "<Leader>du", function() require("dapui").toggle() end, desc = "DAP UI" },
        { "<Leader>de", function() require("dapui").eval() end, desc = "DAP Eval" },
    },
    dependencies = {
        {
            "mfussenegger/nvim-dap",
            ---@type LazyKeysSpec[]
            keys = {
                { "<F5>", function() require("dap").continue() end, desc = "Debugging: Continue" },
                { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debugging: Toggle breakpoint" },
                { "<F10>", function() require("dap").step_over() end, desc = "Debugging: Step Over" },
                { "<F11>", function() require("dap").step_into() end, desc = "Debugging: Step Into" },
                { "<F12>", function() require("dap").step_out() end, desc = "Debugging: Step Out" },
                { "<Leader>dt", function() require("dap").terminate() end, desc = "Debugging: Terminate" },
            }
        },
        "nvim-neotest/nvim-nio",
    },
}
