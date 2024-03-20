return {
  {
    'tpope/vim-commentary'
  },
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects.
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc).
      require('mini.surround').setup()

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      -- Set use_icons to true if you have a Nerd Font.
      statusline.setup { use_icons = vim.g.have_nerd_font }
      -- Cursor location to LINE:COLUMN.
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
