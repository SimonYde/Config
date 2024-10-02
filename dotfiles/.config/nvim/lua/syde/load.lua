local M = {}

M.setup = function()
    _G.Load = M -- export module
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
---@param func_to_load function function that will be ensured to not emit error if failed.
---@param ... any additional arguments to `func_to_load`.
---@return any | nil returns `nil` if calling `func_to_load` fails.
M.now = function(func_to_load, ...)
    local ok, success = pcall(func_to_load, ...)
    if not ok then
        return nil
    end
    return success
end

---Lazy load function. Meant to run expensive functions (such as plugin setup)
---when Neovim has already loaded.
---@param func_to_lazy_load function function that will be called once Neovim has fully opened.
---@param ... any additional arguments to `func_to_lazy_load`.
--- NOTE: Unlike `Load.now` this does not return the module if successful due
--- to `autocmd` being used, despite it being used internally.
M.later = function(func_to_lazy_load, ...)
    local arguments = ...
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        once = true,
        callback = function()
            M.now(func_to_lazy_load, arguments)
        end
    })
end

M.once = function(func_to_load)
    local has_loaded = false
    local result = nil
    return function(...)
        if has_loaded then return result end
        has_loaded = true
        result = M.now(func_to_load, ...)
        return result
    end
end

local defer_group = vim.api.nvim_create_augroup("DeferFunction", {})

M.on_events = function(cb, events, pattern)
    local opts = {
        group = defer_group,
        desc = "DeferFunction",
        once = true,
        callback = function(ev) cb(ev) end,
    }
    if pattern then opts["pattern"] = pattern end
    vim.api.nvim_create_autocmd(events, opts)
end

M.perform_lazy_loading = function()
    vim.api.nvim_exec_autocmds("User", {
        pattern = "LazyDone",
        modeline = false,
    })
end

return M
