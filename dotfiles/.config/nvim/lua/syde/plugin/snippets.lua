Load.later(function()
    Load.packadd('luasnip')
    local luasnip = require('luasnip')
    require('luasnip.loaders.from_vscode').lazy_load() -- load friendly-snippets into luasnip
    require('luasnip.loaders.from_lua').lazy_load() -- load friendly-snippets into luasnip
    luasnip.config.setup({
        ft_func = require('luasnip.extras.filetype_functions').from_cursor_pos,
    })

    luasnip.filetype_extend('markdown_inline', { 'markdown' })
    luasnip.filetype_extend('latex', { 'tex' })

    vim.snippet.expand = luasnip.lsp_expand

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.snippet.active = function(filter)
        filter = filter or {}
        filter.direction = filter.direction or 1

        if filter.direction == 1 then
            return luasnip.expand_or_jumpable()
        else
            return luasnip.jumpable(filter.direction)
        end
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.snippet.jump = function(direction)
        if direction == 1 then
            if luasnip.expandable() then
                return luasnip.expand_or_jump()
            else
                return luasnip.jumpable(1) and luasnip.jump(1)
            end
        else
            return luasnip.jumpable(-1) and luasnip.jump(-1)
        end
    end

    vim.snippet.stop = luasnip.unlink_current

    local ismap = Keymap.map({ 'i', 's' })
    ismap(
        '<C-i>',
        function() return vim.snippet.active({ direction = 1 }) and vim.snippet.jump(1) end,
        'Snippet forward'
    )

    ismap(
        '<C-m>',
        function() return vim.snippet.active({ direction = -1 }) and vim.snippet.jump(-1) end,
        'snippet backward'
    )
end)
