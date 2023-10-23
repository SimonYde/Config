local telescope = vim.F.npcall(require, "telescope")
if not telescope then
  return
end

-- Clone the default Telescope configuration
local vimgrep_arguments = require("telescope.config").values.vimgrep_arguments

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup {
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
      "__pycache__",
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
    },
    undo = {
      use_delta = true,
    },
  }
}

telescope.load_extension('fzf')
telescope.load_extension("git_worktree")
telescope.load_extension("undo")


local nmap = require('syde.keymap').nmap
local builtin = require('telescope.builtin')
nmap("<leader>?", builtin.keymaps, "Search keymaps")
nmap("<leader>b", builtin.buffers, "[b]uffers")
nmap("<leader>fc", builtin.current_buffer_fuzzy_find, "[f]uzzy [c]urrent buffer search")
nmap("<leader>ff", builtin.find_files, "[f]ind [f]iles")
nmap("<leader>F", builtin.git_files, "Git [F]iles")
nmap("<leader>fh", builtin.help_tags, "[f]uzzy search [h]elp tags")
nmap("<leader>fs", builtin.live_grep, "[f]ile [s]earch with grep")
nmap("<leader>/", builtin.live_grep, "Global search with grep")

nmap("<leader>gw", "<cmd>Telescope git_worktree git_worktrees<CR>", "[g]it [w]orktrees")
nmap("<leader>u", "<cmd>Telescope undo<CR>", "[u]ndos")
