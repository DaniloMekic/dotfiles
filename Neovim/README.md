# Resolve System Dependencies
```shell
bash <(curl -s https://raw.githubusercontent.com/DaniloMekic/dotfiles/refs/heads/main/bootstrap) --nvim
```

# Core Plugin Stack
- **Language Server Protocol** (LSP) **Server Management**: [Mason](github.com/mason-org/mason.nvim)
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
`<Leader>q`         Toggle quickfix window

## LSP
`K`                 Display hover information about the symbol under the cursor in a floating window
`gra`               Select code action available at cursor position
`gri`               List all the implementations for the symbol under the cursor in the quickfix window
`grn`               Rename all references to the symbol under the cursor
`grt`               Jump to the definition of the *type* of the symbol under the cursor
`grd`               Jump to the definition of the symbol under the cursor
`grD`               Jump to the declaration of the symbol under the cursor (many servers do not implement this method)
`grx`               Run code lens at the current cursor position
`gO`                List all symbols in the current buffer in the location-list
`gx`                Open document links (`textDocument/documentLink`)

## Text Objects
`[count]` **operator** with a **modifier**, and an **object**.

Cursor position in examples is marked with `*`.

| Key | Name | Source | Example | `a` selects | `i` selects | Notes |
|---|---|---|---|---|---|---|
| `w` | word | Vim | `foo *bar baz` | `bar ` | `bar` | Not overridden by mini.ai |
| `W` | WORD (non-blank run) | Vim | `a.b(*c) d` | `a.b(c) ` | `a.b(c)` | Not overridden by mini.ai |
| `s` | sentence | Vim | `One. *Two. Three.` | `Two. ` | `Two.` | Not overridden by mini.ai |
| `p` | paragraph | Vim | cursor in a block of text | paragraph + blank line | paragraph | Not overridden by mini.ai |
| `B` | `{}` block | Vim | `if (x) { *y; }` | `{ y; }` | ` y; ` | Not overridden by mini.ai (uppercase Latin letter) |
| `(` `[` `{` `<` | balanced bracket, trims inner whitespace | mini.ai (replaces Vim) | `f( *x )` | `( x )` | `x` | Open bracket = inner edge whitespace excluded |
| `)` `]` `}` `>` | balanced bracket, keeps inner whitespace | mini.ai (replaces Vim) | `f( *x )` | `( x )` | ` x ` | Close bracket = inner edge whitespace included |
| `b` | any bracket alias | mini.ai (replaces Vim) | `list.get(*i)` | `(i)` | `i` | Vim: `()` block only. mini.ai: nearest of `)` `]` `}` |
| `"` `'` `` ` `` | balanced quotes | mini.ai (replaces Vim) | `s = "*hi"` | `"hi"` | `hi` | Balanced pairs only, not the text between two strings |
| `q` | any quote alias | mini.ai | `c = '*x'` | `'x'` | `x` | Nearest of `"` `'` `` ` `` |
| `t` | tag | mini.ai (replaces Vim) | `<x><y>*a</y></x>` | `<y>a</y>` | `a` | Repeat `at` to expand to `<x>...</x>` |
| `f` | function call | mini.ai | `Math.max(*a, b)` | `Math.max(a, b)` | `a, b` | Call, not definition. Name may contain `.` |
| `a` | argument | mini.ai | `f(*a, g(b, c))` | `a,` | `a` | Ignores commas inside nested brackets/quotes |
| `?` | user prompt | mini.ai | `e*e o` (edges `e`, `o`) | `e o` | ` ` | Asks for left and right edge strings |
| punctuation / digit / space | default separator | mini.ai | `aa_*b__cc` (typed `_`) | `_b__` | `b` | `a` includes only the right edge |


| Keys | Feature | Source | Notes |
|---|---|---|---|
| `an` / `in` (Visual) | incremental selection (parent / child node) | Neovim 0.12 | Overridden by mini.ai's "next" variant by default |
| `al` / `il` | buffer / line textobjects | Neovim 0.13 | Overridden by mini.ai's "last" variant by default |
| `an)` `in)` `al)` `il)` | next / last textobject | mini.ai | Forces search forward / backward |
| `2a)` `3if` | count | mini.ai | Selects the 2nd / 3rd enclosing match |
| `va)` then `a)` | consecutive application | mini.ai | Expands selection outward |
| `g[)` / `g])` | goto edge | mini.ai | Move cursor to left / right edge of `a` textobject |

## UI
`<Leader>uw`        Toggle wrap
`<Leader>uh`        Stop highlighting search matches
`<Leader>uH`        Highlight search matches
`<Leader>us`        Toggle spell check
`<Leader>un`        Toggle line numbers
`<Leader>ur`        Toggle relative line numbers
`<Leader>ut`        Inspect tree-sitter tree
`<Leader>uu`        Toggle undo tree

### Folding
Folding is powered by Tree-sitter, with `'foldexpr'` being set to `v:lua.vim.treesitter.foldexpr()`. LSP-based folding is also available with `v:lua.vim.lsp.foldexpr()`.
`za`                Toggle the fold under the cursor
`zo` / `zc`         Open / close fold
`zO` / `zC`         Open / close fold and all nested folds
`zR` / `zM`         Open / close all folds
`zi`                Toggle `'foldenable'`
`zj` / `zk`         Move to the next / previous fold
`[z` / `]z`         Move to the start / end of the current fold
