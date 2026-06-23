vim.loader.enable()

_G.Config = {}

-- Custom autocommands ========================================================
local augroup = vim.api.nvim_create_augroup('CustomSettings', {})

Config.create_autocmd = function(event, pattern, callback, desc)
    local opts = { group = augroup, pattern = pattern, callback = callback, desc = desc }
    vim.api.nvim_create_autocmd(event, opts)
end

local ok, MiniMisc = pcall(require, 'mini.misc')

if not ok then
    vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
    MiniMisc = require('mini.misc')
end

Config.now = function(func) MiniMisc.safely('now', func) end

---Lazy load function. Meant to run expensive functions (such as plugin setup) when Neovim has already loaded.
Config.later = function(func) MiniMisc.safely('later', func) end

Config.on_events = function(event, pattern, f)
    MiniMisc.safely('event:' .. event .. (pattern and ('~' .. pattern) or ''), f)
end

---@param package_name string package to load
Config.packadd = function(package_name)
    Config.now(function() vim.cmd('packadd ' .. package_name) end)
end

--- Used for when a plugin should be loaded given nvim is started like `nvim -- /path/to/file`.
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

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
-- vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_fzf = 1
