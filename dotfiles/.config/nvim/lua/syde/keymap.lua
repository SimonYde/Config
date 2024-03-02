local M = {}


M.map = function(mode)
    return function(keys, cmd, desc, opts)
        if opts then
            opts["desc"] = desc
        else
            opts = { desc = desc }
        end
        vim.keymap.set(mode, keys, cmd, opts)
    end
end

M.nmap = M.map("n")
M.imap = M.map("i")
M.vmap = M.map("v")
M.xmap = M.map("x")
M.tmap = M.map("t")

return M
