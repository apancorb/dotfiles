-- file encoding
vim.opt.encoding = "utf-8"
-- show relative line numbers
vim.opt.relativenumber = true
-- shows absolute line number on cursor line
vim.opt.number = true
-- 2 spaces for tabs
vim.opt.tabstop = 2
-- 2 spaces for indent width
vim.opt.shiftwidth = 2
-- expand tab to spaces
vim.opt.expandtab = true
-- copy indent from current line when starting new one
vim.opt.autoindent = true
-- disable line wrapping
vim.opt.wrap = false
-- ignore case when searching
vim.opt.ignorecase = true
-- assumes you want case-sensitive
vim.opt.smartcase = true
-- highlight the current cursor line
vim.opt.cursorline = false
-- not highlight the current search
vim.opt.hlsearch = false
-- incremental search
vim.opt.incsearch = true
-- turn on termguicolors for colorscheme to work
vim.opt.termguicolors = true
-- colorschemes that can be light or dark will be made dark
vim.opt.background = "dark"
-- show sign column so that text doesn't shift
vim.opt.signcolumn = "yes"
-- allow backspace on indent, end of line or insert mode start position
vim.opt.backspace = "indent,eol,start"
-- disable mouse
vim.opt.mouse = ""
-- use system clipboard as default register
vim.opt.clipboard:append("unnamedplus")
-- split vertical window to the right
vim.opt.splitright = true
-- split horizontal window to the bottom
vim.opt.splitbelow = true
-- keep 8 lines distance when scrolling
vim.opt.scrolloff = 10
-- no swap file
vim.opt.swapfile = false
-- no backup
vim.opt.backup = false
-- save session undofile
vim.opt.undofile = true
-- save undofile dir
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
-- consider string-string as whole word
vim.opt.iskeyword:append("-")
