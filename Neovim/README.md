# Install
```shell
$ git clone https://github.com/DaniloMekic/nvim-config.git ~/.config/nvim
$ chmod +x ~/.config/nvim/install
$ ~/.config/nvim/install
```

## Resolve System Dependencies
```shell
$ source <(curl -s https://raw.githubusercontent.com/DaniloMekic/dotfiles/refs/heads/main/bootstrap)
$ bootstrap_nvim
```

# Core Plugin Stack
- **File Explorer**: [Yazi](https://github.com/sxyazi/yazi) + [yazi.nvim](https://github.com/mikavilpas/yazi.nvim)
- **Language Server Protocol** (LSP) **Server Management**: [Mason](github.com/mason-org/mason.nvim)
- **Code Formatting**: [conform](https://github.com/stevearc/conform.nvim), [mason-conform](https://github.com/zapling/mason-conform.nvim)
- **Linting**: [nvim-lint](https://github.com/mfussenegger/nvim-lint)
- **Code Completion Engine**: [blink.cmp](https://github.com/Saghen/blink.cmp)
- **Snippet Engine**: [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **Debug Adapter Protocol** (DAP) **Client**: [nvim-dap](https://github.com/mfussenegger/nvim-dap)
