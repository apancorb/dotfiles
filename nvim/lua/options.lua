-- UTF-8 encoding for reading and writing files.
vim.opt.encoding = 'utf-8'
-- Uses the terminal's true color capabilities.
vim.opt.termguicolors = true
-- Disables the mouse device.
vim.opt.mouse = ''
-- Informs the editor that the background color of your terminal is dark.
vim.opt.background = 'dark'
-- Ensures that the sign column is always visible.
vim.opt.signcolumn = 'yes'
-- Uses relative line numbers for jumping between lines.
vim.opt.relativenumber = true
-- Disables line wrapping.
vim.opt.wrap = false
-- Keep at least 8 lines visible above and below the cursor when scrolling.
vim.opt.scrolloff = 8
-- Width of a tab character in spaces.
vim.opt.tabstop = 4 
vim.opt.softtabstop = 4
-- Number of spaces to use for each level of indentation.
vim.opt.shiftwidth = 4
-- Uses spaces for indentation instead of tab characters.
vim.opt.expandtab = true
-- Case-insensitive searches only if the search pattern contains lowercase characters.
vim.opt.smartcase = true
-- Highlights search matches as you type a search pattern.
vim.opt.hlsearch = true
-- Updates the search matches as you type the search pattern.
vim.opt.incsearch = true
-- Display live previews of the substitution results as you type the command.
vim.opt.inccommand = 'split'
-- Disables the creation of swap files.
vim.opt.swapfile = false
-- Disables the creation of backup files.
vim.opt.backup = false
-- Enable the creation of undo files.
vim.opt.undofile = true
-- Destination directory of undo files.
vim.opt.undodir = vim.fn.stdpath 'data' .. '/undodir'
-- Frequency of triggering the CursorHold autocmd event for better performance.
vim.opt.updatetime = 100
