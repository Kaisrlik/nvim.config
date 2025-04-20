return {
	-- Using my own style
	{'catppuccin/nvim', as = 'catppuccin'},

	--Markdown preview
	'ellisonleao/glow.nvim',

	--Language packs
	'sheerun/vim-polyglot',

	--LSP autocomplete
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'neovim/nvim-lspconfig',

	{'nvimtools/none-ls.nvim', dependencies = {"gbprod/none-ls-shellcheck.nvim"} },

	--Buffer navigation
	'nvim-lualine/lualine.nvim',
	
	--debugging
	{ "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
	-- show virtual text such as variables value via treesitter
	'theHamsta/nvim-dap-virtual-text',
	'nvim-telescope/telescope-dap.nvim',

	--Grammar checking because I can't english
	'rhysd/vim-grammarous',
	 -- Adds extra functionality over rust analyzer
	'simrat39/rust-tools.nvim',

	--Telescope Requirements
	'nvim-lua/popup.nvim',
	'nvim-lua/plenary.nvim',
	'nvim-telescope/telescope.nvim',

	--Telescope
	{'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

	--File browsing
	'nvim-telescope/telescope-file-browser.nvim',

-- 	--git diff
-- 	'sindrets/diffview.nvim',

	--git
	'tpope/vim-fugitive',

	-- snippets
	'quangnguyen30192/cmp-nvim-ultisnips',
	'SirVer/ultisnips',
	'honza/vim-snippets',

	-- If you want to enable filetype detection based on treesitter:
	({
		'nvim-treesitter/nvim-treesitter',
		build = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}),
	'nvim-treesitter/playground',

	-- presentation in vim
	'Kaisrlik/present.nvim',

	-- org mode
	'nvim-orgmode/orgmode',

}
