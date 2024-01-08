local has_mini, starter = pcall(require, 'mini.starter')
if not has_mini then
    return
end

local nmap = require('syde.keymap').map('n')

starter.setup {}
require('mini.ai').setup {}
require('mini.align').setup {}
require('mini.bracketed').setup {}
nmap('U', '<C-r>', 'Redo')
require('mini.comment').setup {}
require('mini.surround').setup {}
require('mini.jump').setup {}
require('mini.jump2d').setup {}
require('mini.splitjoin').setup {}

nmap("<M-t>", function()
    local MiniTrailspace = require('mini.trailspace')
    MiniTrailspace.setup {}
    MiniTrailspace.trim()
    MiniTrailspace.trim_last_lines()
end, "Clean [t]railing whitespace")

require('mini.move').setup {}
require('mini.visits').setup {}
