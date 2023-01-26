-- Load custom treesitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Treesitter configuration
require('nvim-treesitter.configs').setup {
	-- If TS highlights are not enabled at all, or disabled via `disable` prop,
	-- highlighting will fallback to default Vim syntax highlighting
	highlight = {
		enable = true,
		-- Required for spellcheck, some LaTex highlights and
		-- code block highlights that do not have ts grammar
			additional_vim_regex_highlighting = {'org'},
		},
		ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
	org_agenda_files = {'~/TODO/*', '~/my-orgs/**/*'},
	org_default_notes_file = '~/TODO/notes.org',
	mappings = {
		global = {
			org_agenda = {'gA', '<Leader>oa'},
			org_capture = {'gC', '<Leader>oc'}
		},
		agenda = {
			org_agenda_later = 'n',
			org_agenda_earlier = 'p',
			org_agenda_goto_today = {'.', ' '}
		}
	}
})
