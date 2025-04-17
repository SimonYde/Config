vim.cmd('setlocal noexpandtab')

Load.now(function() require('dap-go').setup() end)
