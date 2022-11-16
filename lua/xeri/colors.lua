-- Aesthetic
-- pcall catches errors if the plugin doesn't load
local ok, catppuccin = pcall(require, "catppuccin")
if not ok then return end

catppuccin.setup {}
-- vim.cmd[[colorscheme catppuccin]]
-- lualine
require('lualine').setup{
	options = {
		theme = 'catppuccin'
	}
}
-- use catppuchin as a base and overwrite it with my colorscheme
vim.cmd[[colorscheme dark]]
