local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Enable virtual text
vim.diagnostic.config({ virtual_text = true })

local on_attach = function(client, bufnr)

	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	-- leaving only what I actually use...
	buf_set_keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
	-- buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
	-- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

	buf_set_keymap("n", "<C-j>", "<cmd>Telescope lsp_document_symbols<CR>", opts)
	buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

	buf_set_keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
	-- buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	buf_set_keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
	-- buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	-- diagnostics
	buf_set_keymap("n", "<leader>dl", "<cmd>Telescope diagnostics<CR>", opts)
	buf_set_keymap("n", "<leader>dj", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "<leader>dk", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)

	buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "gca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	-- buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
	-- buf_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
	-- buf_set_keymap("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

	if client.server_capabilities.document_formatting then
		vim.cmd([[
			augroup formatting
				autocmd! * <buffer>
				autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()
				autocmd BufWritePre <buffer> lua OrganizeImports(1000)
			augroup END
		]])
	end

	-- Set autocommands conditional on server_capabilities
	if client.server_capabilities.document_highlight then
		vim.cmd([[
			augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
		]])
	end
end

-- c/c++ LSP server
local lspconfig = require('lspconfig')
lspconfig.ccls.setup {
	cmd = { "ccls" };
	filetypes = { "c", "cpp" };
	capabilities = capabilities,
	on_attach = on_attach,
	root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git", ".ccls");
	init_options = {
		highlight = {
			lsRanges = true;
		}
	};
}

local caps = vim.tbl_deep_extend(
	'force',
	vim.lsp.protocol.make_client_capabilities(),
	require('cmp_nvim_lsp').default_capabilities(),
	-- File watching is disabled by default for neovim.
	{ workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
);

local lsp_path = vim.env.NIL_PATH or 'nil'
lspconfig.nil_ls.setup {
	autostart = true,
	capabilities = caps,
	cmd = { lsp_path },
	settings = {
		['nil'] = {
			testSetting = 42,
			formatting = {
				command = { "nixpkgs-fmt" },
			},
		},
	},
}

lspconfig.rust_analyzer.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}

-- -- Configure LSP through rust-tools.nvim plugin.
-- -- rust-tools will configure and enable certain LSP features for us.
-- -- See https://github.com/simrat39/rust-tools.nvim#configuration
-- local opts = {
-- 	tools = {
-- 		runnables = {
-- 			use_telescope = true,
-- 		},
-- 		inlay_hints = {
-- 			auto = true,
-- 			show_parameter_hints = false,
-- 			parameter_hints_prefix = "",
-- 			other_hints_prefix = "",
-- 		},
-- 	},
-- 	-- all the opts to send to nvim-lspconfig
-- 	-- these override the defaults set by rust-tools.nvim
-- 	-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
-- 	server = {
-- 		-- on_attach is a callback called when the language server attachs to the buffer
-- 		on_attach = on_attach,
-- 		settings = {
-- -- 			-- to enable rust-analyzer settings visit:
-- -- 			-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
-- -- 			["rust-analyzer"] = {
-- -- 				-- enable clippy on save
-- -- 				checkOnSave = {
-- -- 					command = "clippy",
-- -- 				},
-- -- 			},
-- 		},
-- 	},
-- }
-- require("rust-tools").setup(opts)

-- ltex-ls grammer check
-- TODO: only when ltex-ls is loaded
local path = vim.fn.expand("$HOME/.vim/spell/en.utf-8.add")
local words = {}

for word in io.open(path, "r"):lines() do
	table.insert(words, word)
end

lspconfig.ltex.setup {
	on_attach = on_attach,
	filetypes = { "markdown", "text", "tex", "mail" },
	cmd = { "ltex-ls" },
	flags = { debounce_text_changes = 300 },
	settings = {
		ltex = {
			disabledRules = {
				['en-US'] = { 'PROFANITY' }
			},
			dictionary = {
				['en-US'] = words,
			},
		},
	},
}

-- organize imports
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-902680058
function OrganizeImports(timeoutms)
	local params = vim.lsp.util.make_range_params()
	params.context = { only = { "source.organizeImports" } }
	local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeoutms)
	for _, res in pairs(result or {}) do
		for _, r in pairs(res.result or {}) do
			if r.edit then
				vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
			else
				vim.lsp.buf.execute_command(r.command)
			end
		end
	end
end

-- Set up null-ls
local null_ls = require("null-ls")
null_ls.setup({
	capabilities = capabilities,
	debug = true,
	sources = {
		-- null_ls.builtins.formatting.clang_format,
		require("none-ls-shellcheck.diagnostics"),
		-- null_ls.builtins.completion.spell,
	},
})
