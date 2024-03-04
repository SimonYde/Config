local lazy = require('syde.lazy')

lazy.lazy_load(function()
    local trouble = vim.F.npcall(require, 'trouble')
    if not trouble then
        return
    end
    trouble.setup {}

    local nmap = require('syde.keymap').nmap

    nmap(
        '<leader>t',
        function()
            vim.cmd [[TroubleToggle]]
        end,
        "Toggle [t]rouble"
    )
end)
