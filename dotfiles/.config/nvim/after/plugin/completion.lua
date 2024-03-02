-- vim.api.nvim_create_autocmd("InsertEnter", {
--     callback = function()
local cmp = vim.F.npcall(require, "cmp")
if cmp then
    local luasnip = require("luasnip")
    require('luasnip.loaders.from_vscode').lazy_load() -- load friendly-snippets into luasnip
    luasnip.config.setup {}

    cmp.setup {
        sources = {
            { name = 'nvim_lsp_signature_help' },
            { name = "nvim_lua" },
            { name = "nvim_lsp" },
            { name = "path" },
            { name = "luasnip" },
            { name = "buffer",  keyword_length = 5 },
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert {
            ['<C-n>'] = cmp.mapping(function()
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    cmp.complete()
                end
            end),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<C-Space>'] = cmp.mapping.complete {}, -- does not work on windows
            -- ["<CR>"] = cmp.mapping.confirm {
            --     behavior = cmp.ConfirmBehavior.Replace,
            --     select = false,
            -- },
            ['<C-y>'] = cmp.mapping.confirm {
                select = true,
            },
            ["<Tab>"] = cmp.mapping(function()
                if luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                end
            end, { "i", "s" }),

            ["<S-Tab>"] = cmp.mapping(function()
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                end
            end, { "i", "s" }),
        },
    }

    local lspkind = vim.F.npcall(require, "lspkind")
    if lspkind then
        lspkind.init()
        cmp.setup {
            formatting = {
                format = lspkind.cmp_format {
                    with_text = true,
                    menu = {
                        buffer = "[buf]",
                        nvim_lsp = "[LSP]",
                        nvim_lua = "[api]",
                        path = "[path]",
                        luasnip = "[snip]",
                    },
                },
            },
        }
    end


    cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        completion = { autocomplete = false },
        sources = {
            { name = 'buffer' }
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
            }
        }
    })
    return
end

local MiniCompletion = vim.F.npcall(require, "mini.completion")
if MiniCompletion then
    MiniCompletion.setup {}
    return
end
--     end
-- })
