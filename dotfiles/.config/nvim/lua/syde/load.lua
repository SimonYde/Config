local M = {}
local U = {}

---@alias FileType "file"|"directory"|"link"
---@param path string
---@param fn fun(path: string, name:string, type:FileType):boolean?
U.ls = function(path, fn)
    local handle = vim.uv.fs_scandir(path)
    while handle do
        local name, t = vim.uv.fs_scandir_next(handle)
        if not name then
            break
        end

        local fname = path .. "/" .. name

        -- HACK: type is not always returned due to a bug in luv,
        -- so fecth it with fs_stat instead when needed.
        -- see https://github.com/folke/lazy.nvim/issues/306
        if fn(fname, name, t or vim.uv.fs_stat(fname).type) == false then
            break
        end
    end
end

---@param path string
---@param fn fun(path: string, name:string, type:FileType)
U.walk = function(path, fn)
    U.ls(path, function(child, name, type)
        if type == "directory" then
            U.walk(child, fn)
        end
        fn(child, name, type)
    end)
end

---@param ... string
M.source_runtime = function(...)
    local dir = table.concat({ ... }, "/")
    ---@type string[]
    local files = {}
    Util.walk(dir, function(path, name, t)
        local ext = name:sub(-3)
        name = name:sub(1, -5)
        if (t == "file" or t == "link") and (ext == "lua" or ext == "vim") and not M.disabled_rtp_plugins[name] then
            files[#files + 1] = path
        end
    end)
    -- plugin files are sourced alphabetically per directory
    table.sort(files)
    for _, path in ipairs(files) do
        M.source(path)
    end
end

M.source = function(path)
    Load.now(function()
        vim.cmd("source " .. path)
    end)
end

M.setup = function()
    _G.Load = M -- export module
    _G.Util = U -- export module
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
