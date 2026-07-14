# Resolve System Dependencies
```shell
source <(curl -s https://raw.githubusercontent.com/DaniloMekic/dotfiles/refs/heads/main/bootstrap)
bootstrap_nvim
```

# Core Plugin Stack
- **Language Server Protocol** (LSP) **Server Management**: [Mason](github.com/mason-org/mason.nvim)
- **Code Formatrer Runner**: [Conform](https://github.com/stevearc/conform.nvim)
- **Linter Engine**: [nvim-lint](https://github.com/mfussenegger/nvim-lint)
- **Code Completion Engine**: [blink.cmp](https://github.com/Saghen/blink.cmp)
- **Snippet Engine**: [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **Debug Adapter Protocol** (DAP) **Client**: [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- **Picker**: [Fzf-Lua](https://github.com/ibhagwan/fzf-lua)

# Language Tools
Installation of LSP servers, DAP servers (debuggers), linters, and code formatters is done via [Mason](https://github.com/mason-org/mason.nvim).

Mason package installation is automated via following plugins, that also perform other tasks:
- `mason-tool-installer` is purely for package installation in a declarative way.
- `mason-lspconfig` bridges `nvim-lspconfig` and initializes LSP servers by automatically enabling the—there is no need to call `vim.lsp.enable({name})`.
- `mason-nvim-dap` bridges `nvim-dap` and configures debuggers.
- `mason-nvim-lint` connects Mason's installed linters to the `nvim-lint`.

# Update All Plugins
```lua
--- https://neovim.io/doc/user/pack/#vim.pack.update()
vim.pack.update()
```
