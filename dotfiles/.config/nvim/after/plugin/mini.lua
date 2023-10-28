local has_mini, starter = pcall(require, 'mini.starter')
if not has_mini then
  return
end

local nmap = require('syde.keymap').nmap

require('mini.ai').setup {}
require('mini.align').setup {}
require('mini.bracketed').setup {}
require('mini.comment').setup {}
require('mini.pairs').setup {}
starter.setup {}
require('mini.surround').setup {}


require('mini.jump').setup {}
vim.cmd [[ highlight MiniJump guifg=#181825 guibg=#f38ba8 ]]


local has_indent_blankline, _ = pcall(require, 'ibl')
if not has_indent_blankline then
  local indentscope = require('mini.indentscope')
  indentscope.setup {
    symbol = '▏',
    draw = {
      delay = 0,
      animation = indentscope.gen_animation.none(),
    },
  }
end
