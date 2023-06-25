require('telescope').setup {
  defaults = {
		file_ignore_patterns = {
			"__pycache__/",
			"target",
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
	}
}

local colors = require("catppuccin.palettes").get_palette()
local TelescopeColor = {
	TelescopeMatching = { fg = colors.flamingo },
	TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

  TelescopePromptNormal  = { bg = colors.surface0 },
  TelescopePromptPrefix  = { bg = colors.surface0 },
  TelescopeResultsNormal = { bg = colors.mantle },
  TelescopePreviewNormal = { bg = colors.mantle },
  TelescopePromptBorder  = { bg = colors.surface0, fg = colors.surface0 },
  TelescopeResultsBorder = { bg = colors.mantle,   fg = colors.mantle },
  TelescopePreviewBorder = { bg = colors.mantle,   fg = colors.mantle },
  TelescopePromptTitle   = { bg = colors.pink, 		 fg = colors.mantle },
  TelescopeResultsTitle  = { fg = colors.mantle },
  TelescopePreviewTitle  = { bg = colors.green,    fg = colors.mantle },
}

for hl, col in pairs(TelescopeColor) do
	vim.api.nvim_set_hl(0, hl, col)
end


