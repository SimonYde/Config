local M = {}

M.map = function(mode)
    return function(keys, cmd, desc, opts)
        opts = opts or {}
        opts.desc = desc
        vim.keymap.set(mode, keys, cmd, opts)
    end
end

M.nmap = M.map("n")
M.imap = M.map("i")
M.vmap = M.map("v")
M.xmap = M.map("x")
M.tmap = M.map("t")

return M
