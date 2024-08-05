Load.later(function()
    local nmap = require('syde.keymap').nmap
    local conform = require('conform')
    conform.setup({
        -- format_on_save = { -- These options will be passed to conform.format()
        --     timeout_ms = 500,
        --     lsp_fallback = true,
        -- },
        formatters_by_ft = {
            typst = { "typstyle" },
            nix = { "nixfmt", "alejandra", "nixpkgs_fmt" },
        },

        formatters = {
            typstyle = {
                command = "typstyle",
            },
        },
    })

    nmap(
        "<leader>=",
        function() conform.format({ stop_after_first = true, lsp_fallback = true }) end,
        "Format with conform"
    )
end)
