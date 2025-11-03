Load.later(function()
    require('catppuccin').setup({
        flavour = 'auto', -- latte, frappe, macchiato, mocha

        background = { -- :h background
            light = 'latte',
            dark = 'mocha',
        },

        transparent_background = true, -- disables setting the background color.
        float = {
            transparent = false, -- enable transparent floating windows
            solid = false, -- use solid styling for floating windows, see |winborder|
        },

        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)

        no_italic = true, -- Force no italic
        no_bold = false, -- Force no bold
        no_underline = false, -- Force no underline
        styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
            comments = {},
            conditionals = {},
            loops = {},
            functions = {},
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
            -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = function(colors)
            return {
                DapStopped = { bg = colors.red, fg = '' },
                DapBreakpoint = { bg = colors.red, fg = '' },
                ['@comment'] = { fg = colors.flamingo },
                ['@comment.documentation'] = { fg = colors.flamingo },
            }
        end,
        {},
        default_integrations = false,
        integrations = {
            blink_cmp = true,
            dap = true,
            dap_ui = true,
            lsp_saga = true,
            lsp_trouble = true,
            which_key = true,

            diffview = true,
            neogit = true,

            treesitter = true,
            treesitter_context = true,
            rainbow_delimiters = true,

            markdown = true,
            render_markdown = true,

            mini = {
                enabled = true,
                indentscope_color = 'base',
            },

            snacks = {
                enabled = true,
                indent_scope_color = 'base',
            },

            indent_blankline = {
                enabled = true,
                scope_color = 'base',
                colored_indent_levels = false,
            },

            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { 'italic' },
                    hints = { 'italic' },
                    warnings = { 'italic' },
                    information = { 'italic' },
                    ok = { 'italic' },
                },
                underlines = {
                    errors = { 'underline' },
                    hints = { 'underline' },
                    warnings = { 'underline' },
                    information = { 'underline' },
                    ok = { 'underline' },
                },
                inlay_hints = {
                    background = true,
                },
            },
        },
    })

    -- setup must be called before loading
    vim.cmd.colorscheme('catppuccin')
end)

Load.later(function()
    do
        return
    end
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
            ['kevinhwang91/nvim-ufo'] = false,
            ['rcarriga/nvim-dap-ui'] = true,
            ['MeanderingProgrammer/render-markdown.nvim'] = true,
        },
    })

    vim.cmd(('hi @comment guifg=%s'):format(palette.base09))
    vim.cmd(('hi Number guifg=%s'):format(palette.base0B))
    vim.cmd(('hi Identifier guifg=%s'):format(palette.base05))
    vim.cmd('hi clear @keyword.return')

    vim.cmd(('hi MiniStatuslineFilename guifg=%s'):format(palette.base05))

    vim.cmd(('hi MiniJump2dSpot cterm=bold gui=bold guifg=%s guibg=%s'):format(palette.base08, palette.base00))
    vim.cmd(('hi MiniJump2dSpotAhead guifg=%s guibg=%s'):format(palette.base0D, palette.base00))
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
end)
