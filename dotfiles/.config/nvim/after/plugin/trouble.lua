local nmap = require('syde.keymap').nmap

nmap(
    '<leader>t',
    function()
        local trouble = vim.F.npcall(require, 'trouble')
        if not trouble then
            return
        end
        trouble.setup {}
        vim.cmd [[TroubleToggle]]
    end,
    "Toggle [t]rouble"
)
