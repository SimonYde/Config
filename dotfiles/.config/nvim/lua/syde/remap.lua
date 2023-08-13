vim.g.mapleader = " "
vim.g.maplocalleader = " "


local function map(mode, keys, cmd, desc)
  vim.keymap.set(mode, keys, cmd, { desc = desc })
end

local function nmap(keys, cmd, desc) map("n", keys, cmd, desc) end
local function imap(keys, cmd, desc) map("i", keys, cmd, desc) end
local function vmap(keys, cmd, desc) map("v", keys, cmd, desc) end
local function xmap(keys, cmd, desc) map("x", keys, cmd, desc) end
local function tmap(keys, cmd, desc) map("t", keys, cmd, desc) end

if os.getenv("COLEMAK") then
  vim.opt.langmap = "hm,je,kn,li,mh,ek,nj,il,HM,JE,KN,LI,MH,EK,NJ,IL"
  vim.opt.langremap = false
  nmap("<C-w>m", "<C-w>h", "Go to the left window")
  nmap("<C-w>n", "<C-w>j", "Go to the down window")
  nmap("<C-w>e", "<C-w>k", "Go to the up window")
  nmap("<C-w>i", "<C-w>l", "Go to the right window")
  -- vim.opt.langmap = "jh,hj"
  -- vim.opt.langremap = true
end

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

map({ "n", "v" }, "gs", "^", "Goto first non-blank in line")
map({ "n", "v" }, "gh", "0", "Goto line start")
map({ "n", "v" }, "gl", "$", "Goto line end")
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


local telescope = require('telescope.builtin')
nmap("<leader>?", telescope.keymaps, "Look up keymaps")
nmap("<leader>b", telescope.buffers, "Buffers")
nmap("<leader>fc", telescope.current_buffer_fuzzy_find, "Current buffer search")
nmap("<leader>ff", telescope.find_files, "Files")
nmap("<leader>F", telescope.git_files, "Git files")
nmap("<leader>fh", telescope.help_tags, "Help tags")
nmap("<leader>fs", telescope.live_grep, "Search with grep")
nmap("<A-f>", "<cmd>NvimTreeToggle<cr>", "Toggle file tree")

local whichkey = require('which-key')
whichkey.setup {}
whichkey.register({
  ["<leader>"] = {
    f = {
      name = "Find (telescope)",
    },
    u = { vim.cmd.UndotreeToggle, "Undotree" },
    -- k = { "<cmd>Lspsaga hover_doc<cr>", "hover documentation" },
    k = { function() vim.lsp.buf.hover() end, "code actions" },
    a = { "<cmd>Lspsaga code_action<cr>", "code actions" },
  },
  ["g"] = {
    d = { function() vim.lsp.buf.definition() end, "Goto Definition" },
    D = { function() vim.lsp.buf.declaration() end, "Goto Declaration" },
    -- r = { function() vim.lsp.buf.references() end, "Goto References"},
    r = { function() telescope.lsp_references() end, "Goto References" },
    -- i = { function() vim.lsp.buf.implementation() end, "Goto Implementation" },
    i = { function() telescope.lsp_implementations() end, "Goto Implementations" },
  },
  ["["] = {
    d = { function() vim.diagnostic.goto_prev() end, "Goto previous diagnostic" },
  },
  ["]"] = {
    d = { function() vim.diagnostic.goto_next() end, "Goto next diagnostic" },
  },
})
local presets = require("which-key.plugins.presets")
presets.operators["v"] = nil

-- nmap("<C-k>", "<cmd>cnext<CR>zz")
-- nmap("<C-j>", "<cmd>cprev<CR>zz")
-- nmap("<leader>k", "<cmd>lnext<CR>zz")
-- nmap("<leader>j", "<cmd>lprev<CR>zz")

nmap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", "Search and replace in buffer")
tmap("<leader><Esc>", "<C-\\><C-n>", "Exit terminal mode")


require('Comment').setup()


-- fugitive
nmap("<leader>gs", vim.cmd.Git, "Git fugitive")


