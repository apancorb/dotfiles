return {
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope-file-browser.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
			{
				'nvim-tree/nvim-web-devicons',
				enabled = vim.g.have_nerd_font
			},
		},
		keys = {
			{
				'<leader><leader>',
				function()
					local builtin = require('telescope.builtin')
					builtin.buffers()
				end,
			},
			{
				'<leader>f',
				function()
					local builtin = require('telescope.builtin')
					builtin.find_files({
						no_ignore = false,
						hidden = true,
					})
				end,
			},
			{
				'<leader>fg',
				function()
					local builtin = require('telescope.builtin')
					builtin.live_grep({
						additional_args = { '--hidden' },
					})
				end,
				desc =
				'Search for a string in your current working directory and get results live as you type, respects .gitignore',
			},
			{
				'<leader>fG',
				function()
					local builtin = require('telescope.builtin')
					builtin.grep_string()
				end,
				desc =
				'Search for a string in your current working directory and get results live as you type, respects .gitignore',
			},
			{
				'<leader>ft',
				function()
					local builtin = require('telescope.builtin')
					builtin.treesitter()
				end
			},
			{
				'<leader>fe',
				function()
					local telescope = require('telescope')
					telescope.extensions.file_browser.file_browser({
						path = '%:p:h',
						initial_mode = 'normal',
						respect_gitignore = false,
						hidden = true,
						grouped = true,
						previewer = true,
					})
				end
			},
			{
				'<leader>fc',
				function()
					local builtin = require('telescope.builtin')
					builtin.find_files({
						cwd = vim.fn.stdpath 'config'
					})
				end
			},
		},
		config = function(_, opts)
			local telescope = require('telescope')
			local actions = require('telescope.actions')

			opts.defaults = {
				initial_mode = 'normal',
				layout_config = { prompt_position = 'top' },
				sorting_strategy = 'ascending',
				mappings = {
					n = {
						['<leader><leader>'] = actions.select_default
					},
				},
			}
			opts.extensions = {
				file_browser = {
					hijack_netrw = true,
				},
			}

			telescope.setup(opts)
			require('telescope').load_extension('fzf')
			require('telescope').load_extension('file_browser')
		end,
	},
}
