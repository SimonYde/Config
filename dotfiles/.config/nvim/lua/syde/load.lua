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

local defer_group = vim.api.nvim_create_augroup('DeferFunction', {})

---@param cb function function that will be called once event fires
---@param events string | table that will be called once event fires
---@param pattern string? that will be called once event fires
M.on_events = function(cb, events, pattern)
    local opts = {
        group = defer_group,
        desc = 'DeferFunction',
        once = true,
        callback = function(ev) Load.now(cb, ev) end,
    }
    if pattern then opts['pattern'] = pattern end
    vim.api.nvim_create_autocmd(events, opts)
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
    local timer, step_delay = vim.loop.new_timer(), 1
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
        timer:start(step_delay, 0, f)
    end)
    timer:start(step_delay, 0, f)
end

H.report_errors = function()
    if #H.cache.exec_errors == 0 then return end
    local error_lines = table.concat(H.cache.exec_errors, '\n\n')
    H.cache.exec_errors = {}
    H.notify('There were errors during two-stage execution:\n\n' .. error_lines, 'ERROR')
end

H.notify = vim.schedule_wrap(function(msg, level)
    if not DEBUG then return end
    level = level or 'INFO'
    if type(msg) == 'table' then msg = table.concat(msg, '\n') end
    vim.notify(string.format('(mini.deps) %s', msg), vim.log.levels[level])
    vim.cmd('redraw')
end)

_G.Load = M -- export module
