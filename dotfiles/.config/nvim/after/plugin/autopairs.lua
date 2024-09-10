Load.on_events(function()
    local autopairs = Load.now(function()
        local autopairs = require('nvim-autopairs')
        autopairs.setup {}
        Load.now(function()
            require('cmp').event:on(
                'confirm_done',
                require('nvim-autopairs.completion.cmp').on_confirm_done()
            )
        end)
        return autopairs
    end)

    if autopairs then return end

    Load.now(function()
        require('mini.pairs').setup {}
    end)
end, "InsertEnter")
