vim.o.wrap = true
vim.g.typst_pdf_viewer = "zathura" -- NOTE: Only works with `typst.vim` and `zathura` installed

local bo = vim.bo
local tabwidth = 2
bo.shiftwidth = tabwidth
bo.tabstop = tabwidth
bo.softtabstop = tabwidth
bo.expandtab = true
