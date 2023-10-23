local M = {}

M.map = function(mode, keys, cmd, desc) vim.keymap.set(mode, keys, cmd, { desc = desc }) end
M.nmap = function(keys, cmd, desc) M.map("n", keys, cmd, desc) end
M.imap = function(keys, cmd, desc) M.map("i", keys, cmd, desc) end
M.vmap = function(keys, cmd, desc) M.map("v", keys, cmd, desc) end
M.xmap = function(keys, cmd, desc) M.map("x", keys, cmd, desc) end
M.tmap = function(keys, cmd, desc) M.map("t", keys, cmd, desc) end

return M
