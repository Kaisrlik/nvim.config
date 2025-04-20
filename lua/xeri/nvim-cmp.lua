-- completition plugin setup
local cmp = require('cmp')
local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["UltiSnips#Anon"](args.body)
		end,
	},
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
		['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<C-e>'] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
		-- Accept currently selected item. If none selected, `select` first item.
		-- Set `select` to `false` to only confirm explicitly selected items.
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		['<C-CR>'] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping( function(fallback) cmp_ultisnips_mappings.expand_or_jump_forwards(fallback) end, { "i", "s"}),
		["<S-Tab>"] = cmp.mapping( function(fallback) cmp_ultisnips_mappings.jump_backwards(fallback) end, { "i", "s"}),
	},
	-- add sources for autocompletition
	sources = cmp.config.sources({
			-- lsp
			{ name = 'nvim_lsp' },
			-- snippet
			{ name = "ultisnips" },
			-- current buffer
			{ name = 'buffer' },
			-- path
			{ name = 'path' },
			{ name = 'orgmode' },
		})
})
