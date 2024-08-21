Load.later(function()
    if not os.getenv("XDG_CURRENT_DESKTOP") then
        return
    end

    vim.cmd [[packadd indent-blankline.nvim]]
    local ibl = Load.now(function()
        local ibl = require('ibl')
        ibl.setup {
            indent = {
                char = '▏',
            },
            scope = {
                enabled = false,
            },
        }
        return ibl
    end)
    if ibl then return end

    Load.now(function()
        local indentscope = require('mini.indentscope')
        indentscope.setup {
            symbol = '▏',
            draw = {
                delay = 0,
                animation = indentscope.gen_animation.none(),
            },
        }
    end)
end)
