require('nvim-treesitter.configs').setup {
  -- parser_install_dir = "~/.local/share/nvim/tree-sitter/",
  -- Plugins
  rainbow = {
    enable = true,
    -- list of languages you want to disable the plugin for
    disable = {},
    -- Which query to use for finding delimiters
    query = 'rainbow-parens',
    -- Highlight the entire buffer all at once
    strategy = require('rainbow-delimiters').strategy.global,
  },

  highlight = {
    enable = true,
    --disable = {"scala"};
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
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
        ["]]"] = "@class.outer",
        ["]o"] = "@loop.*",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[]"] = "@class.outer",
        ["[o"] = "@loop.*",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[["] = "@class.outer",
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

require('treesitter-context').setup {}
