local catppuccin = Load.now(function()
    local catppuccin = require('catppuccin')
    local flavour = 'mocha'
    if VARIANT ~= 'dark' then
        flavour = 'latte'
    end

    catppuccin.setup {
        flavour = flavour,
        transparent_background = true,
        integrations = {
            cmp = true,
            gitsigns = true,
            harpoon = true,
            indent_blankline = { enabled = true, colored_indent_levels = false },
            lsp_saga = true,
            mini = true,
            nvimtree = false,
            rainbow_delimiters = true,
            telescope = {
                enabled = true,
                style = 'nvchad',
            },
            treesitter = true,
            treesitter_context = true,
            which_key = true,
        },
        custom_highlights = function(colors)
            return {
                MiniJump = {
                    fg = colors.subtext1,
                    bg = colors.surface2,
                },
                MiniStatuslineModeNormal = {
                    fg = colors.mantle,
                    bg = colors.lavender,
                    style = { 'bold' },
                },
            }
        end,
    }
    vim.cmd.colorscheme("catppuccin")
    return catppuccin
end)

local rose_pine = Load.now(function()
    local rose_pine = require('rose-pine')
    rose_pine.setup({
        disable_background = true,
        styles = {
            italic = false,
        }

    })
    vim.cmd.colorscheme('rose-pine')
    Load.later(function()
        require('mini.colors')
            .get_colorscheme()
            :add_transparency({
                float = true,
                general = true,
                statuscolumn = true,
                statusline = true,
                tabline = false,
                winbar = false,
            })
            :apply()
    end)
    return rose_pine
end)

if catppuccin or rose_pine then return end

Load.now(function()
    require('mini.base16').setup {
        palette = PALETTE,
        use_cterm = true,
        plugins = {
            default = false,
            ['DanilaMihailov/beacon.nvim'] = false,
            ['HiPhish/rainbow-delimiters.nvim'] = true,
            ['NeogitOrg/neogit'] = true,
            ['akinsho/bufferline.nvim'] = false,
            ['anuvyklack/hydra.nvim'] = false,
            ['echasnovski/mini.nvim'] = true,
            ['folke/lazy.nvim'] = false,
            ['folke/noice.nvim'] = false,
            ['folke/todo-comments.nvim'] = true,
            ['folke/trouble.nvim'] = true,
            ['folke/which-key.nvim'] = true,
            ['ggandor/leap.nvim'] = false,
            ['ggandor/lightspeed.nvim'] = false,
            ['glepnir/dashboard-nvim'] = false,
            ['glepnir/lspsaga.nvim'] = true,
            ['hrsh7th/nvim-cmp'] = true,
            ['justinmk/vim-sneak'] = false,
            ['kevinhwang91/nvim-ufo'] = false,
            ['lewis6991/gitsigns.nvim'] = true,
            ['lukas-reineke/indent-blankline.nvim'] = true,
            ['neoclide/coc.nvim'] = false,
            ['nvim-lualine/lualine.nvim'] = false,
            ['nvim-neo-tree/neo-tree.nvim'] = false,
            ['nvim-telescope/telescope.nvim'] = true,
            ['nvim-tree/nvim-tree.lua'] = false,
            ['phaazon/hop.nvim'] = false,
            ['rcarriga/nvim-dap-ui'] = true,
            ['rcarriga/nvim-notify'] = false,
            ['rlane/pounce.nvim'] = false,
            ['romgrk/barbar.nvim'] = false,
            ['stevearc/aerial.nvim'] = false,
            ['williamboman/mason.nvim'] = false,
        },
    }
    Load.later(function()
        require('mini.colors')
            .get_colorscheme()
            :add_transparency({
                float = true,
                general = true,
                statuscolumn = true,
                statusline = true,
                tabline = false,
                winbar = false,
            })
            :apply()
        vim.cmd [[hi GitSignsAdd guibg= ctermbg=]]
        vim.cmd [[hi GitSignsChange guibg= ctermbg=]]
        vim.cmd [[hi GitSignsChangeDelete guibg= ctermbg=]]
        vim.cmd [[hi GitSignsDelete guibg= ctermbg=]]
        Separator = string.format([[hi TreesitterContextBottom cterm=underline gui=underline guisp=%s]], PALETTE.base01)
        vim.cmd(Separator)
    end)
end)
