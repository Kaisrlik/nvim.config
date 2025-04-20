local has_dap, dap = pcall(require, "dap")
if not has_dap then
  return
end
local dap_ui = require "dapui"

vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})
vim.fn.sign_define("DapBreakpointCondition", {text='C', texthl='', linehl='', numhl='' })
vim.fn.sign_define("DapStopped", {text='🟢', texthl='' })

require("nvim-dap-virtual-text").setup {
  enabled = true,

  -- DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, DapVirtualTextForceRefresh
  enabled_commands = false,

  -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_changed_variables = true,
  highlight_new_as_changed = true,

  -- prefix virtual text with comment string
  commented = false,
  show_stop_reason = true,

  -- experimental features:
  virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
}

-- -- apt install lldb
-- dap.adapters.lldb = {
-- 	name = "lldb",
-- 	type = "executable",
-- 	attach = {
-- 		pidProperty = "pid",
-- 		pidSelect = "ask",
-- 	},
-- 	command = "lldb-vscode-14",
-- 	env = {
-- 		LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
-- 	}
-- }

-- TODO: test it
dap.adapters.lldbsrv = {
	type = 'server';
	host = '127.0.0.1';
	port = 1234;
	enrich_config = function(config, on_config)
		local final_config = vim.deepcopy(config)
		final_config.extra_property = 'This got injected by the adapter'
		on_config(final_config)
	end;
}

dap.configurations.c = {
	{
		-- If you get an "Operation not permitted" error using this, try disabling YAMA:
		--  echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
		-- Careful, don't try to attach to the neovim instance that runs *this*
		name = "Fancy attach",
		type = "c",
		request = "attach",
		pid = function()
			local output = vim.fn.system { "ps", "a" }
			local lines = vim.split(output, "\n")
			local procs = {}
			for _, line in pairs(lines) do
				-- output format
				--    " 107021 pts/4    Ss     0:00 /bin/zsh <args>"
				local parts = vim.fn.split(vim.fn.trim(line), " \\+")
				local pid = parts[1]
				local name = table.concat({ unpack(parts, 5) }, " ")
				if pid and pid ~= "PID" then
					pid = tonumber(pid)
					if pid ~= vim.fn.getpid() then
						table.insert(procs, { pid = pid, name = name })
					end
				end
			end
			local choices = { "Select process" }
			for i, proc in ipairs(procs) do
				table.insert(choices, string.format("%d: pid=%d name=%s", i, proc.pid, proc.name))
			end
			-- Would be cool to have a fancier selection, but needs to be sync :/
			-- Should nvim-dap handle coroutine results?
			local choice = vim.fn.inputlist(choices)
			if choice < 1 or choice > #procs then
				return nil
			end
			return procs[choice].pid
		end,
		args = {},
	},
	{
		name = "Start $DAPBIN - set by `export DAPBIN`",
		type = "lldb",
		request = "launch",
		program = "./${env:DAPBIN}",
-- 		program = function()
-- 			local a = vim.fn.input('Path to executable: ', '/tmp/', 'file')
-- 		end,
		args = { },
		cwd = "${workspaceFolder}",
		stopOnEntry = true,
		runInTerminal = false,
		MIMode = 'gdb',
	},
	{
		name = "Attach to gdbserver :1234",
		type = "lldbsrv",
		request = "launch",
		program = "/tmp/a",
		cwd = '${workspaceFolder}',
		stopAtEntry = true,
	},
}

dap.configurations.cpp = dap.configurations.c
dap.configurations.rust = dap.configurations.c

local map = function(lhs, rhs, desc)
  if desc then
    desc = "[DAP] " .. desc
  end

  vim.keymap.set("n", lhs, rhs, { silent = true, desc = desc })
end

-- You can set trigger characters OR it will default to '.'
-- You can also trigger with the omnifunc, <c-x><c-o>
vim.cmd [[
augroup DapRepl
  au!
  au FileType dap-repl lua require('dap.ext.autocompl').attach()
augroup END
]]

map("<leader>dB", function()
	require("dap").set_breakpoint(vim.fn.input "[DAP] Condition > ")
end)
map("<leader>de", require("dapui").eval)
map("<leader>dE", function()
	require("dapui").eval(vim.fn.input "[DAP] Expression > ")
end)

-- moves
map("<C-1>", require("dap").step_back, "step_back")
map("<C-2>", require("dap").step_into, "step_into")
map("<C-3>", require("dap").step_over, "step_over")
map("<C-n>", require("dap").step_over, "step_over")
map("<C-4>", require("dap").step_out, "step_out")
-- this is also used for starting DAP
map("<C-5>", require("dap").continue, "continue")
map("<leader>ds", require("dap").continue, "continue")
-- breakpoints
map("<C-6>", require("dap").toggle_breakpoint)
map("<leader>db", require("dap").toggle_breakpoint)
map("<C-?>", function() require("dap").eval(nil, {enter = true}) end, "eval under cursor")

local _ = dap_ui.setup {
	layouts = {
		{
			elements = {
				"scopes",
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 10,
			position = "bottom",
		},
	},
  -- -- You can change the order of elements in the sidebar
  -- sidebar = {
  --   elements = {
  --     -- Provide as ID strings or tables with "id" and "size" keys
  --     {
  --       id = "scopes",
  --       size = 0.75, -- Can be float or integer > 1
  --     },
  --     { id = "watches", size = 00.25 },
  --   },
  --   size = 50,
  --   position = "left", -- Can be "left" or "right"
  -- },
  --
  -- tray = {
  --   elements = {},
  --   size = 15,
  --   position = "bottom", -- Can be "bottom" or "top"
  -- },
}

dap.listeners.after.event_initialized["dapui_config"] = function()
	dap_ui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
	dap_ui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
	dap_ui.close()
end
