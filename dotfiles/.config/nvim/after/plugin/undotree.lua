local nmap = require('syde.keymap').nmap

nmap(
    "<leader>u",
    function()
        vim.cmd("UndotreeToggle")
        vim.cmd("UndotreeFocus")
    end,
    "Toggle [u]ndo tree"
)
