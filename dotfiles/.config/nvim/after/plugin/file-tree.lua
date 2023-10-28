local has_nvimtree, nvim_tree = pcall(require, "nvim-tree")
local nmap = require("syde.keymap").nmap

if has_nvimtree then
  nvim_tree.setup {
    disable_netrw = true,
    sort_by = "case_sensitive",
    view = {
      width = 30,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = false,
    },
    git = {
      ignore = false,
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
  }
  nmap("<M-f>", vim.cmd.NvimTreeToggle, "Toggle file tree")
  nmap("<M-F>", vim.cmd.NvimTreeFindFileToggle, "Toggle file tree")
else
  local MiniFiles = vim.F.npcall(require, 'mini.files')
  if not MiniFiles then return end

  MiniFiles.setup {
    mappings = {
      -- reveal_cwd  = '~', -- ?
    },
  }
  nmap('<M-f>', '<cmd>lua MiniFiles.open()<CR>', "Show [f]ile-tree")
  nmap('<M-F>', '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', "Show current [F]ile in file-tree")
end
