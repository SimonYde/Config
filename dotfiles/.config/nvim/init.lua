vim.loader.enable()

if vim.env.PROF then require('snacks.profiler').startup({ startup = { event = 'UIEnter' } }) end

local Load = {}

local MiniDeps = require('mini.deps')
MiniDeps.setup({ silent = true })

---@param f function function that will be ensured to not emit error if failed.
Load.now = function(f) MiniDeps.now(f) end

---Lazy load function. Meant to run expensive functions (such as plugin setup) when Neovim has already loaded.
---@param f function function that will be called once Neovim has fully opened.
Load.later = function(f) MiniDeps.later(f) end

---@param package_name string package to load
Load.packadd = function(package_name)
    Load.now(function() vim.cmd('packadd ' .. package_name) end)
end

local defer_group = vim.api.nvim_create_augroup('DeferFunction', {})

---@param callback function function that will be called once event fires
---@param params { pattern: string?, events: string[] | string } table of event types, with an optional pattern
Load.on_events = function(params, callback)
    local opts = {
        group = defer_group,
        once = true,
        callback = function(_) Load.now(callback) end,
    }
    if params.pattern then opts.pattern = params.pattern end
    vim.api.nvim_create_autocmd(params.events, opts)
end

_G.Load = Load -- export module
_G.Config = {}

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


Load.later(function ()
    require('jujutsu').setup()
end)
