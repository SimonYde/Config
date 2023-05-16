
vim.g.mapleader = " "
vim.g.maplocalleader = " "


local function map(mode, keys, cmd)
	vim.keymap.set(mode, keys, cmd, options)
end

local function nmap(keys, cmd)
  map("n", keys, cmd)
end

local function imap(keys, cmd)
  map("i", keys, cmd)
end

local function vmap(keys, cmd)
	map("v", keys, cmd)
end

local function xmap(keys, cmd)
  map("x", keys, cmd)
end

local function tmap(keys, cmd)
  map("t", keys, cmd)
end

nmap("gh","^")
vmap("gh","^")
nmap("gl","$")
vmap("gl","$")
nmap("U","<C-r>")

nmap("<leader>pv", "<cmd>Ex<CR>")
vmap("K", ":m'<-2<CR>gv=gv")
vmap("J", ":m'>+1<CR>gv=gv")

nmap("J","mzJ`z")
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- paste without loosing yank buffer
xmap("<leader>p", [["_dP]])
 
-- yank to system clipboard
nmap("<leader>y", [["+y]])
vmap("<leader>y", [["+y]])
nmap("<leader>Y", [["+Y]])


nmap("<leader>d", [["_d]]) 
vmap("<leader>d", [["_d]]) 

-- LSP commands
nmap("<leader>f",vim.lsp.buf.format)
nmap("<leader>a",vim.lsp.buf.code_action)
nmap("gd",vim.lsp.buf.definition)
nmap("gD",vim.lsp.buf.declaration)
nmap("gr",vim.lsp.buf.references)
nmap("gi",vim.lsp.buf.implementation)
nmap("<leader>k", vim.lsp.buf.hover)


--nmap("<C-k>", "<cmd>cnext<CR>zz")
--nmap("<C-j>", "<cmd>cprev<CR>zz")
--nmap("<leader>k", "<cmd>lnext<CR>zz")
--nmap("<leader>j", "<cmd>lprev<CR>zz")

nmap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
tmap("<leader><Esc>","<C-\\><C-n>")

-- telescope
local builtin = require('telescope.builtin')
nmap("<leader>ff", builtin.find_files)
nmap("<leader>fg", builtin.live_grep)
nmap("<leader>fb", builtin.buffers)
nmap("<leader>fh", builtin.help_tags)
nmap("<C-p>", builtin.git_files)
--nmap("<leader>ps", function()
--  builtin.grep_string({ search = vim.fn.input("Grep > ") })
--end)
-- neo-tree
-- vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
nmap("<C-f>", "<cmd>NeoTreeFloatToggle<cr>")
nmap("<C-c>","<cmd>Commentary<cr>")
-- undotree
nmap("<leader>u", vim.cmd.UndotreeToggle)

-- fugitive
nmap("<leader>gs", vim.cmd.Git)
--


