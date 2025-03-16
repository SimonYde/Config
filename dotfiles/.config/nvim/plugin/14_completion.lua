Load.later(function()
    Load.packadd('blink.cmp')

    require('blink.cmp').setup({
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'normal',
        },

        signature = { enabled = true },

        snippets = {
            expand = function(snippet)
                local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
                insert({ body = snippet })
            end,
        },

        sources = {
            default = {
                'lsp',
                'path',

                'snippets',
                'buffer',
            },

            per_filetype = {
                lua = {
                    'lazydev',
                    'lsp',
                    'path',
                    'snippets',
                    'buffer',
                },
            },

            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    -- Make lazydev completions top priority (see `:h blink.cmp`)
                    score_offset = 100,
                },
            },
        },
    })
end)
