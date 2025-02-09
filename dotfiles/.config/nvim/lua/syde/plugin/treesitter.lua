Load.later(function()
    vim.opt.runtimepath:prepend('~/.local/state/nvim/treesitter')
    require('nvim-treesitter.configs').setup({
        auto_install = true,
        ignore_install = {},
        sync_install = false,
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
    })
end)

Load.later(function()
    Load.packadd('rainbow-delimiters.nvim')
    local rainbow_delimiters = require('rainbow-delimiters')
    ---@type rainbow_delimiters.config
    vim.g.rainbow_delimiters = {
        strategy = {
            [''] = rainbow_delimiters.strategy['global'],
            vim = rainbow_delimiters.strategy['local'],
        },
        query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
        },
        priority = {
            [''] = 110,
            lua = 210,
        },
        highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
        },
    }
end)

Load.later(function()
    Load.packadd('nvim-treesitter-context')
    local context = require('treesitter-context')
    context.setup()
    local nmap = Keymap.nmap

    nmap('<leader><leader>t', context.toggle, 'toggle [t]reesitter context')

    Snacks.toggle
        .new({
            name = 'Treesitter context',
            get = function() return context.enabled() end,
            set = function(state) context.toggle() end,
        })
        :map('<leader><leader>t')
end)
