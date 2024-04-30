Load.later(function()
    local nmap = require("syde.keymap").nmap
    local harpoon = Load.now(function()
        local harpoon = require("harpoon")
        harpoon:setup()

        nmap("<leader>h", function() harpoon:list():add() end, "[h]arpoon add path")
        nmap("<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "[h]arpoon menu")

        nmap("<leader>1", function() harpoon:list():select(1) end, "Harpoon select 1")
        nmap("<leader>2", function() harpoon:list():select(2) end, "Harpoon select 2")
        nmap("<leader>3", function() harpoon:list():select(3) end, "Harpoon select 3")
        nmap("<leader>4", function() harpoon:list():select(4) end, "Harpoon select 4")

        -- Toggle previous & next buffers stored within Harpoon list
        nmap("<C-S-P>", function() harpoon:list():prev() end, "Harpoon [P]revious")
        nmap("<C-S-N>", function() harpoon:list():next() end, "Harpoon [N]ext")
        return harpoon
    end)
    if harpoon then return end

    Load.now(function()
        local MiniVisits = require("mini.visits")
        local MiniExtra = require("mini.extra")
        nmap("<leader>h", MiniVisits.add_path, "MiniVisits add path")
        nmap("<C-h>", MiniExtra.pickers.visit_paths, "MiniVisits menu")
        -- nmap("<space>1", function() MiniVisits.nav_file(1) end, "MiniVisits file: 1")
        -- nmap("<space>2", function() MiniVisits.nav_file(2) end, "MiniVisits file: 2")
        -- nmap("<space>3", function() MiniVisits.nav_file(3) end, "MiniVisits file: 3")
        -- nmap("<space>4", function() MiniVisits.nav_file(4) end, "MiniVisits file: 4")
    end)
end)
