vim.api.nvim_create_user_command('Base16', function()
    local palette_path = vim.env.XDG_CONFIG_HOME .. '/stylix/palette.json'

    if not vim.uv.fs_stat(palette_path) then
        vim.notify('`$XDG_CONFIG_HOME/stylix/palette.json` does not exist', vim.log.levels.ERROR)
        return
    end

    local palette = {}
    local scheme = vim.json.decode(table.concat(vim.fn.readfile(palette_path)))

    for key, value in pairs(scheme) do
        if string.sub(key, 1, 4) == 'base' then palette[key] = '#' .. value end
    end

    require('mini.base16').setup({
        palette = palette,
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

    vim.cmd(('hi MiniStatuslineFilename guifg=%s'):format(palette.base04))
    vim.cmd(('hi MiniJump2dSpot cterm=bold gui=bold guifg=%s guibg=%s'):format(palette.base08, palette.base00))
    vim.cmd(('hi MiniJump2dSpotAhead guifg=%s guibg=%s'):format(palette.base0B, palette.base00))
    vim.cmd(('hi MiniJump2dSpotUnique guifg=%s guibg=%s'):format(palette.base0C, palette.base00))
    vim.cmd(('hi SnacksPickerDir guifg=%s'):format(palette.base04))
    vim.cmd(('hi BlinkCmpSignatureHelp guibg=%s'):format(palette.base01))

    require('mini.colors')
        .get_colorscheme()
        :add_transparency({
            float = true,
            general = true,
            statuscolumn = true,
            statusline = true,
            tabline = true,
            winbar = true,
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
    vim.cmd('hi TreesitterContextBottom gui=underline')

    require('mini.colors').get_colorscheme():add_cterm_attributes():write({ name = 'base16' })
end, {})

local ok, _ = pcall(vim.cmd.colorscheme, 'base16')
if not ok then Load.later(vim.cmd.Base16) end
