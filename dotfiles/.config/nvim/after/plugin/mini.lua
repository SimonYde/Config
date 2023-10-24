local has_mini, starter = pcall(require, 'mini.starter')
if not has_mini then
  return
end

local nmap = require('syde.keymap').nmap

require('mini.ai').setup()
require('mini.align').setup()
require('mini.bracketed').setup()
require('mini.comment').setup()
require('mini.pairs').setup()
starter.setup()
require('mini.surround').setup()
require('mini.jump').setup()



local has_nvimtree, _ = pcall(require, 'nvim-tree')
if not has_nvimtree then
  require('mini.files').setup()
  nmap('<M-f>', '<cmd>lua MiniFiles.open()<CR>', "Show [f]ile-explorer")
  nmap('<M-F>', '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', "Show current [F]ile in file-explorer")
end

local has_lualine, _ = pcall(require, 'lualine')
if not has_lualine then
  require('mini.statusline').setup({
    set_vim_settings = false,
  })
end

local has_indent_blankline, _ = pcall(require, 'ibl')
if not has_indent_blankline then
  local indentscope = require('mini.indentscope')
  indentscope.setup({
    symbol = '▏',
    draw = {
      delay = 0,
      animation = indentscope.gen_animation.none(),
    },
  })
end



local has_whichkey, _ = pcall(require, 'which-key')
if not has_whichkey then
  local clue = require('mini.clue')
  clue.setup({
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },

      -- Built-in completion
      { mode = 'i', keys = '<C-x>' },

      -- `g` key
      { mode = 'n', keys = 'g' },
      { mode = 'x', keys = 'g' },

      -- Marks
      { mode = 'n', keys = "'" },
      { mode = 'n', keys = '`' },
      { mode = 'x', keys = "'" },
      { mode = 'x', keys = '`' },

      -- Registers
      { mode = 'n', keys = '"' },
      { mode = 'x', keys = '"' },
      { mode = 'i', keys = '<C-r>' },
      { mode = 'c', keys = '<C-r>' },

      -- Window commands
      { mode = 'n', keys = '<C-w>' },

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
    },
  })
end
