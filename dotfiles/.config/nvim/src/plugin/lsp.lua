Load.later(function()
    local lspconfig = require('lspconfig')

    Load.now(function()
        require('neodev').setup()
    end)

    -- Cmp Setup
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp = Load.now(require, 'cmp_nvim_lsp')
    if cmp_nvim_lsp then
        default_capabilities = cmp_nvim_lsp.default_capabilities(default_capabilities)
    end

    ---@param LSP { name: string, cmd: string?, settings: table?, on_attach: function?, filetypes: string[]?, capabilities: table? }
    local function setup_lsp(LSP)
        if not (vim.fn.executable(LSP.cmd or LSP.name) == 1) then
            return -- LSP not installed
        end
        local config = {}
        local extra_capabilities = LSP.capabilities or {}
        config.capabilities = vim.tbl_deep_extend('force', default_capabilities, extra_capabilities)
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
        name = "metals",
        filetypes = { "java", "scala", "sbt" },
    }

    setup_lsp {
        name = "pylsp",
        settings = {
            pylsp = {
                plugins = {
                    -- black = { enabled = true },
                    mypy = { enabled = true },
                    ruff = { enabled = true },
                },
            },
        },
    }

    setup_lsp {
        name = "bashls",
        cmd = "bash-language-server",
        filetypes = { "bash", "sh" },
    }

    setup_lsp {
        name = "ruby_ls",
        cmd = "ruby-lsp",
    }

    setup_lsp {
        name = "gleam",
    }

    setup_lsp {
        name = "gopls",
    }

    setup_lsp {
        name = "ocamllsp",
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
        on_attach = function(_, bufnr)
            local nmap = function(keys, cmd, desc)
                Keymap.nmap(keys, cmd, desc, { buffer = bufnr })
            end
            nmap(
                "<leader>lp",
                function()
                    local file = vim.fn.expand("%")
                    local pdf = file:gsub("%.typ$", ".pdf")
                    vim.system({ "xdg-open", pdf })
                end,
                "open [p]df"
            )
            nmap(
                "<leader>lw",
                function()
                    -- local main_file = vim.fs.find("main.typ", { path = vim.fn.getcwd(), type = "file" })[1]
                    local main_file = vim.fn.expand("%")
                    local path = vim.uri_from_fname(main_file)
                    if main_file ~= nil then
                        vim.lsp.buf.execute_command({
                            command = "typst-lsp.doPinMain",
                            arguments = { path }
                        })
                        vim.notify("Pinned to " .. path, vim.log.levels.INFO)
                        local pdf = main_file:gsub("%.typ$", ".pdf")
                        vim.system({ "xdg-open", pdf })
                    else
                        vim.notify("Did not find a main file to pin at " .. vim.fn.getcwd(), vim.log.levels.ERROR)
                    end
                end,
                "Pin main file to current, run typst [w]atch"
            )
        end
    }

    setup_lsp({
        name = "tinymist",
        settings = {
            exportPdf = "onSave", -- Choose `onType`, `onSave` or `never`.
        },
        on_attach = function(_, bufnr)
            local nmap = function(keys, cmd, desc)
                Keymap.nmap(keys, cmd, desc, { buffer = bufnr })
            end
            nmap(
                "<leader>lp",
                function()
                    local file = vim.fn.expand("%")
                    local pdf = file:gsub("%.typ$", ".pdf")
                    vim.system({ "xdg-open", pdf })
                end,
                "open [p]df"
            )
            nmap(
                "<leader>lw",
                function()
                    local main_file = vim.api.nvim_buf_get_name(bufnr)
                    vim.lsp.buf.execute_command({ command = 'tinymist.pinMain', arguments = { main_file } })
                    vim.notify("Pinned to " .. main_file, vim.log.levels.INFO)
                    local pdf = main_file:gsub("%.typ$", ".pdf")
                    vim.system({ "xdg-open", pdf })
                end,
                "Pin main file to current"
            )
        end
    })


    setup_lsp {
        name = "ltex",
        cmd = "ltex-ls",
        settings = {
            ltex = {
                -- language = "en-GB",
            },
        },
        on_attach = function()
            Load.now(function()
                require('ltex_extra').setup {
                    load_langs = { "en-GB", "da-DK" },
                    init_check = true,
                    path = vim.fn.stdpath("data") .. "/ltex",
                    log_level = "HINT",
                }
            end)
        end,
        filetypes = {
            "typst",
            "latex",
            "tex",
            "markdown",
        }
    }

    setup_lsp({
        name = "clangd",
    })


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

    Load.now(function()
        local border = "none"
        -- if vim.g.transparent then border = "rounded" end

        require('lsp_signature').setup({
            doc_lines = 0,
            hint_enable = false,
            hint_inline = function() return false end, -- should the hint be inline(nvim 0.10 only)?  default false
            handler_opts = {
                border = border
            },
        })
    end)

    Load.now(function()
        local settings = {
            symbol_in_winbar = {
                enable = false,
            },
            code_action = {
                show_server_name = true,
            },
            lightbulb = {
                enable = false,
            },
            implement = {
                enable = true,
            },
            ui = {
                border = 'none'
            }
        }

        if pcall(require, 'catppuccin') then
            settings.ui.kind = require('catppuccin.groups.integrations.lsp_saga').custom_kind()
        end

        require('lspsaga').setup(settings)
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

            local nmap = function(keys, cmd, desc)
                Keymap.nmap(keys, cmd, desc, { buffer = args.buf })
            end

            local imap = function(keys, cmd, desc)
                Keymap.imap(keys, cmd, desc, { buffer = args.buf })
            end
            -- LSP commands
            nmap("<leader>r", vim.lsp.buf.rename, "Rename")
            nmap("<leader>e", vim.lsp.buf.hover, "hover documentation")
            nmap("<leader>a", vim.lsp.buf.code_action, "code actions")
            nmap("<C-e>", vim.diagnostic.open_float, "hover [d]iagnostics")
            imap("<C-s>", vim.lsp.buf.signature_help, "Signature Help")

            Load.now(function()
                require('lspsaga')
                nmap(
                    "<leader>e",
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

    Load.now(function()
        local otter = require('otter')
        otter.setup {
            lsp = {
                diagnostic_update_events = { "BufWritePost" },
                root_dir = function(_) return vim.fn.getcwd(0) end,
            },
            buffers = {
                set_filetype = false,
                -- write <path>.otter.<embedded language extension> files to
                -- disk on save of main buffer.
                -- useful for some linters that require actual files
                -- otter files are deleted on quit or main buffer close
                write_to_disk = false,
            },
            strip_wrapping_quote_characters = { "'", '"', "`" },
            -- otter may not work the way you expect when entire code blocks are indented (eg. in Org files)
            -- When true, otter handles these cases fully.
            handle_leading_whitespace = true,
        }
        local nmap = Keymap.nmap
        nmap("<leader>lo", function() otter.activate() end, "Otter activate")
    end)

    vim.cmd [[LspStart]]
end)
