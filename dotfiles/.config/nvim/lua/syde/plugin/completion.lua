Load.later(function()
    Load.packadd('luasnip')
    local luasnip = require('luasnip')
    require('luasnip.loaders.from_vscode').lazy_load() -- load friendly-snippets into luasnip
    require('luasnip.loaders.from_lua').lazy_load() -- load friendly-snippets into luasnip
    luasnip.config.setup()

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

Load.later(function()
    local cmp = require('cmp')

    local menu_icon = {
        nvim_lsp = '[LSP]',
        lazydev = '[dev]',
        path = '[path]',
        luasnip = '[snip]',
        buffer = '[buf]',
        git = '[git]',
    }

    cmp.setup({
        sources = {
            { name = 'lazydev', group_index = 0 },
            { name = 'git' },
            { name = 'nvim_lsp' },
            { name = 'path' },
            { name = 'luasnip' },
            { name = 'buffer', keyword_length = 5 },
        },
        mapping = cmp.mapping.preset.insert({
            ['<C-n>'] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    cmp.complete()
                end
            end),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-y>'] = cmp.mapping.confirm({
                select = true,
            }),
            ['<Tab>'] = cmp.mapping(function(fallback)
                if require('luasnip').expand_or_locally_jumpable() then
                    require('luasnip').expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),

            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if require('luasnip').jumpable(-1) then
                    require('luasnip').jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        formatting = {
            format = function(entry, vim_item)
                local source = menu_icon[entry.source.name]

                local icon, hl, is_default = MiniIcons.get('lsp', vim_item.kind)
                -- If the icon is not found in mini.icons (is_default is true), use the fallback
                if is_default then hl = 'CmpItemKind' .. vim_item.kind end
                vim_item.kind = icon -- .. " " .. vim_item.kind
                vim_item.kind_hl_group = hl
                vim_item.menu = source
                return vim_item
            end,
            fields = { 'kind', 'abbr', 'menu' },
        },
        experimental = {
            ghost_text = true,
        },
    })

    Load.now(function() require('cmp_git').setup() end)
end)
