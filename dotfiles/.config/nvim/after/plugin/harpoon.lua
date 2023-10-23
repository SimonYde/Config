local mark = vim.F.npcall(require, "harpoon.mark")
if not mark then
  return
end

local ui = require("harpoon.ui")

local nmap = require("syde.keymap").nmap

nmap("<leader>h", mark.add_file, "Harpoon add file")
nmap("<C-h>", ui.toggle_quick_menu, "Harpoon menu")
nmap("<space>1", function() ui.nav_file(1) end, "Harpoon file: 1")
nmap("<space>2", function() ui.nav_file(2) end, "Harpoon file: 2")
nmap("<space>3", function() ui.nav_file(3) end, "Harpoon file: 3")
nmap("<space>4", function() ui.nav_file(4) end, "Harpoon file: 4")
