local telescope_status, telescope = pcall(require, "telescope")
if not telescope_status then
  return
end

local actions_status, actions = pcall(require, "telescope.actions")
if not actions_status then
  return
end

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },
    },
  },
  extensions = {
    file_browser = {
      theme = "dropdown",
      hijack_netrw = true,
      mappings = {
        n = {
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          ["a"] = telescope.extensions.file_browser.actions.create,
          ["o"] = telescope.extensions.file_browser.actions.goto_parent_dir,
        },
      },
    },
  }
})

telescope.load_extension("fzf")
telescope.load_extension("file_browser")

local function telescope_buffer_dir()
  return vim.fn.expand("%:p:h")
end

vim.keymap.set("n", "<leader>f", ":Telescope find_files hidden=true<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>fG", ":Telescope grep_string<CR>")
vim.keymap.set("n", "<leader>fe", function()
  telescope.extensions.file_browser.file_browser({
    path = "%:p:h",
    cwd = telescope_buffer_dir(),
    respect_gitignore = false,
    hidden = true,
    grouped = true,
    previewer = false,
    initial_mode = "normal",
    layout_config = { height = 40 }
  })
end)
