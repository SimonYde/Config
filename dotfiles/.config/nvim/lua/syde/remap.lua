
vim.g.mapleader = " "
vim.g.maplocalleader = " "


local function map(mode, keys, cmd, desc)
	vim.keymap.set(mode, keys, cmd, {desc = desc})
end

local function nmap(keys, cmd, desc) map("n", keys, cmd, desc) end
local function imap(keys, cmd, desc) map("i", keys, cmd, desc) end
local function vmap(keys, cmd, desc) map("v", keys, cmd, desc) end
local function xmap(keys, cmd, desc) map("x", keys, cmd, desc) end
local function tmap(keys, cmd, desc) map("t", keys, cmd, desc) end


map({"n","v"}, "gs","^", "Goto first non-blank in line")
map({"n","v"}, "gh","0", "Goto line start")
map({"n","v"}, "gl","$", "Goto line end")
nmap("U","<C-r>", "redo")

vmap("K", ":m'<-2<CR>gv=gv", "Move selection up")
vmap("J", ":m'>+1<CR>gv=gv", "Move selection down")

nmap("J","mzJ`z", "Join following line with current")
nmap("<C-d>", "<C-d>zz", "Move down half page")
nmap("<C-u>", "<C-u>zz", "Move up half page")
nmap("n", "nzzzv", "Move to next search match")
nmap("N", "Nzzzv", "Move to previous search match")

nmap("<A-r>","gwip")


-- yank to system clipboard
map({"n","v"}, "<leader>y", [["+y]], "yank to system clipboard")
nmap("<leader>Y", [["+Y]],"yank to system clipboard")

nmap("<leader>w", "<C-w>", "Window")

xmap("<leader>p", [["_dP]], "Paste without yanking")
nmap("<leader>d", [["_d]], "Delete without yanking")
vmap("<leader>d", [["_d]], "Delete without yanking")

-- LSP commands
nmap("<leader>=", vim.lsp.buf.format, "Format with LSP")
nmap("<leader>r", vim.lsp.buf.rename, "Rename")


local telescope = require('telescope.builtin')
nmap("<leader>?", function() telescope.keymaps() end, "Look up keymaps")
nmap("<leader>b", function() telescope.buffers() end, "Buffers" )
nmap("<leader>fc", function() telescope.current_buffer_fuzzy_find() end, "Current buffer search")
nmap("<leader>ff", function() telescope.find_files() end, "Files" )
nmap("<leader>F", function() telescope.git_files() end, "Git files")
nmap("<leader>fh", function() telescope.help_tags() end, "Help tags")
nmap("<leader>fs", function() telescope.live_grep() end, "Search with grep")
nmap("<A-f>", "<cmd>NvimTreeToggle<cr>", "Toggle file tree")

local whichkey = require('which-key')
whichkey.setup{}
whichkey.register(
    {
        ["<leader>"] = {
            f = {
                name = "Find (telescope)",
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
local presets = require("which-key.plugins.presets")
presets.operators["v"] = nil

-- nmap("<C-k>", "<cmd>cnext<CR>zz")
-- nmap("<C-j>", "<cmd>cprev<CR>zz")
-- nmap("<leader>k", "<cmd>lnext<CR>zz")
-- nmap("<leader>j", "<cmd>lprev<CR>zz")

nmap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>","Search and replace in buffer")
tmap("<leader><Esc>","<C-\\><C-n>","Exit terminal mode")


require('Comment').setup()


-- fugitive
nmap("<leader>gs", vim.cmd.Git, "Git fugitive")


