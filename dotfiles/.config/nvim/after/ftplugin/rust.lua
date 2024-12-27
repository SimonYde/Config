--  https://github.com/mrcjkb/rustaceanvim for more configuration
local buffer = vim.api.nvim_get_current_buf()
local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = buffer }) end

nmap('<leader>la', function()
    vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
end, 'RustLsp Code Action')
