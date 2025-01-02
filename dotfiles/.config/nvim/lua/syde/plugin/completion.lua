Load.later(function()
    require('blink.compat').setup({
        impersonate_nvim_cmp = false,
    })
    package.loaded['nvim-cmp'] = package.loaded['blink.compat']
end)

Load.later(function()
    require('blink.cmp').setup({
        keymap = {
            preset = 'default',
            ['<C-e>'] = {},
        },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',
        },
        signature = { enabled = true },
        fuzzy = {
            prebuilt_binaries = {
                force_version = '',
            },
        },
        snippets = {
            expand = function(snippet)
                local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
                insert({ body = snippet })
            end,
        },
        completion = {
            ghost_text = {
                enabled = false,
            },
        },
        sources = {
            default = {
                'lazydev',
                'lsp',
                'path',
                'obsidian',
                'obsidian_new',
                'obsidian_tags',

                'snippets',
                'buffer',
            },
            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    -- make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
                obsidian = {
                    name = 'obsidian',
                    module = 'blink.compat.source',
                },
                obsidian_new = {
                    name = 'obsidian_new',
                    module = 'blink.compat.source',
                },
                obsidian_tags = {
                    name = 'obsidian_tags',
                    module = 'blink.compat.source',
                },
            },
        },
    })
end)
