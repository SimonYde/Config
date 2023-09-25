require('lualine').setup {
  options = {
    theme = "catppuccin",
    icons_enabled = true,
    -- component_separators = {left = '', right = ''},
    -- section_separators = { left = '', right = ''},
    -- component_separators = {left = '', right = ''},
    -- section_separators = { left = '', right = ''},
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'filename', 'diagnostics'},
    lualine_x = {--[[ 'fileformat', ]] 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
}


