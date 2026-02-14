vim.loader.enable()

local Load = {}

local ok, MiniMisc = pcall(require, 'mini.misc')

if ok then
    Load.now = function(func) MiniMisc.safely('now', func) end

    ---Lazy load function. Meant to run expensive functions (such as plugin setup) when Neovim has already loaded.
    Load.later = function(func) MiniMisc.safely('later', func) end

    MiniMisc.setup()

    Load.on_events = function(event, f)
        MiniMisc.safely(event, f)
    end
else
    Load.now = pcall
    Load.later = pcall
    Load.on_events = function(event, f)
        vim.print("didn't successfully run on event")
    end
end

---@param package_name string package to load
Load.packadd = function(package_name)
    Load.now(function() vim.cmd('packadd ' .. package_name) end)
end

--- Used for when a plugin should be loaded given nvim is started like `nvim -- /path/to/file`.
Load.now_if_args = vim.fn.argc(-1) > 0 and Load.now or Load.later

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
-- vim.g.loaded_matchparen = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_fzf = 1
