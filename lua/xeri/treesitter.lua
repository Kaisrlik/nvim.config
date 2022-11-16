-- cargo install tree-sitter
-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
  return
end

treesitter.setup({
	ensure_installed = "all",
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
	-- auto install above language parsers
	auto_install = true,
})
