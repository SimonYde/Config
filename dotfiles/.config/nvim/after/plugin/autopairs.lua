local autopairs = vim.F.npcall(require, "nvim-autopairs")
if not autopairs then
  return
end

autopairs.setup()
