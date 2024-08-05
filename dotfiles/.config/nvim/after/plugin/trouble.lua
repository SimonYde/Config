Load.later(function()
    vim.cmd [[packadd trouble.nvim]]
    require('trouble').setup {}
    local nmap = require('syde.keymap').nmap

    nmap(
        '<leader>td',
        function()
            vim.cmd [[Trouble diagnostics toggle]]
        end,
        "Toggle [t]rouble [d]iagnostics"
    )
end)
