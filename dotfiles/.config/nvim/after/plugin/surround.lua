local surround = vim.F.npcall(require, 'nvim-surround')
if surround then
  surround.setup {}
else
  require('mini.surround').setup {}
end
