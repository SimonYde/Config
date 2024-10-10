local source = function(path) dofile(Config.path_source .. path) end
source('load.lua')
source('options.lua')
source('remap.lua')
source('colorscheme.lua')

source('plugin/starter.lua')
source('plugin/statusline.lua')
source('plugin/mini.lua')
source('plugin/telescope.lua')
source('plugin/treesitter.lua')
source('plugin/completion.lua')
source('plugin/conform.lua')
source('plugin/lsp.lua')
source('plugin/obsidian.lua')
source('plugin/nvim-dap.lua')
source('plugin/which-key.lua')

Load.later(function()
    require("todo-comments").setup()
end)

Load.later(function()
    Load.packadd('trouble.nvim')
    require('trouble').setup()
    local nmap = Keymap.nmap

    nmap(
        '<leader>td',
        function()
            vim.cmd [[Trouble diagnostics toggle]]
        end,
        "Toggle [t]rouble [d]iagnostics"
    )
end)

Load.on_events(function()
    local autopairs = require('nvim-autopairs')
    autopairs.setup()
    Load.now(function()
        require('cmp').event:on(
            'confirm_done',
            require('nvim-autopairs.completion.cmp').on_confirm_done()
        )
    end)
    return autopairs
end, "InsertEnter")

Load.later(function()
    Load.packadd('indent-blankline.nvim')
    local ibl = require('ibl')
    ibl.setup {
        indent = {
            char = '▏',
        },
        scope = {
            enabled = false,
        },
    }
    return ibl
end)

Load.later(function()
    Load.packadd('render-markdown.nvim')
    require('render-markdown').setup({
        callout = {
            definition = { raw = '[!definition]', rendered = ' Definition', highlight = 'RenderMarkdownInfo' },
            theorem = { raw = '[!theorem]', rendered = '󰨸 Theorem', highlight = 'RenderMarkdownHint' },
            proof = { raw = '[!proof]', rendered = '󰌶 Proof', highlight = 'RenderMarkdownWarn' },
        }
    })
end)

Load.later(function()
    local nmap = Keymap.nmap

    Load.now(function()
        Load.packadd('diffview.nvim')
        local diffview = require('diffview')
        diffview.setup()
        nmap("<leader>gd", function() diffview.open() end, "git [d]iffview")
    end)

    Load.now(function()
        local neogit = require('neogit')
        neogit.setup {
            integrations = {
                diffview = true,
                telescope = true,
                mini_pick = true,
            },
        }
        nmap("<leader>gs", function() neogit.open() end, "Neogit [s]tatus")
        nmap("<leader>gw", function() neogit.open({ "worktree" }) end, "Neogit [w]orktree")
        nmap("<leader>gc", function() neogit.open({ "commit" }) end, "Neogit [c]ommit")
    end)
end)

Load.perform_lazy_loading()
