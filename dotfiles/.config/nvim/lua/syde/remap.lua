
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

nmap("gh","_")
vmap("gh","_")
nmap("gl","$")
vmap("gl","$")

nmap("<leader>pv", "<cmd>Ex<CR>")

nmap("J","mzJ`z")
nmap("<C-d>", "<C-d>zz")
nmap("<C-u>", "<C-u>zz")
nmap("n", "nzzzv")
nmap("N", "Nzzzv")

-- paste without loosing yank buffer
xmap("<leader>p", "\"_dP")
 
-- yank to system clipboard
nmap("<leader>y", "\"+y")
vmap("<leader>y", "\"+y")
nmap("<leader>Y", "\"+Y")


nmap("<leader>d", "\"_d") 
vmap("<leader>d", "\"_d") 

nmap("<leader>f", function() vim.lsp.buf.format() end)

nmap("<C-k>", "<cmd>cnext<CR>zz")
nmap("<C-j>", "<cmd>cprev<CR>zz")
nmap("<leader>k", "<cmd>lnext<CR>zz")
nmap("<leader>j", "<cmd>lprev<CR>zz")

nmap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

map("t", "<Esc>","<C-\\><C-n>")

-- telescope
local builtin = require('telescope.builtin')
nmap("<leader>ff", builtin.find_files)
nmap("<leader>fg", builtin.live_grep)
nmap("<leader>fb", builtin.buffers)
nmap("<leader>fh", builtin.help_tags)
nmap("<C-p>", builtin.git_files)
nmap("<leader>ps", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- undotree
nmap("<leader>u", vim.cmd.UndotreeToggle)

-- fugitive
nmap("<leader>gs", vim.cmd.Git)
--








