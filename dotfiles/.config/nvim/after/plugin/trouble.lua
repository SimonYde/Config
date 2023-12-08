local trouble = vim.F.npcall(require, 'trouble')

if not trouble then
  return
end

trouble.setup{}

local nmap = require('syde.keymap').nmap
nmap('<leader>t', vim.cmd.TroubleToggle, "Toggle [t]rouble" )

