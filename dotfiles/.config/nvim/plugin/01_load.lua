local M = {}
local H = {}

-- Various cache
H.cache = {
    -- Whether finish of `now()` or `later()` is already scheduled
    finish_is_scheduled = false,

    -- Callback queue for `later()`
    later_callback_queue = {},

    -- Errors during execution of `now()` or `later()`
    exec_errors = {},
}

---Nil pcall of function. Intended for loading modules that may not be installed.
---@param func_to_load function function that will be ensured to not emit error if failed.
---@param ... any additional arguments to `func_to_load`.
---@return any | nil returns `nil` if calling `func_to_load` fails.
M.now = function(func_to_load, ...)
    local ok, err = pcall(func_to_load, ...)
    if not ok then
        table.insert(H.cache.exec_errors, err)
        return nil
    end
    H.schedule_finish()
    return err
end

---Lazy load function. Meant to run expensive functions (such as plugin setup)
---when Neovim has already loaded.
---@param func_to_lazy_load function function that will be called once Neovim has fully opened.
M.later = function(func_to_lazy_load)
    table.insert(H.cache.later_callback_queue, func_to_lazy_load)
    H.schedule_finish()
end

local defer_group = vim.api.nvim_create_augroup('DeferFunction', {})

---@param callback function function that will be called once event fires
---@param params { pattern: string?, events: string[] | string } table of event types, with an optional pattern
M.on_events = function(params, callback)
    local opts = {
        group = defer_group,
        once = true,
        callback = function(ev) Load.now(callback, ev) end,
    }
    if params.pattern then opts.pattern = params.pattern end
    vim.api.nvim_create_autocmd(params.events, opts)
end

M.packadd = function(package_name)
    Load.now(function() vim.cmd('packadd ' .. package_name) end)
end

-- Two-stage execution --------------------------------------------------------
H.schedule_finish = function()
    if H.cache.finish_is_scheduled then return end
    vim.schedule(H.finish)
    H.cache.finish_is_scheduled = true
end

H.finish = function()
    local timer, step_delay = vim.uv.new_timer(), 1
    local f = nil
    f = vim.schedule_wrap(function()
        local callback = H.cache.later_callback_queue[1]
        if callback == nil then
            H.cache.finish_is_scheduled, H.cache.later_callback_queue = false, {}
            H.report_errors()
            return
        end

        table.remove(H.cache.later_callback_queue, 1)
        M.now(callback)
        timer:start(step_delay, 0, f) ---@diagnostic disable-line: param-type-mismatch is never nil
    end)
    timer:start(step_delay, 0, f)
end

H.report_errors = function()
    if #H.cache.exec_errors == 0 then return end
    local error_lines = table.concat(H.cache.exec_errors, '\n\n')
    H.cache.exec_errors = {}
    H.notify('There were errors during two-stage execution:\n\n' .. error_lines)
end

H.notify = vim.schedule_wrap(function(msg)
    if not DEBUG then return end
    if type(msg) == 'table' then msg = table.concat(msg, '\n') end
    vim.notify(msg)
    vim.cmd('redraw')
end)

_G.Load = M -- export module

-- Disable unused built-in plugins ============================================
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_2html_plugin = 1

vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_fzf = 1
