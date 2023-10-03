local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

require('telescope').setup {
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
  defaults = {
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
    file_ignore_patterns = {
      "__pycache__/",
      "target",
      "node_modules",
      "undodir",
    },
    prompt_prefix = " ",
    layout_config = {
      prompt_position = 'top',
      horizontal = {
        height = 0.9,
        width = 0.9,
      },
    },
    sorting_strategy = 'ascending',
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
    }
  }
}

require('telescope').load_extension('fzf')
require("telescope").load_extension("git_worktree")

-- local colors = require("catppuccin.palettes").get_palette()
-- local TelescopeColor = {
--   TelescopeMatching      = { fg = colors.flamingo },
--   TelescopeSelection     = { fg = colors.text, bg = colors.surface0, bold = true },
--   TelescopePromptNormal  = { bg = colors.surface0 },
--   TelescopePromptPrefix  = { bg = colors.surface0 },
--   TelescopeResultsNormal = { bg = colors.mantle },
--   TelescopePreviewNormal = { bg = colors.mantle },
--   TelescopePromptBorder  = { bg = colors.surface0, fg = colors.surface0 },
--   TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
--   TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
--   TelescopePromptTitle   = { bg = colors.pink, fg = colors.mantle },
--   TelescopeResultsTitle  = { fg = colors.mantle },
--   TelescopePreviewTitle  = { bg = colors.green, fg = colors.mantle },
-- }
--
-- for hl, col in pairs(TelescopeColor) do
--   vim.api.nvim_set_hl(0, hl, col)
-- end
