local o = vim.opt_local
local tabwidth = 4
o.shiftwidth = tabwidth
o.tabstop = tabwidth
o.softtabstop = tabwidth
o.expandtab = true
Load.now(function ()
    o.indentexpr = require('nvim-treesitter').indentexpr()
end)
