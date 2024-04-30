local catppuccin = Load.now(function()
    local catppuccin = require("catppuccin")
    local flavour = "mocha"
    if VARIANT ~= "dark" then
        flavour = "latte"
    end

    catppuccin.setup {
        flavour = flavour,
        transparent_background = false,
        integrations = {
            cmp = true,
            gitsigns = true,
            harpoon = true,
            indent_blankline = { enabled = true, colored_indent_levels = false },
            lsp_saga = true,
            mini = true,
            nvimtree = false,
            rainbow_delimiters = true,
            telescope = { enabled = true, style = "nvchad" },
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
                    style = { "bold" },
                },
            }
        end,
    }
    vim.cmd.colorscheme("catppuccin")
    return catppuccin
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
            winbar = true,
        })
        :apply()
end)
if catppuccin then return end

Load.now(function()
    require('mini.base16').setup {
        palette = PALETTE,
        use_cterm = true,
    }
end)

