Load.later(function()
    local nmap = require('syde.keymap').nmap

    local telescope = Load.now(function()
        local telescope = require('telescope')
        -- Clone the default Telescope configuration
        local vimgrep_arguments = { unpack(require("telescope.config").values.vimgrep_arguments) }

        table.insert(vimgrep_arguments, "--hidden")   -- I want to search in hidden/dot files.
        table.insert(vimgrep_arguments, "--glob")
        table.insert(vimgrep_arguments, "!**/.git/*") -- I don't want to search in the `.git` directory.

        local actions = require("telescope.actions")
        local themes = require("telescope.themes")

        telescope.setup {
            pickers = {
                find_files = {
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                },
                buffers = {
                    mappings = {
                        i = {
                            ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
                        },
                    },
                },
            },
            defaults = {
                mappings = {
                    i = {
                        ["<C-s>"] = actions.select_horizontal,
                    },
                },
                -- `hidden = true` is not supported in text grep commands.
                vimgrep_arguments = vimgrep_arguments,
                file_ignore_patterns = {
                    "__pycache__",
                    "target",
                    "node_modules",
                    "undodir",
                },
                prompt_prefix = "  ",
                layout_config = {
                    prompt_position = 'top',
                    horizontal = {
                        height = 0.9,
                        width = 0.9,
                    },
                    -- preview_width = 0.48,
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
                ["ui-select"] = {
                    themes.get_dropdown { -- even more opts

                    },
                },
            },
        }

        pcall(telescope.load_extension, 'fzf')
        pcall(telescope.load_extension, "git_worktree")
        pcall(telescope.load_extension, "undo")
        pcall(telescope.load_extension, "ui-select")

        local builtin = require('telescope.builtin')
        nmap("<leader>?", builtin.keymaps, "Search keymaps")
        nmap("<leader>b", builtin.buffers, "[b]uffers")
        nmap(
            "<leader>fc",
            function()
                builtin.current_buffer_fuzzy_find({
                    previewer = false,
                })
            end,
            "fuzzy [c]urrent buffer search"
        )
        nmap("<leader>ff", builtin.find_files, "find [f]iles")
        nmap("<leader>F", builtin.git_files, "Git [F]iles")
        nmap("<leader>fh", builtin.help_tags, "fuzzy search [h]elp tags")
        nmap("<leader>fg", builtin.live_grep, "file search with [g]rep")
        nmap("<leader>fs", builtin.lsp_document_symbols, "LSP document [s]ymbols")
        nmap("<leader>fw", builtin.lsp_dynamic_workspace_symbols, "LSP workspace [s]ymbols")
        nmap("<leader>/", builtin.live_grep, "Global search with grep")
        nmap("gr", builtin.lsp_references, "Goto References")
        nmap("gi", builtin.lsp_implementations, "Goto [i]mplementations")
        nmap("gd", builtin.lsp_definitions, "Goto [d]efinitions")

        nmap("<leader>gw", "<cmd>Telescope git_worktree git_worktrees<CR>", "git [w]orktrees")
        return telescope
    end)
    if telescope then return end

    Load.now(function()
        local MiniPick = require('mini.pick')
        local MiniExtra = require('mini.extra')
        MiniExtra.setup {}
        MiniPick.setup {
            mappings = {
                refine = "<C-q>",
                refine_marked = "<M-q>",
            }
        }

        nmap("<leader>?", MiniExtra.pickers.keymaps, "Search keymaps")
        nmap("<leader>b", MiniPick.builtin.buffers, "Pick [b]uffers")
        nmap("<leader>c", function() MiniExtra.pickers.buf_lines { scope = "current" } end,
            "Pick [c]urrent buffer lines")
        nmap("<leader>fc", function() MiniExtra.pickers.buf_lines { scope = "current" } end,
            "Pick [c]urrent buffer lines")
        nmap("<leader>ff", MiniPick.builtin.files, "Pick [f]iles")
        nmap("<leader>F", MiniExtra.pickers.git_files, "Pick git [F]iles")
        nmap("<leader>fh", MiniPick.builtin.help, "Pick [h]elp")
        nmap("<leader>fg", MiniPick.builtin.grep_live, "Pick [g]rep")
        nmap("<leader>fs", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end,
            "LSP document [s]ymbols")
        nmap("<leader>fw", function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end,
            "LSP [w]orkspace symbols")
        nmap("<leader>/", MiniPick.builtin.grep_live, "Global search with grep")
        nmap("gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, "Goto [r]eferences")
        nmap("gi", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, "Goto [i]mplementations")
    end)
end)
