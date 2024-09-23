Load.later(function()
    vim.cmd [[packadd nvim-treesitter]]
    vim.cmd [[packadd nvim-treesitter-textobjects]]

    local treesitter_opts = {
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
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    -- You can use the capture groups defined in textobjects.scm
                    ["aa"] = "@parameter.outer",
                    ["ia"] = "@parameter.inner",
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                    ["ao"] = "@loop.outer",
                    ["io"] = "@loop.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]f"] = "@function.outer",
                    ["]["] = "@class.outer",
                    ["]o"] = "@loop.*",
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                    ["]["] = "@class.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[["] = "@class.outer",
                    ["[o"] = "@loop.*",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[]"] = "@class.outer",
                },
                goto_next = {
                    ["]i"] = "@conditional.inner",
                },
                goto_previous = {
                    ["[i"] = "@conditional.inner",
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>s"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>S"] = "@parameter.inner",
                },
            },
        },

    }

    Load.now(function()
        vim.cmd [[packadd rainbow-delimiters.nvim]]
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
        vim.cmd [[packadd nvim-treesitter-context]]
        local context = require('treesitter-context')
        context.setup {}
        local nmap = require('syde.keymap').nmap

        nmap("<leader><leader>t", context.toggle, "toggle [t]reesitter context")
    end)
end)
