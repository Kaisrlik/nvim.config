local lazy_path = vim.fn.stdpath("data") .. "/site/pack/lazy/start/lazy.nvim"

-- auto install lazy if not installed
if not vim.loop.fs_stat(lazy_path) then
	vim.fn.system({
		"git",
		"clone",
		"--depth", "1",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazy_path
	})
end
vim.opt.rtp:prepend(lazy_path)

require('lazy').setup({
	spec = { { import = 'plugins' }, },
	rocks = { enabled = false },
})
