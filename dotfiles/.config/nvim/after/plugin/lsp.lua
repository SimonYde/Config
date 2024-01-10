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

local function setup_lsp(LSP)
    if vim.fn.executable(LSP.executable or LSP.name) == 1 then
        lspconfig[LSP.name].setup {
            capabilities = capabilities,
            settings = LSP.settings or {},
        }
        if LSP.on_attach then
            lspconfig[LSP.name].setup {
                on_attach = LSP.on_attach,
            }
        end
        -- if LSP.filetypes then
        --   lspconfig[LSP.name].setup {
        --     filetypes = LSP.filetypes,
        --   }
        -- end
    end
end

setup_lsp {
    name = "elmls",
    executable = "elm-language-server",
}

setup_lsp {
    name = "pylsp",
    settings = {
        pylsp = {
            plugins = {
                black = { enabled = true },
                mypy  = { enabled = true },
                ruff  = { enabled = true },
            },
        },
    },
}

setup_lsp {
    name = "ruby_ls",
    executable = "ruby-lsp",
}

setup_lsp {
    name = "gopls",
}

setup_lsp {
    name = "ocamllsp",
}

setup_lsp {
    name = "metals",
}

setup_lsp {
    name = "rust_analyzer",
    executable = "rust-analyzer",
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
            },
        },
    },
    on_attach = function(_)
        local rust_tools = vim.F.npcall(require, 'rust-tools')
        if rust_tools then
            rust_tools.setup {}
        end
    end
}

setup_lsp {
    name = "lua_ls",
    executable = "lua-language-server",
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        }
    }
}


setup_lsp {
    name = "texlab",
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

setup_lsp {
    name = "nil_ls",
    executable = "nil",
    settings = {
        ['nil'] = {
            formatting = {
                command = { "nixpkgs-fmt" },
            },
            autoArchive = true,
        },
    }
}

setup_lsp {
    name = "nixd",
}

setup_lsp {
    name = "typst_lsp",
    executable = "typst-lsp",
    settings = {
        exportPdf = "onSave",         -- Choose `onType`, `onSave` or `never`.
    }
}

setup_lsp({
    name = "ltex",
    executable = "ltex-ls",
    settings = {
        ltex = {
            language = "da-DK",
        },
    },
    on_attach = function(_)
        local ltex_extra = vim.F.npcall(require, 'ltex_extra')
        if ltex_extra then
            ltex_extra.setup {
                load_langs = { "en-US", "en-GB", "da-DK" },
                init_check = true,
                path = vim.fn.expand("~") .. "/.local/share/ltex",
                log_level = "none",
            }
        end
    end
})

vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
        local copilot = vim.F.npcall(require, 'copilot')
        if copilot then
            copilot.setup {
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
        if client then
            client.server_capabilities.semanticTokensProvider = nil
        end
        local fidget = vim.F.npcall(require, 'fidget')
        if fidget then
            fidget.setup {
                progress = {
                    display = {
                        progress_icon = {
                            pattern = "moon", period = 1,
                        },
                    },
                },
                notification = {
                    window = {
                        winblend = 0,
                        relative = "editor",
                        -- align = "bottom",
                    },
                }
            }
        end
        local lspsaga = vim.F.npcall(require, 'lspsaga')
        if lspsaga then
            local nmap = require('syde.keymap').nmap
            lspsaga.setup {
                symbol_in_winbar = {
                    enable = true,
                },
                code_action_prompt = {
                    enable = false,
                },
                ui = {
                    kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
                },
            }
            nmap("<leader>k", "<cmd>Lspsaga hover_doc<cr>", "hover documentation")
            nmap("<leader>n", "<cmd>Lspsaga hover_doc<cr>", "hover documentation")
            nmap("<leader>a", "<cmd>Lspsaga code_action<cr>", "code [a]ctions")
            nmap("<leader>r", "<cmd>Lspsaga rename<cr>", "LSP [r]ename")
        end
    end,
})
