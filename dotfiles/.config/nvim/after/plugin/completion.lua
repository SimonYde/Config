local cmp = vim.F.npcall(require, "cmp")
if cmp then
  local luasnip = require("luasnip")
  -- require('luasnip.loaders.from_vscode').lazy_load()
  luasnip.config.setup {}

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  cmp.setup {
    sources = {
      { name = "nvim_lua" },
      { name = "nvim_lsp" },
      -- { name = 'nvim_lsp_signature_help' },
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
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-Space>'] = cmp.mapping.complete {},
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },

      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
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
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      {
        name = 'cmdline',
        option = {
          ignore_cmds = { '!', 'w', 'q' }
        },
        keyword_length = 5,
      }
    })
  })
else
  local MiniCompletion = vim.F.npcall(require, "mini.completion")
  if MiniCompletion then
    MiniCompletion.setup {}
  end
end
