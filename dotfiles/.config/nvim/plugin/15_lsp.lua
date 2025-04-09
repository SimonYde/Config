Load.later(function()
    Load.packadd('nvim-lspconfig')

    vim.lsp.config('*', {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        root_markers = { '.git', '.jj', 'flake.nix' },
    })

    vim.g.rustaceanvim = {
        -- LSP configuration
        server = {
            default_settings = {
                -- rust-analyzer language server configuration
                ['rust-analyzer'] = {
                    cargo = {
                        features = 'all',
                    },
                    imports = {
                        group = {
                            enable = false,
                        },
                    },
                },
            },
        },
    }

    vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            -- Disable semantic token highlighting, in favour of treesitter.
            if client then client.server_capabilities.semanticTokensProvider = nil end

            local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = args.buf }) end

            -- LSP commands
            nmap('<leader>ld', vim.lsp.buf.definition, 'definitions')
            nmap('<leader>lr', vim.lsp.buf.references, 'references')
            nmap('<leader>lf', vim.lsp.buf.format, 'LSP format')
            nmap('<leader>la', vim.lsp.buf.code_action, 'code actions')

            nmap('<C-h>', vim.diagnostic.open_float, 'hover diagnostics')

            nmap('<leader>h', function() vim.cmd.Lspsaga('hover_doc') end, 'hover documentation')
            nmap('<leader>a', function() vim.cmd.Lspsaga('code_action') end, 'code actions')
            nmap('<leader>r', function() vim.cmd.Lspsaga('rename') end, 'LSP rename')
        end,
    })

    vim.lsp.enable({
        'basedpyright',
        'bashls',
        'harper_ls',
        'lua_ls',
        'metals',
        'nil_ls',
        'nixd',
        'nushell',
        'ruff',
        'tinymist',
    })
end)
