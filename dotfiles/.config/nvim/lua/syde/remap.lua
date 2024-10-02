vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set({ 'n', 'v', 'x' }, 's', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v', 'x' }, '<Space>', '<Nop>', { silent = true })

local keymap = require("syde.keymap")
local nmap   = keymap.nmap
local xmap   = keymap.xmap
local tmap   = keymap.tmap
local nvmap  = keymap.map({ "n", "v" })
local nxmap  = keymap.map({ 'n', 'x' })

nmap("U", "<C-r>", "redo")

-- vmap("<M-k>", ":m'<-2<CR>gv=gv", "Move selection up") -- using mini.move instead
-- vmap("<M-j>", ":m'>+1<CR>gv=gv", "Move selection down")

-- vim.keymap.del("n", "grr")
-- vim.keymap.del("n", "gra")
-- vim.keymap.del("x", "gra")
-- vim.keymap.del("n", "grn")

nmap("J", "mzJ`z", "Join following line with current")
nmap("<C-d>", "<C-d>zz", "Move down half page")
nmap("<C-u>", "<C-u>zz", "Move up half page")
nmap("n", "nzz", "Move to next search match")
nmap("N", "Nzz", "Move to previous search match")

nvmap("<leader>y", [["+y]], "yank to system clipboard")
nmap("<leader>Y", [["+Y]], "yank end-of-line to system clipboard")

nmap("<leader>w", "<C-w>", "Window")

xmap("<leader>p", [["_dP]], "[p]aste without yanking")
nvmap("<M-d>", [["_d]], "[d]elete without yanking")
nvmap("<M-c>", [["_c]], "[c]hange without yanking")

nmap("gF", "<cmd>:e <cfile><CR>", "Goto [F]ile (even if doesn't exist)")


nmap("<leader>x", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Search and replace in buffer")
tmap("<leader><Esc>", [[<C-\><C-n>]], "Exit terminal mode")

vim.lsp.inlay_hint.toggle = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end
nmap("<leader>li", vim.lsp.inlay_hint.toggle, "Toggle [i]nlay hints")
nmap("<leader>lf", vim.lsp.buf.format, "LSP format")

nmap("<leader>q", vim.cmd.cclose, "Close [q]uickfix list")
nmap("<leader>=", vim.lsp.buf.format, "Format with LSP")
nmap("gd", vim.lsp.buf.definition, "Goto [d]efinition")
nmap("gD", vim.lsp.buf.declaration, "Goto [D]eclaration")
nmap("gr", vim.lsp.buf.references, "Goto [r]eferences")

-- COLEMAK Remaps
-- NOTE: is reversed because the function below toggles the value, in order to
-- enable appropriate options.
COLEMAK        = false
Colemak_toggle = function()
    if not COLEMAK then
        -- vim.opt.langmap = "hm,je,kn,li,mh,ek,nj,il,HM,JE,KN,LI,MH,EK,NJ,IL"
        -- vim.opt.langremap = false
        vim.opt.langmap = ""
        -- nvmap("x", "x<Esc>", "Delete character under cursor")  -- x messes up with langmap
        -- nvmap("X", "X<Esc>", "Delete character before cursor") -- X messes up with langmap

        nxmap('n', [[v:count == 0 ? 'gj' : 'j']], "", { expr = true, noremap = true })
        nxmap('e', [[v:count == 0 ? 'gk' : 'k']], "", { expr = true, noremap = true })
        nvmap("m", "h", "", { noremap = true })
        nmap("i", "l", "", { noremap = true })
        nvmap("I", "L", "", { noremap = true })
        nvmap("h", "m", "", { noremap = true })
        nvmap("j", "e", "", { noremap = true })
        nvmap("k", "nzz", "", { noremap = true })
        nmap("l", "i", "", { noremap = true })
        nvmap("M", "H", "", { noremap = true })
        nvmap("N", "J", "", { noremap = true })
        nvmap("E", "K", "", { noremap = true })
        nvmap("H", "M", "", { noremap = true })
        nvmap("J", "E", "", { noremap = true })
        nvmap("K", "Nzz", "", { noremap = true })
        nvmap("L", "I", "", { noremap = true })
        nmap("<C-w>m", "<C-w>h", "", { noremap = true })
        nmap("<C-w>n", "<C-w>j", "", { noremap = true })
        nmap("<C-w>e", "<C-w>k", "", { noremap = true })
        nmap("<C-w>i", "<C-w>l", "", { noremap = true })
        nmap("<C-w>M", "<C-w>H", "", { noremap = true })
        nmap("<C-w>N", "<C-w>J", "", { noremap = true })
        nmap("<C-w>E", "<C-w>K", "", { noremap = true })
        nmap("<C-w>I", "<C-w>L", "", { noremap = true })

        nvmap("M", "^", "Goto first non-empty cell in line")
        nvmap("S", "0", "Goto line start")
        nvmap("I", "$", "Goto line end")
        COLEMAK = true
    else
        COLEMAK = false
    end
end
Colemak_toggle()

nmap("<leader><leader>q", function()
    Colemak_toggle()
    print("COLEMAK", COLEMAK)
end, "Toggle COLEMAK")
