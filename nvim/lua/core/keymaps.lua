-- leader key
vim.g.mapleader = " "

-- avoid deleted chars to clipboard
vim.keymap.set("n", "x", '"_x')
-- move highlighted text down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
-- move highlighted text up
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- replace current word in buffer
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- split window vertically
vim.keymap.set("n", "<leader>wv", "<C-w>v")
-- split window horizontally
vim.keymap.set("n", "<leader>wh", "<C-w>s")
-- split windows equal width
vim.keymap.set("n", "<leader>we", "<C-w>=")
-- close current split window
vim.keymap.set("n", "<leader>wd", ":close<CR>")
-- vim-maximizer
vim.keymap.set("n", "<leader>m", ":MaximizerToggle<CR>")
-- undo-tree
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")
-- zen-mode
vim.keymap.set("n", "<leader>z", ":ZenMode<CR>")
