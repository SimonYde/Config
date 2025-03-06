vim.cmd('setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab')
Load.now(function() vim.opt_local.indentexpr = require('nvim-treesitter').indentexpr() end)
