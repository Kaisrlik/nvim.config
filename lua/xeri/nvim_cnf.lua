-- additional settings based
vim.opt.autoread = true
vim.opt.foldlevelstart = 99
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.g.glow_binary_path = vim.env.HOME .. "/bin"
vim.g.glow_use_pager = true
vim.g.glow_border = "shadow"
vim.keymap.set("n", "<leader>p", "<cmd>Glow<cr>")

