Load.later(function()
    vim.o.foldtext = '' -- Use underlying text with its highlighting
    vim.o.foldnestmax = 10
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.opt.foldlevel = 1 -- Display all folds except top ones
    vim.opt.foldenable = true

    vim.opt.runtimepath:prepend('~/.local/state/nvim/treesitter')

    local treesitter_opts = {
        auto_install = true,
        ensure_installed = {
            'lua',
            'nix',
            'markdown',
            'markdown_inline',
            'query',
            'vim',
            'vimdoc',
            'gitignore',
            'gitattributes',
            'gitcommit',
        },
        parser_install_dir = '~/.local/state/nvim/treesitter',
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<M-w>', -- maps in normal mode to init the node/scope selection
                node_incremental = '<M-w>', -- increment to the upper named parent
                node_decremental = '<M-C-w>', -- decrement to the previous node
                scope_incremental = '<M-s>', -- increment to the upper scope (as defined in locals.scm)
            },
        },
    }

    Load.now(function()
        Load.packadd('rainbow-delimiters.nvim')
        local rainbow_delimiters = require('rainbow-delimiters')
        treesitter_opts.rainbow = {
            enable = true,
            -- Which query to use for finding delimiters
            query = 'rainbow-parens',
            -- Highlight the entire buffer all at once
            strategy = rainbow_delimiters.strategy.global,
        }
    end)

    require('nvim-treesitter.configs').setup(treesitter_opts)
end)

Load.later(function()
    Load.packadd('nvim-treesitter-context')
    local context = require('treesitter-context')
    context.setup()
    local nmap = Keymap.nmap

    nmap('<leader><leader>t', context.toggle, 'toggle [t]reesitter context')
end)
