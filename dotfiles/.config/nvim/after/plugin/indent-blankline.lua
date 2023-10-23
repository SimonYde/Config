-- require('indent_blankline').setup {
--   char = '▏',
--   show_trailing_blankline_indent = false,
-- }

local ibl = vim.F.npcall(require, 'ibl')
if not ibl then
  return
end


ibl.setup {
  indent = {
    char = '▏',
  },
  scope = {
    enabled = false,
  },
}
