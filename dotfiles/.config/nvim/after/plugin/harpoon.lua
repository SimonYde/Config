Load.later(function()
    local nmap = require("syde.keymap").nmap
    Load.now(function()
        local harpoon = require("harpoon")
        harpoon:setup()

        nmap("<leader>h", function() harpoon:list():add() end, "[h]arpoon add path")
        nmap("<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, "[h]arpoon menu")

        nmap("<leader>1", function() harpoon:list():select(1) end, "Harpoon select 1")
        nmap("<leader>2", function() harpoon:list():select(2) end, "Harpoon select 2")
        nmap("<leader>3", function() harpoon:list():select(3) end, "Harpoon select 3")
        nmap("<leader>4", function() harpoon:list():select(4) end, "Harpoon select 4")

        -- Toggle previous & next buffers stored within Harpoon list
        nmap("<C-S-p>", function() harpoon:list():prev() end, "Harpoon [P]revious")
        nmap("<C-S-N>", function() harpoon:list():next() end, "Harpoon [N]ext")
    end)
end)
