local status, vscode = pcall(require, "vscode")
if not status then
  return
end

vscode.setup({
    transparent = true,
    italic_comments = true,
    disable_nvimtree_bg = true,
})

vim.cmd("colorscheme vscode")
