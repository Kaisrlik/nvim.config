local q = require'vim.treesitter.query'

local ns = vim.api.nvim_create_namespace "autorun-tests"
local group = vim.api.nvim_create_augroup("testrun__augroup", {clear = true})

local function i(value)
	print(vim.inspect(value))
end

local test_function_query_string = [[
(function_definition
	(function_declarator
		declarator:(identifier) @method (#contains? @method "%s") (#offset! @method)
	)
)
]]

local find_test_line = function(bufnr, name)
	local formatted = string.format(test_function_query_string, name)
	local query = vim.treesitter.parse_query('cpp', formatted)
	local parser = vim.treesitter.get_parser(bufnr, "cpp", {})
	local tree = parser:parse()[1]
	local root = tree:root()

	for _, captures, metadata in query:iter_matches(root, bufnr) do
-- 		i(metadata[1].range[1])
		return metadata[1].range[1]
	end

	return -1
end

local make_key = function(entry)
	assert(entry.Package, "Must have Package:" .. vim.inspect(entry))
	assert(entry.Test, "Must have Test:" .. vim.inspect(entry))
	return string.format("%s/%s", entry.Package, entry.Test)
end

local add_test = function(state, entry)
	state.tests[make_key(entry)] = {
		name = entry.Test,
		line = find_test_line(state.bufnr, entry.Test),
		output = {},
	}
end

local add_output = function(state, entry)
	assert(state.tests, vim.inspect(state))
	assert(entry.Output, "Must have Output:" .. vim.inspect(entry))
	state.tests[make_key(entry)].output = vim.trim(entry.Output)
end

local mark_success = function(state, entry)
	state.tests[make_key(entry)].success = entry.Action == "pass"
end

local attach_to_buffer = function(bufnr, pattern, compile, command)
	local state = {
		bufnr = bufnr,
		tests = {},
	}

	vim.api.nvim_buf_create_user_command(bufnr, "AutoRunTestsLineDiag", function()
		local line = vim.fn.line "." - 1
		for _,test in pairs(state.tests) do
			if test.line == line then
				vim.cmd("new")
				vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), 0, -1, false, {test.output})
			end
		end
	end,{})

	local append_data_to_new_buffer = function(_, data)
		if data and data[1] ~= "" then
			vim.cmd("new")
			vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), -1, -1, false, data)
		end
	end

	local evaluate_json = function(_, data)
		vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
		if not data then
			return
		end

		for _, line in ipairs(data) do
			if #line > 10 then
				-- for some reason prints adds some chars
				line = line:sub(1,-1)
				local decoded = vim.json.decode(line)
				if decoded.Action == "pass" or decoded.Action == "fail" then
					add_test(state, decoded)
					mark_success(state, decoded)

					local test = state.tests[make_key(decoded)]
					if test.line == -1 then
						return
					end
					if test.success then
						-- TODO: add own colors
						vim.api.nvim_buf_set_extmark(bufnr, ns, test.line, 0, { virt_text = {{"--passed", 'MoreMsg'}} })
					else
						vim.api.nvim_buf_set_extmark(bufnr, ns, test.line, 0, { virt_text = {{"--failed", 'DiagnosticError'}} })
						add_output(state, decoded)
					end
				else
					error("Failed to handle" .. vim.inspect(data))
				end
			end
		end
	end

	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = pattern,
		group = group,
		callback = function()
			-- compile code if argumet is presetn
			local jobid = vim.fn.jobstart(compile, {
				stdout_buffered = true,
				on_stderr = append_data_to_new_buffer,
			})

			if jobid < 0 then
				print("Unable to compile code")
				return
			end

			vim.fn.jobstart(command, {
				stdout_buffered = true,
				on_stdout = evaluate_json,
			})
		end,
	})
end

-- TODO: add disable
-- TODO: compile code acording to some configuration file
vim.api.nvim_create_user_command("AutoRunTestsToggle", function()
	attach_to_buffer(vim.api.nvim_get_current_buf(), "a.cpp", {"gcc", "a.cpp", "-o", "/tmp/bin"}, {"/tmp/bin"})
end,{})
