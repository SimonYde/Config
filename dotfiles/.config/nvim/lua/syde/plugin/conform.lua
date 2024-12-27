Load.later(function()
    local nmap = Keymap.nmap
    local conform = require('conform')
    conform.setup({
        formatters_by_ft = {
            typst = { 'typstyle' },
            lua = { 'stylua' },
            nix = { 'nixfmt' },
            clojure = { 'cljfmt' },
            -- nu = { 'nufmt' },
        },
    })

    nmap(
        '<leader>=',
        function() conform.format({ stop_after_first = true, lsp_fallback = true }) end,
        'Format with conform'
    )
end)
