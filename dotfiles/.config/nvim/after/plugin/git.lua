local nmap = require("syde.keymap").nmap

nmap("<leader>gd",
    function()
        local has_diffview, diffview = pcall(require, 'diffview')
        if has_diffview then
            diffview.setup {}
        end
        vim.cmd [[DiffviewOpen]]
    end,
    "git [d]iffview")


local setup_neogit = function(neogit)
    neogit.setup {
        integrations = {
            diffview = true,
            telescope = true,
        },
    }
end

nmap("<leader>gs",
    function()
        local neogit = vim.F.npcall(require, 'neogit')
        if not neogit then return end
        setup_neogit(neogit)
        neogit.open()
    end,
    "Neogit [s]tatus")

nmap("<leader>gc",
    function()
        local neogit = vim.F.npcall(require, 'neogit')
        if not neogit then return end
        setup_neogit(neogit)
        neogit.open { "commit" }
    end,
    "Neogit [c]ommit")


local gitsigns = vim.F.npcall(require, 'gitsigns')
if gitsigns then
    gitsigns.setup {
        current_line_blame_opts = {
            delay = 1000,
            virt_text_pos = "eol",
        },
    }
end
