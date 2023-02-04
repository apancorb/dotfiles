local status, bufferline = pcall(require, "bufferline")
if not status then
  return
end

bufferline.setup({
  options = {
    separator_style = "slant",
    always_show_bufferline = true,
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = true
  },
  highlights = {
    fill = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "StatusLineNC" },
    },
    background = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    buffer_visible = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    buffer_selected = {
      fg = { attribute = "fg", highlight = "Special" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    separator = {
      fg = { attribute = "bg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    separator_selected = {
      fg = { attribute = "fg", highlight = "Special" },
      bg = { attribute = "bg", highlight = "Normal" },
    },
    separator_visible = {
      fg = { attribute = "fg", highlight = "Normal" },
      bg = { attribute = "bg", highlight = "StatusLineNC" },
    },
  },
})

vim.keymap.set("n", "<leader><leader>", ":BufferLineCycleNext<CR>")
vim.keymap.set("n", "<leader>p", ":BufferLineCyclePrev<CR>")
vim.keymap.set("n", "<leader>d", ":bdelete<CR>")
