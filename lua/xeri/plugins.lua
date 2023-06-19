-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	-- Using my own style
	use {'catppuccin/nvim', as = 'catppuccin'}

	--Markdown preview
	use 'ellisonleao/glow.nvim'

	--Language packs
	use 'sheerun/vim-polyglot'

	--LSP autocomplete
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-path'
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'

	use "jose-elias-alvarez/null-ls.nvim"

	--Buffer navigation
	use 'nvim-lualine/lualine.nvim'
	
	--debugging
	use 'mfussenegger/nvim-dap'
	use 'rcarriga/nvim-dap-ui'
	-- show virtual text such as variables value via treesitter
	use 'theHamsta/nvim-dap-virtual-text'
	use 'nvim-telescope/telescope-dap.nvim'

	--Grammar checking because I can't english
	use 'rhysd/vim-grammarous'
	 -- Adds extra functionality over rust analyzer
	use("simrat39/rust-tools.nvim")

	--Telescope Requirements
	use 'nvim-lua/popup.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'nvim-telescope/telescope.nvim'

	--Telescope
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	--File browsing
	use 'nvim-telescope/telescope-file-browser.nvim'

	--git diff
	use 'sindrets/diffview.nvim'

	--git
	use 'tpope/vim-fugitive'

	-- snippets
	use 'quangnguyen30192/cmp-nvim-ultisnips'
	use 'SirVer/ultisnips'
	use 'honza/vim-snippets'

	-- If you want to enable filetype detection based on treesitter:
	use({
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	})
	use 'nvim-treesitter/playground'

	-- presentation in vim
	use 'sotte/presenting.vim'

	-- org mode
	use({
		'nvim-orgmode/orgmode',
		config = function ()
			require('orgmode').setup_ts_grammar()
		end,
	})

	-- automatically set up your configuration after cloning packer.nvim
	-- put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end

end)
