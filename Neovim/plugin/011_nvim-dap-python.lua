local python = vim.fn.expand("$MASON") .. "/packages/debugpy/venv/bin/python"
require("dap-python").setup(python)
