local lazy = require('syde.lazy')
lazy.lazy_load(function()
    local lspconfig = vim.F.npcall(require, 'lspconfig')
    if not lspconfig then
        return
    end

    local neodev = vim.F.npcall(require, 'neodev')
    if neodev then
        neodev.setup {}
    end

    -- Cmp Setup
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp = vim.F.npcall(require, 'cmp_nvim_lsp')
    if cmp_nvim_lsp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    local nmap = require('syde.keymap').nmap

    local function setup_lsp(LSP)
        local config = {}
        config.capabilities = capabilities

        if LSP.settings then
            config.settings = LSP.settings
        end

        if LSP.on_attach then
            config.on_attach = LSP.on_attach
        end

        if LSP.filetypes then
            config.filetypes = LSP.filetypes
        end

        lspconfig[LSP.name].setup(config)
    end

    setup_lsp {
        name = "elmls",
        cmd = "elm-language-server",
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
        cmd = "ruby-lsp",
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
        name = "lua_ls",
        cmd = "lua-language-server",
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        '${3rd}/luv/library',
                        vim.env.VIMRUNTIME,
                    },
                },
                telemetry = { enable = false },
                completion = {
                    callSnippet = 'Replace',
                },
            }
        }
    }

    setup_lsp {
        name = "texlab",
        settings = {
            texlab = {
                build = {
                    cmd = 'tectonic',
                    args = {
                        "-X",
                        "compile",
                        "%f",
                        "--synctex",
                        "--keep-logs",
                        "--keep-intermediates",
                        "--outdir build"
                    },
                    onSave = true,
                    forwardSearchAfter = true,
                },
                forwardSearch = {
                    cmd = "zathura",
                    args = {
                        "--synctex-forward",
                        "%l:%c:%f",
                        "%p",
                    },
                },
            },
        },
    }

    setup_lsp {
        name = "nil_ls",
        cmd = "nil",
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
        cmd = "typst-lsp",
        settings = {
            exportPdf = "onSave", -- Choose `onType`, `onSave` or `never`.
        },
        on_attach = function(_)
            nmap("<leader>sp", function()
                local file = vim.fn.expand("%")
                local pdf = file:gsub("%.typ$", ".pdf")
                vim.system({ "zathura", pdf })
            end, "open pdf")
        end
    }


    setup_lsp {
        name = "ltex",
        cmd = "ltex-ls",
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
    }

    local copilot = vim.F.npcall(require, 'copilot')
    if copilot then
        copilot.setup {
            suggestion = {
                auto_trigger = true,
            },
        }
    end

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
                                pattern = "moon",
                                period = 1,
                            },
                        },
                    },
                    notification = {
                        window = {
                            winblend = 0,
                            relative = "editor",
                        },
                    }
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
                nmap("<leader>k", "<cmd>Lspsaga hover_doc<cr>", "hover documentation")
                nmap("K", "<cmd>Lspsaga hover_doc<cr>", "hover documentation")
                nmap("<leader>n", "<cmd>Lspsaga hover_doc<cr>", "hover documentation")
                nmap("<leader>a", "<cmd>Lspsaga code_action<cr>", "code [a]ctions")
                nmap("<leader>r", "<cmd>Lspsaga rename<cr>", "LSP [r]ename")
            end
        end,
    })
end)
