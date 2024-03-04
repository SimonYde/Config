local lazy = require('syde.lazy')
lazy.lazy_load(function()
    local ibl = vim.F.npcall(require, 'ibl')
    if ibl then
        ibl.setup {
            indent = {
                char = '▏',
            },
            scope = {
                enabled = false,
            },
        }
    else
        local indentscope = require('mini.indentscope')
        indentscope.setup {
            symbol = '▏',
            draw = {
                delay = 0,
                animation = indentscope.gen_animation.none(),
            },
        }
    end
end)
