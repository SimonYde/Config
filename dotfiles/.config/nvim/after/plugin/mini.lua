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

local MiniTrailspace = require('mini.trailspace')
MiniTrailspace.setup {}
nmap("<M-t>", function ()
  MiniTrailspace.trim()
  MiniTrailspace.trim_last_lines()
end, "Clean [t]railing whitespace")

require('mini.move').setup {}

require('mini.basics').setup {
  -- Options. Set to `false` to disable.
  options = {
    -- Basic options ('termguicolors', 'number', 'ignorecase', and many more)
    basic = true,

    -- Extra UI features ('winblend', 'cmdheight=0', ...)
    extra_ui = false,

    -- Presets for window borders ('single', 'double', ...)
    win_borders = 'default',
  },

  -- Mappings. Set to `false` to disable.
  mappings = {
    -- Basic mappings (better 'jk', save with Ctrl+S, ...)
    basic = true,

    -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
    -- Supply empty string to not create these mappings.
    option_toggle_prefix = [[<leader><leader>]],

    -- Window navigation with <C-hjkl>, resize with <C-arrow>
    windows = false,

    -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
    move_with_alt = false,
  },

  -- Autocommands. Set to `false` to disable
  autocommands = {
    -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
    basic = false,

    -- Set 'relativenumber' only in linewise and blockwise Visual mode
    relnum_in_visual_mode = false,
  },

  -- Whether to disable showing non-error feedback
  silent = true,
}
