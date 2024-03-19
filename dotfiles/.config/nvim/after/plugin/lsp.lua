Load.later(function()
    local lspconfig = require('lspconfig')
    local nmap = require('syde.keymap').nmap

    Load.now(function()
        require('neodev').setup {}
    end)

    -- Cmp Setup
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp = Load.now(require, 'cmp_nvim_lsp')
    if cmp_nvim_lsp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    ---@param LSP { name: string, cmd: string?, settings: table?, on_attach: function?, filetypes: string[]? }
    local function setup_lsp(LSP)
        if not (vim.fn.executable(LSP.cmd or LSP.name) == 1) then
            return -- LSP not installed
        end
        local config = {}
        config.capabilities = capabilities
        if LSP.settings then config.settings = LSP.settings end
        if LSP.on_attach then config.on_attach = LSP.on_attach end
        if LSP.filetypes then config.filetypes = LSP.filetypes end

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
                        "compile",
                        "%f",
                        -- "--synctex",
                        -- "--keep-logs",
                        -- "--keep-intermediates",
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
            exportPdf = "never", -- Choose `onType`, `onSave` or `never`.
        },
        on_attach = function()
            nmap(
                "<leader>lp",
                function()
                    local file = vim.fn.expand("%")
                    local pdf = file:gsub("%.typ$", ".pdf")
                    vim.system({ "zathura", pdf })
                end,
                "open [p]df"
            )
            nmap(
                "<leader>lw",
                function()
                    -- local main_file = vim.fs.find("main.typ", { path = vim.fn.getcwd(), type = "file" })[1]
                    local main_file = vim.fn.expand("%")
                    if main_file ~= nil then
                        vim.lsp.buf.execute_command({
                            command = "typst-lsp.doPinMain",
                            arguments = { vim.uri_from_fname(main_file) }
                        })
                        vim.notify("Pinned to " .. vim.uri_from_fname(main_file), vim.log.levels.INFO)
                    else
                        vim.notify("Did not find a main file to pin at " .. vim.fn.getcwd(), vim.log.levels.ERROR)
                    end
                    vim.cmd [[TypstWatch]]
                    vim.notify("Watching for changes in: " .. vim.uri_from_fname(main_file), vim.log.levels.INFO)
                end,
                "typst [w]atch"
            )
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
        on_attach = function()
            Load.now(function()
                require('ltex_extra').setup {
                    load_langs = { "en-US", "en-GB", "da-DK" },
                    init_check = true,
                    path = vim.fn.stdpath("data") .. "/ltex",
                    log_level = "none",
                }
            end)
        end
    }

    Load.now(function()
        require('copilot').setup {
            suggestion = {
                keymap = {
                    accept = "<M-l>",
                    next = "<M-j>",
                    prev = "<M-k>",
                },
                auto_trigger = false,
            },
        }
    end)

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then
                client.server_capabilities.semanticTokensProvider = nil
            end
            Load.now(function()
                require('fidget').setup {
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
            end)
            Load.now(function()
                local settings = {
                    symbol_in_winbar = {
                        enable = false,
                    },
                    code_action_prompt = {
                        enable = false,
                    },
                }

                if pcall(require, 'catppuccin') then
                    settings.ui = {
                        kind = require('catppuccin.groups.integrations.lsp_saga').custom_kind(),
                    }
                end

                require('lspsaga').setup(settings)

                nmap(
                    "<leader>k",
                    function() vim.cmd.Lspsaga("hover_doc") end,
                    "hover documentation"
                )
                nmap(
                    "K",
                    function() vim.cmd.Lspsaga("hover_doc") end,
                    "hover documentation"
                )
                nmap(
                    "<leader>n",
                    function() vim.cmd.Lspsaga("hover_doc") end,
                    "hover documentation"
                )
                nmap(
                    "<leader>a",
                    function() vim.cmd.Lspsaga("code_action") end,
                    "code [a]ctions"
                )
                nmap(
                    "<leader>r",
                    function() vim.cmd.Lspsaga("rename") end,
                    "LSP [r]ename"
                )
            end)
        end,
    })
end)
