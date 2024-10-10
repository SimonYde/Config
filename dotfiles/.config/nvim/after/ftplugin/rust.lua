vim.g.rustaceanvim = {
    -- Plugin configuration
    tools = {
    },
    -- LSP configuration
    server = {
        default_settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
                cargo = {
                    allFeatures = true,
                },
                imports = {
                    group = {
                        enable = false,
                    },
                },
            },
        },
    },
    -- DAP configuration
    dap = {
    },
}

local buffer = vim.api.nvim_get_current_buf()
local nmap = function(keys, cmd, desc)
    Keymap.nmap(keys, cmd, desc, { buffer = buffer, silent = true })
end

nmap(
    "<leader>la",
    function()
        vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
    end,
    "RustLsp Code Action"
)

--  https://github.com/mrcjkb/rustaceanvim for more configuration
