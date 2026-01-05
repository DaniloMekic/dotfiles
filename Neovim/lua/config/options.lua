-- Text lines
vim.opt.number = true                            -- Print line number in front of each line.
vim.opt.relativenumber = true                    -- Show the line number relative to the line with the cursor in front of each line.
vim.opt.numberwidth = 4                          -- Width of the line number.
vim.opt.signcolumn = auto                        -- Render signcolumn only when there is sign to show.
vim.opt.cursorline = true                        -- Highlight the text line of the cursor.

-- <Tab> spaces to <Space>
vim.opt.expandtab = true                         -- In Insert mode when Tab key is pressed inserts <Space> characters. Number of <Space> characters is determined by 'tabstop' option.
vim.opt.tabstop = 4                              -- Number of virtual columns a <Tab> character will occupy.
vim.opt.softtabstop = 4                          -- While performing editing operations, like inserting a <Tab> or using <BS>, cursor will move to columns divisible by `softtabstop` value.
vim.opt.shiftwidth = 4                           -- Number of spaces to use for each step of (auto)indent. Used for 'cindent', >>, <<, etc.

-- Indentation
vim.opt.smarttab = true                          -- A <Tab> in front of a line inserts blanks according to 'shiftwidth'.
vim.opt.smartindent = true                       -- Autoindent when starting a new line.
vim.opt.autoindent = true                        -- Keep indentation from previous line.

-- Display control characters
vim.opt.list = true                              -- Enable 'list' mode.
vim.opt.listchars = {                            -- Strings to use in 'list' mode.
  tab = ">-",
  space = "·",
  lead = "·",
  trail = "·",
  eol = "$"
}

-- Searching
vim.opt.ignorecase = true
vim.opt.smartcase = true                         -- If search string contains at least one uppercase letter, it performs case-sensitive search.

vim.opt.splitright = true                        -- Splitting a window vertically will put the new window right of the current one.
vim.opt.splitbelow = true                        -- Splitting a window horizontally will put the new window below the current one.
vim.opt.wrap = false                             -- Text wrapping.
vim.opt.scrolloff = 999                          -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.inccommand = "split"                     -- When nonempty, shows the effects of :substitute, :smagic, :snomagic and user commands with the :command-preview flag as you type.
vim.opt.showcmd = true                           -- Show (partial) command in the last line of the screen.

-- Colors
vim.opt.termguicolors = true                     -- Enables 24-bit RGB color in the TUI.

vim.opt.undofile = true
vim.opt.showmode = false                         -- Disabling since custom status line displays current mode.

-- Spell check
vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = "full"                        -- How Vim handles <Tab> completion.

vim.opt.winborder = "rounded"
