local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

require('telescope').setup {
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
  },
  defaults = {
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
    file_ignore_patterns = {
      "__pycache__/",
      "target",
      "node_modules",
      "undodir",
    },
    prompt_prefix = " ",
    layout_config = {
      prompt_position = 'top',
      horizontal = {
        height = 0.9,
        width = 0.9,
      },
    },
    sorting_strategy = 'ascending',
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,    -- override the file sorter
      case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
    }
  }
}

require('telescope').load_extension('fzf')
require("telescope").load_extension("git_worktree")


local function map(mode, keys, cmd, desc) vim.keymap.set(mode, keys, cmd, { desc = desc }) end
local function nmap(keys, cmd, desc) map("n", keys, cmd, desc) end
local telescope = require('telescope.builtin')
nmap("<leader>?", telescope.keymaps, "Look up keymaps")
nmap("<leader>b", telescope.buffers, "Buffers")
nmap("<leader>fc", telescope.current_buffer_fuzzy_find, "Current buffer search")
nmap("<leader>ff", telescope.find_files, "Files")
nmap("<leader>F", telescope.git_files, "Git files")
nmap("<leader>fh", telescope.help_tags, "Help tags")
nmap("<leader>fs", telescope.live_grep, "Search with grep")
nmap("<leader>gw", "<cmd>Telescope git_worktree git_worktrees<CR>", "[g]it [w]orktrees")
