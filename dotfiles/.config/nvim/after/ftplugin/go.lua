vim.cmd('setlocal noexpandtab')

Config.now(function()
    Config.packadd('nvim-dap-go')
    require('dap-go').setup()
end)
