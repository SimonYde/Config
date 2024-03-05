local M = {}

-- Heavily inspired by Lazy.nvim by folke

M.lazy_load = function(func_to_lazy_load)
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        once = true,
        callback = function()
            func_to_lazy_load()
        end
    })
end

M.perform_lazy_loading = function()
    vim.api.nvim_exec_autocmds("User", {
        pattern = "LazyDone",
        modeline = false,
    })
end

M.setup_lazy_loading = function()
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

return M
