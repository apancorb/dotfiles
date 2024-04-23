-- Install `lazy.nvim` plugin manager.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins.
require('lazy').setup({
  -- Minimal plugins.
  require 'plugins/mini',
  -- Preffered colorscheme.
  require 'plugins/colorscheme',
  -- Undo tree.
  require 'plugins/undotree',
  -- Version control.
  require 'plugins/git',
  -- Tmux navigation.
  require 'plugins/tmux',
  -- Fuzzy finder.
  require 'plugins/telescope',
  -- Highlight code.
  require 'plugins/treesitter',
  -- Completion Configuration.
  require 'plugins/cmp',
  -- LSP Configuration.
  require 'plugins/lsp',
  -- Debugger Configuration.
  require 'plugins/debug',
}, {})
