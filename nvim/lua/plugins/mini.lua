return {
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects.
    require('mini.ai').setup { n_lines = 500 }

    -- Comment lines
    require('mini.comment').setup()

    -- Add/delete/replace surroundings
    require('mini.surround').setup()

    -- Insert automatic pairings
    require('mini.pairs').setup()

    -- Simple and easy statusline.
    local statusline = require('mini.statusline')
    -- Set use_icons to true if you have a Nerd Font.
    statusline.setup({ use_icons = vim.g.have_nerd_font })
    -- Cursor location to LINE:COLUMN.
    statusline.section_location = function()
      return '%2l:%-2v'
    end
  end,
}
