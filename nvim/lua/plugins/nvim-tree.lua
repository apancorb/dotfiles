local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
  return
end

-- recommended settings from nvim-tree docs
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

nvimtree.setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "o", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  -- disable window_picker for
  -- explorer to work well with
  -- window splits
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
})

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
