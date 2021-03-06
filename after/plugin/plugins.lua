-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- run :PackerCompile
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
use 'wbthomason/packer.nvim'
-- Using my own style
use {'catppuccin/nvim', as = 'catppuccin'}

--Markdown preview
use 'ellisonleao/glow.nvim'

--Language packs
use 'sheerun/vim-polyglot'

--Nvim motions
use 'phaazon/hop.nvim'

--LSP autocomplete
use 'hrsh7th/nvim-cmp'
use 'hrsh7th/cmp-nvim-lsp'
use 'hrsh7th/cmp-buffer'
use 'hrsh7th/cmp-path'
-- use 'L3MON4D3/LuaSnip'
use 'neovim/nvim-lspconfig'
use 'williamboman/nvim-lsp-installer'

--File browsing
use 'nvim-telescope/telescope-file-browser.nvim'

--Buffer navigation
use 'nvim-lualine/lualine.nvim'

--debugging
use 'mfussenegger/nvim-dap'
use 'leoluz/nvim-dap-go'
use 'rcarriga/nvim-dap-ui'
use 'theHamsta/nvim-dap-virtual-text'
use 'nvim-telescope/telescope-dap.nvim'

--Grammar checking because I can't english
use 'rhysd/vim-grammarous'

--Telescope Requirements
use 'nvim-lua/popup.nvim'
use 'nvim-lua/plenary.nvim'
use 'nvim-telescope/telescope.nvim'

--Telescope
use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

--git diff
use 'sindrets/diffview.nvim'

--magit
use 'TimUntersberger/neogit'

-- snippets
use 'quangnguyen30192/cmp-nvim-ultisnips'
-- If you want to enable filetype detection based on treesitter:
-- requires = { "nvim-treesitter/nvim-treesitter" },
use 'SirVer/ultisnips'
use 'honza/vim-snippets'

end)
