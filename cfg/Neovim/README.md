# Resolve System Dependencies

```shell
bash <(curl -s https://raw.githubusercontent.com/DaniloMekic/dotfiles/refs/heads/main/bootstrap) --nvim
```

## Core Plugin Stack

- **Code Formatter Runner**: [Conform](https://github.com/stevearc/conform.nvim)
- **Linter Engine**: [nvim-lint](https://github.com/mfussenegger/nvim-lint)
- **Code Completion Engine**: [blink.cmp](https://github.com/Saghen/blink.cmp)
- **Snippet Engine**: [LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- **Debug Adapter Protocol** (DAP) **Client**: [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- **Picker**: [Fzf-Lua](https://github.com/ibhagwan/fzf-lua)

## Language Tools

LSP servers, DAP servers (debuggers), linters, and code formatters are installed as packages from the Arch Linux [official repositories](https://wiki.archlinux.org/title/Official_repositories) and the [AUR](https://wiki.archlinux.org/title/Arch_User_Repository).

To view health check for LSPs and their configurations, run `:checkhealth vim.lsp`.
To view configured and available formatters, including the log file, run `:ConformInfo`.

## Update All Plugins

```lua
--- https://neovim.io/doc/user/pack/#vim.pack.update()
vim.pack.update()
```

## Keybindings

Find source of a keybind with:

```vimscript
:verbose map <key>
:verbose nmap <key>     " Normal mode
:verbose imap <key>     " Insert mode
:verbose xmap <key>     " Visual mode
```

- [Default mappings](https://neovim.io/doc/user/vim_diff/#default-mappings)

| Keys | Action |
|---|---|
| `<Leader>w` | Write buffer to the file |
| `<Leader>q` | Toggle quickfix window |
| `gq` | Format the lines that `{motion}` moves over, with `'formatexpr'` being set to the [Conform](https://github.com/stevearc/conform.nvim)'s function |
| `<Leader>y` | Yank to system clipboard |
| `<Leader>Y` | Yank line(s) to system clipboard |
| `<Leader>p` / `<Leader>P` | Put from system clipboard before/after cursor |
| `<Leader>e` | Explore files ([mini.files](https://github.com/nvim-mini/mini.files)) |
| `<` / `>` | In visual mode, indent/re-indent line and reselect |
| `<Alt>` + `hjkl` | Move line(s) or, in visual mode, move selection |
| `ga` | Get ASCII values—decimal, hexadecimal, octal—of the character under the cursor |
| `gt` / `gT` | Tab next/previous |

### Picker

| Keys | Action |
|---|---|
| `<Leader>ff` | Find files |
| `<Leader>fo` | Find old files |
| `<Leader>fg` | Grep files |
| `<Leader>fb` | Find buffers |

### LSP

- <https://neovim.io/doc/user/lsp/>

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

### Diagnostics

- <https://neovim.io/doc/user/diagnostic/>

| Keys | Action |
|---|---|
| `]d` / `[d` | Jump to the next/previous diagnostic |
| `]D` / `[D` | Jump to the last/first diagnostic |
| `CTRL-W_d` | Show diagnostics in a floating window; mapped to `vim.diagnostic.open_float()` |

### Text Objects

- <https://neovim.io/doc/user/usr_04/#_text-objects>
- <https://neovim.io/doc/user/vimindex/#_2.1-text-objects>
- <https://neovim.io/doc/user/motion/#_5.-text-object-motions>
- <https://neovim.io/doc/user/motion/#_6.-text-object-selection>
- <https://neovim.io/doc/user/treesitter/#treesitter-defaults>

`[count]` **operator** with a **modifier** (`a`/`i`), and an **object**.

Modifiers specify whether surrounding delimiters and *trailing* whitespace is included (`a`), or if only content inside the object is operated on (`i`).

### Plugin: mini.surround

 Two "modes", *input* (in `delete` and `replace` start, `find`, and `highlight`) and *output* (in `add` and `replace` end).

| Keys | Action |
|---|---|
| `sa{motion}X` | Add surrounding `X`, in visual mode or with a motion |
| `sdX` | Delete surrounding `X` |
| `srX` | Replace surrounding `X` |
| `sfX` / `sFX` | Find next/previous surrounding `X` |
| `shX` | Highlight surrounding `X` |

Surrounding is identified by a single character:

- All symbols in brackets `()`, `[]`, `{}`, `<>`. In "input" represents balanced brackets (open – with whitespace pad, close – without), in "output" – left and right parts of brackets.
- `t` – tag. In "input" finds tag with same identifier, in "output" prompts user to enter tag name with possible attributes.
- `f` - function call (string of alphanumeric symbols or `_` or `.` followed by balanced `()`). In "input" finds function call, in "output" prompts user to enter function name.
- `?` - interactive. Prompts user to enter left and right parts.
- All other single character identifiers (supported by `getcharstr()`) represent surrounding with identical left and right parts.

### Debugging

| Keys | Action |
|---|---|
| `<Leader>dc` / `<F5>` | Continue |
| `<Leader>db` / `<F9>` | Toggle breakpoint |
| `<Leader>do` / `<F10>` | Step over |
| `<Leader>di` / `<F11>` | Step into |
| `<Leader>dI` / `<F12>` | Step out |
| `<Leader>dt` | Terminate |
| `<Leader>dr` | Read–Eval–Print Loop (REPL) |

### UI

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

### Plugin: obsidian.nvim

| Keys | Action |
|---|---|
| `<Leader>on` | New note |
| `<Leader>or` | Rename |
| `<Leader>ob` | Backlinks |
| `<Leader>ol` | Links |
| `<Leader>ot` | Tags |

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
