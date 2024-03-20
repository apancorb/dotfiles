return {
  { 
    'Mofiqul/vscode.nvim',
    opts = {
      transparent = true,
      italic_comments = true,
      disable_nvimtree_bg = true,
    },
    init = function()
      vim.cmd.colorscheme 'vscode'
    end,
  },
}
