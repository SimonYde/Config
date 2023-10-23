local lualine = vim.F.npcall(require, 'lualine')

if not lualine then
  return
end

lualine.setup {
  options = {
    theme = "auto",
    icons_enabled = true,
    globalstatus = true,
    -- component_separators = {left = '', right = ''},
    -- section_separators = { left = '', right = ''},
    -- component_separators = {left = '', right = ''},
    -- section_separators = { left = '', right = ''},
  },
  disabled_filetypes = {
    statusline = {
      "NvimTree",
      "Undotree",
    },
  },
  ignore_focus = {
    "NvimTree",
    "Undotree",
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff' },
    lualine_c = {
      {
        'filename',
        path = 1,
        shorting_target = 80,
      },
      'diagnostics'
    },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  -- extensions = {
  --   'nvim-tree',
  -- },
}
