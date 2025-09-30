local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.smarttab = true
opt.cindent = true

-- Line wrapping
opt.wrap = false

-- Search settings
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "no"
opt.colorcolumn = "80"
opt.scrolloff = 15

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard = "unnamedplus"

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Consider - as part of keyword
opt.iskeyword:append("-")

-- Disable swapfile and backup
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.undofile = true

-- Decrease update time
opt.updatetime = 300
opt.timeoutlen = 500

-- Better completion experience
opt.completeopt = "menuone,noselect"

-- Other settings from your vimrc
opt.hidden = true
opt.errorbells = false
opt.shortmess:append("c")

-- Set up colorscheme
-- vim.cmd("colorscheme gruvbox")
vim.cmd("syntax enable")
