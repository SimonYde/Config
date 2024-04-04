Load.later(function()
    local nmap = require("syde.keymap").nmap




    nmap("<leader>gd",
        function()
            local diffview = Load.once(function()
                vim.cmd [[packadd diffview.nvim]]
                local diffview = require('diffview')
                diffview.setup {}
                return diffview
            end)
            diffview().open()
        end,
        "git [d]iffview")


    local neogit = Load.once(function()
        vim.cmd [[packadd diffview.nvim]]
        local neogit = require('neogit')
        neogit.setup {
            integrations = {
                diffview = true,
                telescope = true,
            },
        }
        return neogit
    end)

    nmap("<leader>gs",
        function()
            neogit().open()
        end,
        "Neogit [s]tatus")

    nmap("<leader>gc",
        function()
            neogit().open { "commit" }
        end,
        "Neogit [c]ommit")


    Load.now(function()
        local gitsigns = require('gitsigns')
        gitsigns.setup {
            current_line_blame_opts = {
                delay = 1000,
                virt_text_pos = "eol",
            },
        }
        nmap("<leader>gb", gitsigns.toggle_current_line_blame, "Toggle git [b]lame")
    end)
end)
