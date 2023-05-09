local nvim_lsp = require('lspconfig')



-- Cmp Setup
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Language setup
servers = {"texlab", "pylsp", "nil_ls", "rust_analyzer", "metals"}
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        capabilities = capabilities,
    }
end
