local autopairs = vim.F.npcall(require, "nvim-autopairs")
if autopairs then
  autopairs.setup()
end
