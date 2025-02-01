local add_transparency = function()
    Load.later(function()
        require('mini.colors')
            .get_colorscheme()
            :add_transparency({
                float = true,
                general = true,
                statuscolumn = true,
                statusline = true,
                tabline = true,
                winbar = false,
            })
            :apply()
        -- Remove background for sign column elements
        vim.cmd([[
            hi MiniDiffSignAdd         guibg=NONE ctermbg=NONE
            hi MiniDiffSignChange      guibg=NONE ctermbg=NONE
            hi MiniDiffSignDelete      guibg=NONE ctermbg=NONE
            hi MiniTabLineFill         guibg=NONE ctermbg=NONE
            hi WhichKeySeparator       guibg=NONE ctermbg=NONE
            hi DiagnosticFloatingOk    guibg=NONE ctermbg=NONE
            hi DiagnosticFloatingError guibg=NONE ctermbg=NONE
            hi DiagnosticFloatingWarn  guibg=NONE ctermbg=NONE
            hi DiagnosticFloatingInfo  guibg=NONE ctermbg=NONE
            hi DiagnosticFloatingHint  guibg=NONE ctermbg=NONE
        ]])
    end)
end

Load.now(function()
    require('mini.base16').setup({
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
            ['kevinhwang91/nvim-bqf'] = false,
            ['kevinhwang91/nvim-ufo'] = true,
            ['lewis6991/gitsigns.nvim'] = false,
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
    })
    add_transparency()
    vim.cmd(('hi MiniStatuslineFilename guifg=%s'):format(PALETTE.base04))
    vim.cmd(('hi MiniJump2dSpot cterm=bold gui=bold guifg=%s guibg=%s'):format(PALETTE.base08, PALETTE.base00))
    vim.cmd(('hi MiniJump2dSpotAhead guifg=%s guibg=%s'):format(PALETTE.base0B, PALETTE.base00))
    vim.cmd(('hi MiniJump2dSpotUnique guifg=%s guibg=%s'):format(PALETTE.base0C, PALETTE.base00))
    vim.cmd(('hi SnacksPickerDir guifg=%s'):format(PALETTE.base04))
    vim.cmd(('hi BlinkCmpSignatureHelp guibg=%s'):format(PALETTE.base01))
end)
