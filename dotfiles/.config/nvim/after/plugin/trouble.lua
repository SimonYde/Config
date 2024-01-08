local nmap = require('syde.keymap').nmap

local has_run_setup = false
local function setup_trouble()
    if has_run_setup then
        return
    end
    local trouble = vim.F.npcall(require, 'trouble')
    if not trouble then
        return
    end
    trouble.setup {}
    has_run_setup = true
end

nmap(
    '<leader>t',
    function()
        setup_trouble()
        vim.cmd [[TroubleToggle]]
    end,
    "Toggle [t]rouble"
)
