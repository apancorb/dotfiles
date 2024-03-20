return {
  {
    {
      'kdheepak/lazygit.nvim',
      cmd = {
        'LazyGit',
        'LazyGitConfig',
      },
      keys = {
        {
          '<leader>g',
          '<cmd>LazyGit<cr>',
        },
      },
      dependencies = {
        'nvim-lua/plenary.nvim',
      },
    },
  },
  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        blame = "<leader>G",
      },
    },
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
}
