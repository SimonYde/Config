local nvim_lsp = require('lspconfig')


-- Cmp Setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Language setup
local servers = { "elmls", "pylsp", "rust_analyzer", "metals", "ocamllsp", "gopls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
  }
end

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
});

nvim_lsp.lua_ls.setup {
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

if vim.fn.executable('node') == 1 then
  require('copilot').setup {
    suggestion = {
      auto_trigger = true,
    },
  }
end
