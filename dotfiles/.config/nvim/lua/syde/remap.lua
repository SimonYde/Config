
vim.g.mapleader = " "
vim.g.maplocalleader = " "


local function map(mode, keys, cmd, desc)
	vim.keymap.set(mode, keys, cmd, {desc = desc})
end

local function nmap(keys, cmd, desc)
  map("n", keys, cmd, desc)
end

local function imap(keys, cmd, desc)
  map("i", keys, cmd, desc)
end

local function vmap(keys, cmd, desc)
	map("v", keys, cmd, desc)
end

local function xmap(keys, cmd, desc)
  map("x", keys, cmd, desc)
end

local function tmap(keys, cmd, desc)
  map("t", keys, cmd, desc)
end

nmap("gh","^", "Goto beginning of line")
vmap("gh","^", "Goto beginning of line")
nmap("gl","$","Goto end of line")
vmap("gl","$","Goto end of line")
nmap("U","<C-r>", "redo")

nmap("<leader>pv", "<cmd>Ex<CR>", "Open NetRW")
vmap("K", ":m'<-2<CR>gv=gv", "Move selection up")
vmap("J", ":m'>+1<CR>gv=gv", "Move selection down")

nmap("J","mzJ`z", "Join following line with current")
nmap("<C-d>", "<C-d>zz", "Move down half page")
nmap("<C-u>", "<C-u>zz", "Move up half page")
nmap("n", "nzzzv", "Move to next search match")
nmap("N", "Nzzzv", "Move to previous search match")

 
-- yank to system clipboard
nmap("<leader>y", [["+y]],"yank to system clipboard")
vmap("<leader>y", [["+y]],"yank to system clipboard")
nmap("<leader>Y", [["+Y]],"yank to system clipboard")


xmap("<leader>p", [["_dP]], "Paste without yanking")
nmap("<leader>d", [["_d]], "Delete without yanking") 
vmap("<leader>d", [["_d]], "Delete without yanking") 

-- LSP commands
nmap("<leader>f",vim.lsp.buf.format, "Format with LSP")

local whichkey = require('which-key')
whichkey.setup{}

local telescope = require('telescope.builtin')
whichkey.register(
  {
  ["<leader>"] = {
    f = {
      name = "Find (telescope)",
      f = { function() telescope.find_files() end, "Fuzzy finder" },
      s = { function() telescope.live_grep() end, "Search with grep"},
      b = { function() telescope.buffers() end, "Buffers" },
      h = { function() telescope.help_tags() end, "Help tags" },
      g = { function() telescope.git_files() end, "Git files"}
    },
    u = { function() vim.cmd.UndotreeToggle() end, "Undotree" },
    k = { "<cmd>Lspsaga hover_doc<cr>", "hover documentation" },
    a = { "<cmd>Lspsaga code_action<cr>", "code actions"},
  },
  ["g"] = { 
    d = { function() vim.lsp.buf.definition() end, "Goto Definition" },
    D = { function() vim.lsp.buf.declaration() end, "Goto Declaration"},
    r = { function() vim.lsp.buf.references() end, "Goto References"},
    i = { function() vim.lsp.buf.implementation() end, "Goto Implementation"},
  },
})

-- nmap("<C-k>", "<cmd>cnext<CR>zz")
-- nmap("<C-j>", "<cmd>cprev<CR>zz")
-- nmap("<leader>k", "<cmd>lnext<CR>zz")
-- nmap("<leader>j", "<cmd>lprev<CR>zz")

nmap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>","Search and replace in buffer")
tmap("<leader><Esc>","<C-\\><C-n>","Exit terminal mode")

-- neo-tree
nmap("<A-f>", "<cmd>NeoTreeFloatToggle<cr>","Toggle Neo-tree")
nmap("<C-c>","<cmd>Commentary<cr>", "Toggle comment current line")


-- fugitive
nmap("<leader>gs", vim.cmd.Git, "Git fugitive")


