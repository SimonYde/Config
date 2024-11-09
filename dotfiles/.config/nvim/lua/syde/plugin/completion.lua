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
