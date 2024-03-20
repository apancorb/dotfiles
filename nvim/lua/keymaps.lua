-- Delete the current buffer.
vim.keymap.set('n', '<leader>d', '<cmd>bdelete<cr>')
-- Go to the next buffer.
vim.keymap.set('n', '<leader>n', '<cmd>bnext<cr>')
-- Clear highlighted search on pressing <Esc> in normal mode.
vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')
-- Avoid deleted chars to clipboard.
vim.keymap.set('n', 'x', '"_x')
-- Move highlighted text down.
vim.keymap.set('v', 'J', ":m '>+1<cr>gv=gv")
-- Move highlighted text up.
vim.keymap.set('v', 'K', ":m '<-2<cr>gv=gv")
-- Replace current word in buffer.
vim.keymap.set('n', '<leader>s', [[:%s/\<<c-r><c-w>\>/<c-r><c-w>/gI<Left><Left><Left>]])
-- Split window vertically.
vim.keymap.set('n', '<leader>wv', "<c-w>v")
-- Split window horizontally.
vim.keymap.set('n', '<leader>wh', '<c-w>s')
-- Ensure splitted windows are of equal width.
vim.keymap.set('n', '<leader>we', '<c-w>=')
-- Close current split window.
vim.keymap.set('n', '<leader>wd', '<cmd>close<cr>')
