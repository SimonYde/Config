vim.g.mapleader      = " "
vim.g.maplocalleader = " "
-- vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

local keymap = require("syde.keymap")
local map    = keymap.map
local nmap   = keymap.nmap
local vmap   = keymap.vmap
local xmap   = keymap.xmap
local tmap   = keymap.tmap


-- COLEMAK Remaps
nmap("<C-w>m", "<C-w>h", "Go to the left window")
nmap("<C-w>n", "<C-w>k", "Go to the down window")
nmap("<C-w>e", "<C-w>j", "Go to the up window")
nmap("<C-w>i", "<C-w>l", "Go to the right window")

COLEMAK = false
local function colemak_toggle()
  if not COLEMAK then
    vim.opt.langmap = "hm,je,kn,li,mh,ek,nj,il,HM,JE,KN,LI,MH,EK,NJ,IL"
    -- vim.opt.langmap = "jh,hk,kj"
    vim.opt.langremap = false
    map({ "n", "v" }, "gs", "^", "Goto first non-blank in line")
    map({ "n", "v" }, "gm", "0", "Goto line start")
    map({ "n", "v" }, "gi", "$", "Goto line end")
    nmap("gl", vim.lsp.buf.implementation, "Goto Implementation")
    COLEMAK = true
  else
    vim.opt.langmap = ""
    map({ "n", "v" }, "gs", "^", "Goto first non-blank in line")
    map({ "n", "v" }, "gh", "0", "Goto line start")
    map({ "n", "v" }, "gl", "$", "Goto line end")
    nmap("gi", vim.lsp.buf.implementation, "Goto Implementation")
    COLEMAK = false
  end
end
colemak_toggle()

nmap("<leader><leader>q", colemak_toggle, "Toggle COLEMAK")

nmap("U", "<C-r>", "redo")

vmap("K", ":m'<-2<CR>gv=gv", "Move selection up")
vmap("J", ":m'>+1<CR>gv=gv", "Move selection down")

nmap("J", "mzJ`z", "Join following line with current")
nmap("<C-d>", "<C-d>zz", "Move down half page")
nmap("<C-u>", "<C-u>zz", "Move up half page")
nmap("n", "nzzzv", "Move to next search match")
nmap("N", "Nzzzv", "Move to previous search match")

map({ "n", "v" }, "<leader>y", [["+y]], "yank to system clipboard")
nmap("<leader>Y", [["+Y]], "yank to system clipboard")

nmap("<leader>w", "<C-w>", "Window")

xmap("<leader>p", [["_dP]], "Paste without yanking")
nmap("<leader>d", [["_d]], "Delete without yanking")
vmap("<leader>d", [["_d]], "Delete without yanking")

-- LSP commands
nmap("<leader>=", vim.lsp.buf.format, "Format with LSP")
nmap("<leader>r", vim.lsp.buf.rename, "Rename")
nmap("<leader>k", vim.lsp.buf.hover, "hover documentation")
nmap("<leader>a", vim.lsp.buf.code_action, "code actions")
nmap("<leader>d", vim.diagnostic.open_float, "hover [d]iagnostics")
nmap("gd", vim.lsp.buf.definition, "Goto Definition")
nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
nmap("gr", vim.lsp.buf.references, "Goto References")


nmap("<leader>x", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Search and replace in buffer")
tmap("<leader><Esc>", [[<C-\><C-n>]], "Exit terminal mode")

nmap("<leader><leader>h", vim.cmd.nohlsearch, "Clear [h]ighlights")

-- Close quickfix list

nmap("<leader>q", vim.cmd.cclose, "Close [q]uickfix list")
