local autopairs = vim.F.npcall(require, 'nvim-autopairs')
if autopairs then
    autopairs.setup {}
    return
end

local minipairs = vim.F.npcall(require, 'mini.pairs')
if minipairs then
    minipairs.setup {}
    return
end
