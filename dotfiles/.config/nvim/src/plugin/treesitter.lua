Load.later(function()
    vim.opt.foldmethod = "expr"
    vim.opt.foldlevel = 1        -- Display all folds except top ones
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = true

    local treesitter_opts = {
        auto_install = false,
        highlight = {
            enable = true,
            disable = {
                -- "latex",
            },
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "<M-w>",     -- maps in normal mode to init the node/scope selection
                node_incremental = "<M-w>",   -- increment to the upper named parent
                node_decremental = "<M-C-w>", -- decrement to the previous node
                scope_incremental = "<M-s>",  -- increment to the upper scope (as defined in locals.scm)
            },
        },
    }

    Load.now(function()
        Load.packadd('rainbow-delimiters.nvim')
        local rainbow_delimiters = require('rainbow-delimiters')
        treesitter_opts.rainbow = {
            enable = true,
            -- list of languages you want to disable the plugin for
            disable = {},
            -- Which query to use for finding delimiters
            query = 'rainbow-parens',
            -- Highlight the entire buffer all at once
            strategy = rainbow_delimiters.strategy.global,
        }
    end)

    require('nvim-treesitter.configs').setup(treesitter_opts)

    Load.now(function()
        Load.packadd('nvim-treesitter-context')
        local context = require('treesitter-context')
        context.setup {}
        local nmap = Keymap.nmap

        nmap("<leader><leader>t", context.toggle, "toggle [t]reesitter context")
    end)
end)
