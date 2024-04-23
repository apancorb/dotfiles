return {
  'nvim-treesitter/nvim-treesitter',
  build = '<cmd>TSUpdate',
  opts = {
    sync_install = false,
    ensure_installed = { 'java' },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
  },
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
