# Resolve System Dependencies
```shell
bash <(curl -s https://raw.githubusercontent.com/DaniloMekic/dotfiles/refs/heads/main/bootstrap) --nvim
```

# Core Plugin Stack
- **Language Server Protocol** (LSP) **Server Management**: [Mason](https://github.com/mason-org/mason.nvim)
- **Code Formatter Runner**: [Conform](https://github.com/stevearc/conform.nvim)
- **Linter Engine**: [nvim-lint](https://github.com/mfussenegger/nvim-lint)
- **Code Completion Engine**: [blink.cmp](https://github.com/Saghen/blink.cmp)
- **Snippet Engine**: [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **Debug Adapter Protocol** (DAP) **Client**: [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- **Picker**: [Fzf-Lua](https://github.com/ibhagwan/fzf-lua)

# Language Tools
Installation of LSP servers, DAP servers (debuggers), linters, and code formatters is done via [Mason](https://github.com/mason-org/mason.nvim).

Mason package installation is automated via following plugins, that also perform other tasks:
- `mason-tool-installer` is purely for package installation in a declarative way.
- `mason-lspconfig` bridges `nvim-lspconfig` and initializes LSP servers—there is no need to call `vim.lsp.enable({name})`.
- `mason-nvim-dap` bridges `nvim-dap` and configures debuggers.
- `mason-nvim-lint` connects Mason's installed linters to the `nvim-lint`.

# Update All Plugins
```lua
--- https://neovim.io/doc/user/pack/#vim.pack.update()
vim.pack.update()
```

# Keybindings

| Keys | Action |
|---|---|
| `<Leader>q` | Toggle quickfix window |
| `gq` | Format the lines that `{motion}` moves over, with `'formatexpr'` being set to the Conform's function |

## LSP

| Keys | Action |
|---|---|
| `K` | Display hover information about the symbol under the cursor in a floating window |
| `gra` | Select code action available at cursor position |
| `gri` | List all the implementations for the symbol under the cursor in the quickfix window |
| `grn` | Rename all references to the symbol under the cursor |
| `grt` | Jump to the definition of the *type* of the symbol under the cursor |
| `grd` | Jump to the definition of the symbol under the cursor |
| `grD` | Jump to the declaration of the symbol under the cursor (many servers do not implement this method) |
| `grx` | Run code lens at the current cursor position |
| `gO` | List all symbols in the current buffer in the location-list |
| `gx` | Open document links (`textDocument/documentLink`) |

## Text Objects

`[count]` **operator** with a **modifier**, and an **object**.

Modifiers specify whether whitespace around the object is included (`a`), or if only content inside the object is operated on (`i`).

[mini.ai](https://github.com/nvim-mini/mini.ai) plugin modifies how open brackets (`(`, `[`, `{`) differ from close brackets (`)`, `]`, `}`) by how they treat inner edge whitespace for `i` textobject: open ignores it, close - includes.


| Object | Description | Source |
|---|---|---|
| `w` | word | Vim |
| `W` | WORD | Vim |
| `s` | sentence | Vim |
| `p` | paragraph | Vim |
| `B` | code block | Vim |
| `(`, `[`, `{` | balanced bracket, trims enclosing whitespace | mini.ai |
| `)`, `]`, `}` | balanced bracket, keeps enclosing whitespace | mini.ai |
| `b` | any bracket | mini.ai (overrides Vim) |
| `"`, `'`, `` ` `` | balanced quotes | mini.ai (overrides Vim) |
| `q` | any quote | mini.ai |
| `t` | <tag>; repeat `at` to expand outwards | mini.ai (overrides Vim) |
| `f` | function call | mini.ai |
| `a` | argument of a function | mini.ai |
| `?` | user prompt for left and right edge, strings that could be different | mini.ai |
| punctuation / digit / space | typed separator that does not have a dedicated text object | mini.ai |


| Keys | Feature | Source | Notes |
|---|---|---|---|
| `an` / `in` (Visual) | incremental selection (parent / child node) | Neovim 0.12 | Overridden by mini.ai's "next" variant by default |
| `al` / `il` | buffer / line textobjects | Neovim 0.13 | Overridden by mini.ai's "last" variant by default |
| `an)` `in)` `al)` `il)` | next / last textobject | mini.ai | Forces search forward / backward |
| `2a)` `3if` | count | mini.ai | Selects the 2nd / 3rd enclosing match |
| `va)` then `a)` | consecutive application | mini.ai | Expands selection outward |
| `g[)` / `g])` | goto edge | mini.ai | Move cursor to left / right edge of `a` textobject |

## UI

| Keys | Action |
|---|---|
| `<Leader>uw` | Toggle wrap |
| `<Leader>uh` | Stop highlighting search matches |
| `<Leader>uH` | Highlight search matches |
| `<Leader>us` | Toggle spell check |
| `<Leader>un` | Toggle line numbers |
| `<Leader>ur` | Toggle relative line numbers |
| `<Leader>ut` | Inspect tree-sitter tree |
| `<Leader>uu` | Toggle undo tree |

### Folding

Folding is powered by Tree-sitter, with `'foldexpr'` being set to `v:lua.vim.treesitter.foldexpr()`. LSP-based folding is also available with `v:lua.vim.lsp.foldexpr()`.


| Keys | Action |
|---|---|
| `za` | Toggle the fold under the cursor |
| `zo` / `zc` | Open / close fold |
| `zO` / `zC` | Open / close fold and all nested folds |
| `zR` / `zM` | Open / close all folds |
| `zi` | Toggle `'foldenable'` |
| `zj` / `zk` | Move to the next / previous fold |
| `[z` / `]z` | Move to the start / end of the current fold |
