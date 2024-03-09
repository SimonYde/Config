Load.later(function()
    local nmap = require("syde.keymap").nmap
    nmap("<leader>gd",
        function()
            Load.once(function()
                require('diffview').setup {}
            end)
            vim.cmd [[DiffviewOpen]]
        end,
        "git [d]iffview")


    local neogit = Load.once(function()
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
    end)
end)
