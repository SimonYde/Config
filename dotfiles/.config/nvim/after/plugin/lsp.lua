local lspconfig = vim.F.npcall(require, 'lspconfig')
if not lspconfig then
  return
end


-- Cmp Setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Language setup
-- local servers = {
--   -- "metals",
-- }
-- for _, lsp in ipairs(servers) do
--   nvim_lsp[lsp].setup {
--     capabilities = capabilities,
--   }
-- end


-- vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(_)
    lspconfig.elmls.setup {
      capabilities = capabilities,
    }

    lspconfig.typst_lsp.setup {
      capabilities = capabilities,
    }

    lspconfig.pylsp.setup {
      capabilities = capabilities,
    }

    lspconfig.rust_analyzer.setup {
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
          -- cargo = {
          --   loadOutDirsFromCheck = true,
          -- },
          -- procMacro = {
          --   enable = true,
          -- },
          -- diagnostics = {
          --   disabled = { "unresolved-proc-macro" },
          -- },
        },
      },
    }

    lspconfig.gopls.setup {
      capabilities = capabilities,
    }

    lspconfig.ocamllsp.setup {
      capabilities = capabilities,
    }

    lspconfig.lua_ls.setup {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              "vim"
            }
          },
        }
      }
    }


    if vim.fn.executable('ltex-ls') == 1 then
      lspconfig.ltex.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          local ltex_extra = vim.F.npcall(require, 'ltex_extra')
          if ltex_extra then
            ltex_extra.setup {
              load_langs = { "en-US", "en-GB", "da-DK" },
              init_check = true,
              path = vim.fn.expand("~") .. "/.local/share/ltex",
              log_level = "none",
            }
          end
        end,
        settings = {
          ltex = {
            language = "da-DK",
          },
        }
      }
    end

    lspconfig.texlab.setup {
      capabilities = capabilities,
      settings = {
        texlab = {
          build = {
            executable = 'tectonic',
            args = {
              "-X",
              "compile",
              "%f",
              "--synctex",
              "--keep-logs",
              "--keep-intermediates",
            },
            onSave = true,
            forwardSearchAfter = true,
          },
          -- forwardSearch = {
          -- executable = "zathura",
          -- args = {
          --   "--synctex-forward",
          --   "%l:%c:%f",
          --   "%p",
          -- },
          -- },
        },
      }
    }

    lspconfig.nil_ls.setup {
      capabilities = capabilities,
      settings = {
        ['nil'] = {
          formatting = {
            command = { "nixpkgs-fmt" },
          },
          autoArchive = true,
        },
      }
    }

    if vim.fn.executable('node') == 1 then
      local copilot = vim.F.npcall(require, 'copilot')
      if copilot then
        copilot.setup {
          suggestion = {
            auto_trigger = true,
          },
        }
      end
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
    local fidget = vim.F.npcall(require, 'fidget')
    if fidget then
      fidget.setup {
        window = {
          blend = 0,
        },
      }
    end
    local lspsaga = vim.F.npcall(require, 'lspsaga')
    if lspsaga then
      lspsaga.setup {
        symbol_in_winbar = {
          enable = false,
        },
        code_action_prompt = {
          enable = false,
        },
        ui = {
          kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
        },
      }
    end
  end,
})
