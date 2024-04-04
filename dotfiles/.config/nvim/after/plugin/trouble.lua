Load.later(function()
    vim.cmd [[packadd trouble.nvim]]
    require('trouble').setup {}
    local nmap = require('syde.keymap').nmap

    nmap(
        '<leader>t',
        function()
            vim.cmd [[TroubleToggle]]
        end,
        "Toggle [t]rouble"
    )
end)
