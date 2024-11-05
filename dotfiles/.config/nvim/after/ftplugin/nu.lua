Load.now(function ()
    require('nu').setup()
end)
local opt = vim.opt_local
local tabwidth = 4
opt.shiftwidth = tabwidth
opt.tabstop = tabwidth
opt.softtabstop = tabwidth
opt.expandtab = true

