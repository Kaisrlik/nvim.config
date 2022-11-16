-- Telescope Setup
local action_state = require('telescope.actions.state') -- runtime (Plugin) exists somewhere as lua/telescope/actions/state.lua
require('telescope').setup{
	defaults = {
		prompt_prefix = "$ ",
		mappings = {
			i = {
				["<c-a>"] = function() print(vim.inspect(action_state.get_selected_entry())) end
			}
		},
		vimgrep_arguments = {
			'ag',
			'--nocolor',
			'--noheading',
			'--filename',
			'--numbers',
			'--column',
			'--ignore-case',
			'--ignore-dir=build',
			'--ignore-dir=_b*',
			'--ignore-dir=.ccls*',
		},
	},
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

vim.keymap.set("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find sorting_strategy=ascending prompt_position=top<CR>")
vim.keymap.set("n", "<leader>lg", "<cmd>Telescope live_grep<CR>")
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<CR>", {buffer=0, noremap = true})
