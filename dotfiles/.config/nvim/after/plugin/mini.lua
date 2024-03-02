local has_mini, starter = pcall(require, 'mini.starter')
if not has_mini then
    return
end

local nmap = require('syde.keymap').nmap

starter.setup {}
require('mini.ai').setup { n_lines = 500 }
require('mini.align').setup {}
require('mini.bracketed').setup { n_lines = 500 }
nmap('U', '<C-r>', 'Redo')
require('mini.comment').setup {}
require('mini.surround').setup {}
require('mini.jump').setup {}
require('mini.jump2d').setup {}
require('mini.splitjoin').setup {}
require('mini.move').setup {}
require('mini.visits').setup {}
require('mini.sessions').setup {}

local MiniNotify = require('mini.notify')
MiniNotify.setup {
    window = {
        winblend = 0,
    },
}
vim.notify = MiniNotify.make_notify()

nmap(
    "<M-t>",
    function()
        local MiniTrailspace = require('mini.trailspace')
        MiniTrailspace.setup {}
        MiniTrailspace.trim()
        MiniTrailspace.trim_last_lines()
    end,
    "Clean [t]railing whitespace"
)
