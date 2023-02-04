local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local status, packer = pcall(require, "packer")
if not status then
  return
end

return packer.startup(function(use)
  -- packer can manage itself
  use("wbthomason/packer.nvim")
  -- lua functions that many plugins use
  use("nvim-lua/plenary.nvim")
  -- preferred colorscheme
  use("Mofiqul/vscode.nvim")
  -- status line
  use("nvim-lualine/lualine.nvim")
  -- buffer line
  use("akinsho/nvim-bufferline.lua")
  -- file explorer
  use({
    "nvim-tree/nvim-tree.lua",
    requires = {
      "nvim-tree/nvim-web-devicons",
    },
  })
  -- fuzzy finder
  use({
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = {
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "nvim-telescope/telescope-file-browser.nvim" },
    },
  })
  -- undo tree
  use("mbbill/undotree")
  -- maximizes & restores current window
  use("szw/vim-maximizer")
  -- zenmode
  use("folke/zen-mode.nvim")
  -- move between vim windows and tmux panes fast
  use("christoomey/vim-tmux-navigator")
  -- save vim session
  use("tpope/vim-obsession")
  -- colorize
  use("norcalli/nvim-colorizer.lua")
  -- auto closing
  use("windwp/nvim-autopairs")
  use("windwp/nvim-ts-autotag")
  -- surround
  use("tpope/vim-surround")
  -- commenting
  use("tpope/vim-commentary")
  -- git signs
  use("lewis6991/gitsigns.nvim")
  -- git blame
  use("dinhhuy258/git.nvim")
  -- treesitter
  use(
    "nvim-treesitter/nvim-treesitter",
    { run = ":TSUpdate" }
  )
  -- lsp
  use({
    "VonHeikemen/lsp-zero.nvim",
    requires = {
      -- lsp Support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      -- autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      -- snippets
      { "L3MON4D3/LuaSnip" },
      { "rafamadriz/friendly-snippets" },
    }
  })

  -- Automatically set up your configuration after
  -- cloning packer.nvim
  if packer_bootstrap then
    packer.sync()
  end
end)
