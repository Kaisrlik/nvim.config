require('nvim-treesitter.configs').setup{
	-- enable syntax highlighting
	highlight = { enable = true },
	-- ensure these language parsers are installed
	ensure_installed = {
		"yaml",
		"markdown",
		"bash",
		"lua",
		"vim",
		"dockerfile",
	},
	ignore_install = {
		"gitcommit",
	},
	-- auto install above language parsers
	auto_install = true,
}
