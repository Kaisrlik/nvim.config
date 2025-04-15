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
