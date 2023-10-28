local lspconfig = vim.F.npcall(require, 'lspconfig')
if not lspconfig then
  return
end

local neodev = vim.F.npcall(require, 'neodev')
if neodev then
  neodev.setup()
end

-- Cmp Setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp = vim.F.npcall(require, 'cmp_nvim_lsp')
if cmp_nvim_lsp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local function setup_lsp(lsp_name, executable, settings, on_attach)
  if vim.fn.executable(executable) == 1 then
    lspconfig[lsp_name].setup {
      capabilities = capabilities,
      settings = settings or {},
    }
    if on_attach then
      lspconfig[lsp_name].setup {
        on_attach = on_attach,
      }
    end
  end
end


-- vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(_)
    setup_lsp("elmls", "elm-language-server")

    setup_lsp("pylsp", "pylsp")

    setup_lsp("gopls", "gopls")

    setup_lsp("ocamllsp", "ocamllsp")
    setup_lsp("metals", "metals")

    setup_lsp("rust_analyzer", "rust-analyzer", {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
      }
    })

    setup_lsp("lua_ls", "lua-language-server", {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
        -- diagnostics = {
        --   globals = {
        --     "vim"
        --   }
        -- },
      }
    })

    setup_lsp("texlab", "texlab", {
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
    })

    setup_lsp("nil_ls", "nil", {
      ['nil'] = {
        formatting = {
          command = { "nixpkgs-fmt" },
        },
        autoArchive = true,
      },
    })

    setup_lsp("typst_lsp", "typst-lsp", {
      exportPdf = "onSave", -- Choose onType, onSave or never.
      -- serverPath = "" -- Normally, there is no need to uncomment it.
    })

    setup_lsp("ltex", "ltex-ls", {
        ltex = {
          language = "da-DK",
        },
      },
      function(_)
        local ltex_extra = vim.F.npcall(require, 'ltex_extra')
        if ltex_extra then
          ltex_extra.setup {
            load_langs = { "en-US", "en-GB", "da-DK" },
            init_check = true,
            path = vim.fn.expand("~") .. "/.local/share/ltex",
            log_level = "none",
          }
        end
      end)

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
    if client then
      client.server_capabilities.semanticTokensProvider = nil
    end
    local fidget = vim.F.npcall(require, 'fidget')
    if fidget then
      fidget.setup {
        text = {
          spinner = "moon",
          -- done = "",
        },
        align = {
          bottom = true,
        },
        window = {
          relative = "editor",
        },
      }
    end
    local lspsaga = vim.F.npcall(require, 'lspsaga')
    if lspsaga then
      local nmap = require('syde.keymap').nmap
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
      nmap("<leader>n", "<cmd>Lspsaga hover_doc<cr>", "hover documentation")
      nmap("<leader>a", "<cmd>Lspsaga code_action<cr>", "code [a]ctions")
      nmap("<leader>r", "<cmd>Lspsaga rename<cr>", "LSP [r]ename")
    end
  end,
})
