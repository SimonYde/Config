local nvim_lsp = vim.F.npcall(require, 'lspconfig')
if not nvim_lsp then
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




vim.api.nvim_create_autocmd('VimEnter', {
  callback = function(args)
    -- if vim.fn.executable('elm-language-server') == 1 then
      nvim_lsp.elmls.setup {
        capabilities = capabilities,
      }
    -- end

    -- if vim.fn.executable('pylsp') == 1 then
      nvim_lsp.pylsp.setup {
        capabilities = capabilities,
      }
    -- end

    -- if vim.fn.executable('rust-analyzer') == 1 then
      nvim_lsp.rust_analyzer.setup {
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
    -- end
    -- if vim.fn.executable('gopls') == 1 then
      nvim_lsp.gopls.setup {
        capabilities = capabilities,
      }
    -- end


    -- if vim.fn.executable('ocamllsp') == 1 then
      nvim_lsp.ocamllsp.setup {
        capabilities = capabilities,
      }
    -- end


    -- if vim.fn.executable('lua-language-server') == 1 then
      nvim_lsp.lua_ls.setup {
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
    -- end


    if vim.fn.executable('ltex-ls') == 1 then
      nvim_lsp.ltex.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          require("ltex_extra").setup {
            load_langs = { "en-US", "en-GB", "da-DK" },
            init_check = true,
            path = vim.fn.expand("~") .. "/.local/share/ltex",
            log_level = "none",
          }
        end,
        settings = {
          ltex = {
            language = "da-DK",
          },
        }
      }
    end

    -- if vim.fn.executable('texlab') == 1 then
      nvim_lsp.texlab.setup {
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
    -- end

    -- if vim.fn.executable('nil') == 1 then
      nvim_lsp.nil_ls.setup {
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
    -- end

    if vim.fn.executable('node') == 1 then
      require('copilot').setup {
        suggestion = {
          auto_trigger = true,
        },
      }
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    client.server_capabilities.semanticTokensProvider = nil
    require('fidget').setup {
      window = {
        blend = 0,
      },
    }
    require('lspsaga').setup {
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
  end,
})
