local has_mini, starter = pcall(require, 'mini.starter')
if not has_mini then
  return
end

local nmap = require('syde.keymap').nmap

starter.setup {}
require('mini.ai').setup {}
require('mini.align').setup {}
require('mini.bracketed').setup {}
nmap('U', '<C-r>', 'Redo')
require('mini.comment').setup {}
require('mini.surround').setup {}
require('mini.jump').setup {}


