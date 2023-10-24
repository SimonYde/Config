local nvim_tree = vim.F.npcall(require, "nvim-tree")
if not nvim_tree then
  return
end

nvim_tree.setup({
  -- disable_netrw = true,
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
})

local nmap = require("syde.keymap").nmap
nmap("<A-f>", vim.cmd.NvimTreeToggle, "Toggle file tree")
nmap("<A-F>", vim.cmd.NvimTreeFindFileToggle, "Toggle file tree")
