vim.cmd('setlocal noexpandtab')

Load.now(function()
    Load.packadd('nvim-dap-go')
    require('dap-go').setup()
end)
