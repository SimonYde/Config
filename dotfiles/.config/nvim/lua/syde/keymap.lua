local M = {}

---@param mode string | table
M.map = function(mode)
    ---@param desc string
    ---@param keys string
    ---@param cmd function|string
    ---@param opts? table
    return function(keys, cmd, desc, opts)
        opts = opts or {}
        opts.desc = desc
        vim.keymap.set(mode, keys, cmd, opts)
    end
end

M.nmap = M.map("n")
--- Insert mode remap
M.imap = M.map("i")
--- Visual and select mode remap
M.vmap = M.map("v")
--- Select mode remap
M.smap = M.map("s")
--- Visual mode remap
M.xmap = M.map("x")
--- Terminal mode remap
M.tmap = M.map("t")

return M
