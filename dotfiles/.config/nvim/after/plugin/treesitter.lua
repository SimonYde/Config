local ts = vim.F.npcall(require, 'nvim-treesitter.configs')
if not ts then
  return
end


local rainbow_delimiters = vim.F.npcall(require, 'rainbow-delimiters')
if rainbow_delimiters then
  ts.setup {
    rainbow = {
      enable = true,
      -- list of languages you want to disable the plugin for
      disable = {},
      -- Which query to use for finding delimiters
      query = 'rainbow-parens',
      -- Highlight the entire buffer all at once
      strategy = rainbow_delimiters.strategy.global,
    },
  }
end


ts.setup {
  -- parser_install_dir = "~/.local/share/nvim/tree-sitter/",
  -- Plugins
  highlight = {
    enable = true,
    disable = { "latex" },
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]["] = "@class.outer",
        ["]o"] = "@loop.*",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[["] = "@class.outer",
        ["[o"] = "@loop.*",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      goto_next = {
        ["]i"] = "@conditional.inner",
      },
      goto_previous = {
        ["[i"] = "@conditional.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>s"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>S"] = "@parameter.inner",
      },
    },
  },
}

local context = vim.F.npcall(require, 'treesitter-context')
if context then
  context.setup {}
end
