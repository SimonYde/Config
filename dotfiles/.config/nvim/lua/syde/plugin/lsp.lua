Load.later(function()
    local lspconfig = require('lspconfig')

    -- Cmp Setup
    local default_capabilities = vim.lsp.protocol.make_client_capabilities()
    local cmp_nvim_lsp = Load.now(require, 'cmp_nvim_lsp')
    if cmp_nvim_lsp then default_capabilities = cmp_nvim_lsp.default_capabilities(default_capabilities) end

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

    setup_lsp({
        name = 'elmls',
        cmd = 'elm-language-server',
    })

    setup_lsp({
        name = 'metals',
        filetypes = { 'java', 'scala', 'sbt' },
    })

    setup_lsp({
        name = 'pylsp',
        settings = {
            pylsp = {
                plugins = {
                    -- black = { enabled = true },
                    mypy = { enabled = true },
                    ruff = { enabled = true },
                },
            },
        },
    })

    setup_lsp({
        name = 'bashls',
        cmd = 'bash-language-server',
        filetypes = { 'bash', 'sh' },
    })

    setup_lsp({ name = 'clangd' })
    setup_lsp({ name = 'gleam' })
    setup_lsp({
        name = 'nixd',
        settings = {
            nixd = {
                nixpkgs = {
                    expr = 'import <nixpkgs> { }',
                },
                options = {
                    nixos = {
                        expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.perdix.options',
                    },
                    home_manager = {
                        expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations.perdix.options',
                    },
                },
            },
        },
    })
    setup_lsp({ name = 'gopls' })
    setup_lsp({ name = 'ocamllsp' })

    setup_lsp({
        name = 'lua_ls',
        cmd = 'lua-language-server',
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = { 'vim' },
                    -- Don't make workspace diagnostic, as it consumes too much CPU and RAM
                    workspaceDelay = -1,
                },
                workspace = {
                    checkThirdParty = false,
                --     library = {
                --         vim.env.VIMRUNTIME,
                --         -- '${3rd}/luv/library',
                --     },
                    -- Don't analyze code from submodules
                    ignoreSubmodules = true,
                },
                telemetry = { enable = false },
            },
        },
    })

    setup_lsp({
        name = 'texlab',
        settings = {
            texlab = {
                build = {
                    cmd = 'tectonic',
                    args = {
                        '-X',
                        'compile',
                        '%f',
                        -- "--synctex",
                        -- "--keep-logs",
                        -- "--keep-intermediates",
                    },
                    onSave = true,
                    forwardSearchAfter = true,
                },
                forwardSearch = {
                    cmd = 'zathura',
                    args = {
                        '--synctex-forward',
                        '%l:%c:%f',
                        '%p',
                    },
                },
            },
        },
    })

    setup_lsp({
        name = 'nil_ls',
        cmd = 'nil',
    })

    setup_lsp({
        name = 'typst_lsp',
        cmd = 'typst-lsp',
        settings = {
            exportPdf = 'onSave', -- Choose `onType`, `onSave` or `never`.
        },
        on_attach = function(_, bufnr)
            local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = bufnr }) end
            nmap('<leader>lp', function()
                local file = vim.fn.expand('%')
                local pdf = file:gsub('%.typ$', '.pdf')
                vim.system({ 'xdg-open', pdf })
            end, 'open [p]df')
            nmap('<leader>lw', function()
                -- local main_file = vim.fs.find("main.typ", { path = vim.fn.getcwd(), type = "file" })[1]
                local main_file = vim.fn.expand('%')
                local path = vim.uri_from_fname(main_file)
                if main_file ~= nil then
                    vim.lsp.buf.execute_command({
                        command = 'typst-lsp.doPinMain',
                        arguments = { path },
                    })
                    vim.notify('Pinned to ' .. path, vim.log.levels.INFO)
                    local pdf = main_file:gsub('%.typ$', '.pdf')
                    vim.system({ 'xdg-open', pdf })
                else
                    vim.notify('Did not find a main file to pin at ' .. vim.fn.getcwd(), vim.log.levels.ERROR)
                end
            end, 'Pin main file to current, run typst [w]atch')
        end,
    })

    setup_lsp({
        name = 'tinymist',
        settings = {
            exportPdf = 'onSave', -- Choose `onType`, `onSave` or `never`.
        },
        on_attach = function(_, bufnr)
            local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = bufnr }) end
            nmap('<leader>lp', function()
                local file = vim.fn.expand('%')
                local pdf = file:gsub('%.typ$', '.pdf')
                vim.system({ 'xdg-open', pdf })
            end, 'open [p]df')
            nmap('<leader>lw', function()
                local main_file = vim.api.nvim_buf_get_name(bufnr)
                vim.lsp.buf.execute_command({ command = 'tinymist.pinMain', arguments = { main_file } })
                vim.notify('Pinned to ' .. main_file, vim.log.levels.INFO)
                local pdf = main_file:gsub('%.typ$', '.pdf')
                vim.system({ 'xdg-open', pdf })
            end, 'Pin main file to current')
        end,
    })

    setup_lsp({
        name = 'ltex',
        cmd = 'ltex-ls',
        settings = {
            ltex = {
                -- language = "en-GB",
            },
        },
        on_attach = function()
            Load.now(
                function()
                    require('ltex_extra').setup({
                        load_langs = { 'en-GB', 'da-DK' },
                        init_check = true,
                        path = vim.fn.stdpath('data') .. '/ltex',
                        log_level = 'HINT',
                    })
                end
            )
        end,
        filetypes = {
            'typst',
            'latex',
            'tex',
            'markdown',
        },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client then client.server_capabilities.semanticTokensProvider = nil end

            local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = args.buf }) end

            local imap = function(keys, cmd, desc) Keymap.imap(keys, cmd, desc, { buffer = args.buf }) end
            -- LSP commands
            nmap('<leader>r', vim.lsp.buf.rename, 'Rename')
            nmap('<leader>e', vim.lsp.buf.hover, 'hover documentation')
            nmap('<leader>a', vim.lsp.buf.code_action, 'code actions')
            nmap('<C-e>', vim.diagnostic.open_float, 'hover [d]iagnostics')
            imap('<C-s>', vim.lsp.buf.signature_help, 'Signature Help')

            Load.now(function()
                nmap('<leader>e', function() vim.cmd.Lspsaga('hover_doc') end, 'hover documentation')
                nmap('<leader>a', function() vim.cmd.Lspsaga('code_action') end, 'code [a]ctions')
                nmap('<leader>r', function() vim.cmd.Lspsaga('rename') end, 'LSP [r]ename')
            end)
        end,
    })

    vim.defer_fn(function() vim.cmd('LspStart') end, 100)
end)
