local M = {}

M.setup = function()
    _G.Load = M
    local _setup_lazy_loading = function()
        local function _load()
            vim.schedule(function()
                if vim.v.exiting ~= vim.NIL then
                    return
                end
                vim.g.did_lazy_load = true
                vim.api.nvim_exec_autocmds("User", {
                    pattern = "LazyLoad",
                    modeline = false,
                })
            end)
        end

        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyDone",
            once = true,
            callback = function()
                if vim.v.vim_did_enter == 1 then
                    _load()
                else
                    vim.api.nvim_create_autocmd("UIEnter", {
                        once = true,
                        callback = function()
                            _load()
                        end
                    })
                end
            end,
        })
    end
    _setup_lazy_loading()
end

---Nil pcall of function. Intended for loading modules that may not be installed.
---@param func_to_load function
---@param ... any
---@return any | nil
M.now = function(func_to_load, ...)
    local ok, err = pcall(func_to_load, ...)
    if not ok then
        return nil
    end
    return err
end

---Lazy load function. Meant to run expensive (setup) functions when Neovim has already loaded.
---@param func_to_lazy_load function
M.later = function(func_to_lazy_load)
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        once = true,
        callback = function()
            M.now(func_to_lazy_load)
        end
    })
end

M.once = function(func_to_load)
    vim.g.has_loaded = false
    local result = nil
    return function(...)
        if vim.g.has_loaded then return result end
        vim.g.has_loaded = true
        result = M.now(func_to_load, ...)
        return result
    end
end

M.perform_lazy_loading = function()
    vim.api.nvim_exec_autocmds("User", {
        pattern = "LazyDone",
        modeline = false,
    })
end


return M
