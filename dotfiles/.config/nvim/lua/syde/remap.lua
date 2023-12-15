vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local keymap = require("syde.keymap")
local map    = keymap.map
local nmap   = keymap.nmap
local vmap   = keymap.vmap
local xmap   = keymap.xmap
local tmap   = keymap.tmap

vim.keymap.set({ 'n', 'v' }, 's', '<Nop>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- COLEMAK Remaps
nmap("<C-w>m", "<C-w>h", "Go to the left window")
nmap("<C-w>n", "<C-w>j", "Go to the down window")
nmap("<C-w>e", "<C-w>k", "Go to the up window")
nmap("<C-w>i", "<C-w>l", "Go to the right window")

local COLEMAK = false
local function colemak_toggle()
    if not COLEMAK then
        vim.opt.langmap = "hm,je,kn,li,mh,ek,nj,il,HM,JE,KN,LI,MH,EK,NJ,IL"
        -- vim.opt.langmap = "jh,hk,kj"
        vim.opt.langremap = false
        map({ "n", "v" }, "gm", "^", "Goto first non-blank in line")
        map({ "n", "v" }, "gs", "0", "Goto line start")
        map({ "n", "v" }, "gl", "$", "Goto line end")

        map({ "n", "v" }, "x", "xhl", "Delete character under cursor") -- x messes up with langmap
        map({ "n", "v" }, "X", "Xhl", "Delete character before cursor") -- X messes up with langmap
        -- nmap("gi", vim.lsp.buf.implementation, "Goto Implementation")
        COLEMAK = true
    else
        vim.opt.langmap = ""
        map({ "n", "v" }, "gh", "^", "Goto first non-blank in line")
        map({ "n", "v" }, "gs", "0", "Goto line start")
        map({ "n", "v" }, "gl", "$", "Goto line end")
        -- nmap("gi", vim.lsp.buf.implementation, "Goto Implementation")
        COLEMAK = false
    end
end
colemak_toggle()

nmap("<leader><leader>q", function()
    colemak_toggle()
    print("COLEMAK", COLEMAK)
end, "Toggle COLEMAK")

nmap("U", "<C-r>", "redo")

-- vmap("K", ":m'<-2<CR>gv=gv", "Move selection up") -- using mini.move instead
-- vmap("J", ":m'>+1<CR>gv=gv", "Move selection down")

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
nmap("gF", "<cmd>:e <cfile><CR>", "Goto [F]ile (even if doesn't exist)")


nmap("<leader>x", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Search and replace in buffer")
tmap("<leader><Esc>", [[<C-\><C-n>]], "Exit terminal mode")

-- nmap("<leader><leader>h", vim.cmd.nohlsearch, "Clear [h]ighlights")

-- Toggle Quickfix
nmap("<leader>q", vim.cmd.cclose, "Close [q]uickfix list")
