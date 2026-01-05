:filetype on
:syntax on

" Terminal
" ANSI Escape Codes for Cursor
let &t_EI = "\e[2 q"  " NORMAL Mode: Steady Block
let &t_SR = "\e[3 q"  " REPLACE Mode: Blinking Underline
let &t_SI = "\e[5 q"  " INSERT Mode: Blinking Bar

set nocompatible

set number
set relativenumber
set showmode

" TAB spaces to WHITESPACE
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Indendation
set smarttab
set smartindent
set autoindent

" Display control characters
set list
set listchars=tab:>-,space:·,trail:·,eol:$

" Searching
set ignorecase
set smartcase

set splitright
set splitbelow
set nowrap
set scrolloff=999

" CLI Completions
set wildmenu
set wildchar=<Tab>
set wildoptions=""

function! ToggleQuickFixWindow()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
    else
        cclose
    endif
endfunction

" Keymaps
let g:mapleader = " "
nnoremap <Leader>w :write<CR>
nnoremap <Leader>q :call ToggleQuickFixWindow()<CR>
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>

" Colors
set termguicolors
packadd! gruvbox-material
set background=dark
let g:gruvbox_material_background = "hard"
let g:gruvbox_material_foreground = "material"
let g:gruvbox_material_enable_bold = 0
colorscheme gruvbox-material
