local buffer = vim.api.nvim_get_current_buf()

local nmap = require("syde.keymap").nmap

nmap(
    "<leader>a",
    function()
        vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
        -- or vim.lsp.buf.codeAction() if you don't want grouping.
    end,
    "RustLsp Code Action",
    { silent = true, buffer = buffer }
)

nmap(
    "<leader>k",function()
        vim.lsp.buf.hover()
    end
    ,"RustLsp Hover",
    { silent = true, buffer = buffer }
)

--  https://github.com/mrcjkb/rustaceanvim for more configuration
