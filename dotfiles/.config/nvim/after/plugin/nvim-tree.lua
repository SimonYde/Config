require("nvim-tree").setup({
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
      quit_on_open = false,
    },
  },
})
