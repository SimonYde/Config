local mark = vim.F.npcall(require, "harpoon.mark")
local nmap = require("syde.keymap").nmap
if mark then
    local ui = require("harpoon.ui")


    nmap("<leader>h", mark.add_file, "Harpoon add file")
    nmap("<C-h>", ui.toggle_quick_menu, "Harpoon menu")
    nmap("<space>1", function() ui.nav_file(1) end, "Harpoon file: 1")
    nmap("<space>2", function() ui.nav_file(2) end, "Harpoon file: 2")
    nmap("<space>3", function() ui.nav_file(3) end, "Harpoon file: 3")
    nmap("<space>4", function() ui.nav_file(4) end, "Harpoon file: 4")
    return
end

local MiniVisits = vim.F.npcall(require, "mini.visits")

if MiniVisits then
    local MiniExtra = vim.F.npcall(require, "mini.extra")
    if not MiniExtra then
        return
    end
    nmap("<leader>h", MiniVisits.add_path, "MiniVisits add path")
    nmap("<C-h>", MiniExtra.pickers.visit_paths, "MiniVisits menu")
    -- nmap("<space>1", function() MiniVisits.nav_file(1) end, "MiniVisits file: 1")
    -- nmap("<space>2", function() MiniVisits.nav_file(2) end, "MiniVisits file: 2")
    -- nmap("<space>3", function() MiniVisits.nav_file(3) end, "MiniVisits file: 3")
    -- nmap("<space>4", function() MiniVisits.nav_file(4) end, "MiniVisits file: 4")
    return
end
