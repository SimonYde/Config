local lazy = require('syde.lazy')

lazy.lazy_load(function()
    vim.api.nvim_create_autocmd("InsertEnter", {
        once = true,
        callback = function()
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
        end
    })
end)

