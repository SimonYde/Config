require('nvim-treesitter.configs').setup {
  -- parser_install_dir = "~/.local/share/nvim/tree-sitter/",
  -- Plugins
  rainbow = {
    enable = true,
    -- list of languages you want to disable the plugin for
    disable = { },
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
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

require('treesitter-context').setup{}
