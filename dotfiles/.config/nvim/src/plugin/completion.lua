Load.later(function()
    local cmp = Load.now(function()
        local cmp = require('cmp')

        Load.packadd('luasnip')
        local luasnip = require("luasnip")
        require('luasnip.loaders.from_vscode').lazy_load() -- load friendly-snippets into luasnip
        luasnip.config.setup()

        Load.now(function()
            require('codeium').setup()
        end)

        cmp.setup({
            sources = {
                { name = "codeium" },
                { name = "nvim_lua" },
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "luasnip" },
                { name = "buffer",  keyword_length = 5 },
            },
            snippet = {
                expand = function(args) luasnip.lsp_expand(args.body) end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping(function()
                    if cmp.visible() then cmp.select_next_item() else cmp.complete() end
                end),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete {}, -- not working in Alacritty on Windows :/
                -- ["<CR>"] = cmp.mapping.confirm {
                --     behavior = cmp.ConfirmBehavior.Replace,
                --     select = false,
                -- },
                -- ['<C-e>'] = cmp.mapping.abort(),
                ['<C-y>'] = cmp.mapping.confirm {
                    select = true,
                },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            formatting = {
                -- format = function(_, vim_item)
                --     local icon, hl, is_default = Load.now(require, "mini.icons").get("lsp", vim_item.kind)
                --     -- If the icon is not found in mini.icons (is_default is true), use the fallback
                --     if is_default then
                --         hl = "CmpItemKind" .. vim_item.kind
                --     end
                --     vim_item.kind = icon -- .. " " .. vim_item.kind
                --     vim_item.kind_hl_group = hl
                --     return vim_item
                -- end,
                fields = { "kind", "abbr", "menu" }, -- "menu",
            }
        })

        Load.now(function()
            Load.packadd('lspkind-nvim')
            local lspkind = require('lspkind')
            cmp.setup {
                formatting = {
                    format = lspkind.cmp_format {
                        ellipsis_char = '…',
                        show_labelDetails = true,
                        mode = 'symbol',
                        symbol_map = {
                            Codeium = "󰚩",
                        },
                        menu = {
                            buffer = '[buf]',
                            nvim_lsp = '[LSP]',
                            nvim_lua = '[api]',
                            path = '[path]',
                            luasnip = '[snip]',
                            codeium = '[AI]',
                        },
                    },
                },
            }
        end)

        cmp.setup.cmdline({ '/', '?' }, {
            mapping = cmp.mapping.preset.cmdline(),
            completion = { autocomplete = false },
            sources = {
                { name = 'buffer' },
            }
        })


        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            completion = { autocomplete = false },
            sources = cmp.config.sources {
                { name = 'path' },
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { '!', 'w', 'q' }
                    },
                    -- keyword_length = 5,
                },
                { name = 'nvim_lua' },
                { name = 'nvim_lsp' },
            }
        })

        return cmp
    end)
    if cmp then return end

    Load.now(function()
        require('mini.completion').setup({

        })
    end)
end)
