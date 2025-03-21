Load.later(function()
    if not PALETTE then
        PALETTE = {
            base00 = '#1d2021',
            base01 = '#3c3836',
            base02 = '#504945',
            base03 = '#665c54',
            base04 = '#bdae93',
            base05 = '#d5c4a1',
            base06 = '#ebdbb2',
            base07 = '#fbf1c7',
            base08 = '#fb4934',
            base09 = '#fe8019',
            base0A = '#fabd2f',
            base0B = '#b8bb26',
            base0C = '#8ec07c',
            base0D = '#83a598',
            base0E = '#d3869b',
            base0F = '#d65d0e',
        }
    end
    require('mini.base16').setup({
        palette = PALETTE,
        use_cterm = true,
        plugins = {
            default = false,
            ['HiPhish/rainbow-delimiters.nvim'] = true,
            ['NeogitOrg/neogit'] = true,
            ['echasnovski/mini.nvim'] = true,
            ['folke/todo-comments.nvim'] = true,
            ['folke/trouble.nvim'] = true,
            ['folke/which-key.nvim'] = true,
            ['glepnir/lspsaga.nvim'] = true,
            ['hrsh7th/nvim-cmp'] = true,
            ['kevinhwang91/nvim-ufo'] = true,
            ['rcarriga/nvim-dap-ui'] = true,
            ['MeanderingProgrammer/render-markdown.nvim'] = true,
        },
    })
    vim.cmd(('hi MiniStatuslineFilename guifg=%s'):format(PALETTE.base04))
    vim.cmd(('hi MiniJump2dSpot cterm=bold gui=bold guifg=%s guibg=%s'):format(PALETTE.base08, PALETTE.base00))
    vim.cmd(('hi MiniJump2dSpotAhead guifg=%s guibg=%s'):format(PALETTE.base0B, PALETTE.base00))
    vim.cmd(('hi MiniJump2dSpotUnique guifg=%s guibg=%s'):format(PALETTE.base0C, PALETTE.base00))
    vim.cmd(('hi SnacksPickerDir guifg=%s'):format(PALETTE.base04))
    vim.cmd(('hi BlinkCmpSignatureHelp guibg=%s'):format(PALETTE.base01))
end)

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
    -- Add a line to distinguish between context and current position
    vim.cmd(('hi TreesitterContextBottom gui=underline'):format(PALETTE.base04))
end)
