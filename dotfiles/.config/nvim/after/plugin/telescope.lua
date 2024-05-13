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

        local preview = {
            show_line = false,
            layout_config = {
                preview_width = 0.55,
                prompt_position = 'top',
                horizontal = {
                    height = 0.9,
                    width = 0.9,
                },
            },
        }

        local no_preview = {
            layout_config = {
                prompt_position = 'top',
                horizontal = {
                    height = 0.9,
                    width = 0.9,
                },
            },
            show_line = false,
            previewer = false,
        }

        -- Dropdown list theme using a builtin theme definitions :
        local dropdown = themes.get_dropdown({
            width = 0.5,
            prompt = " ",
            results_height = 15,
            previewer = false,
        })

        telescope.setup {
            pickers = {
                find_files = {
                    -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
                    find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob", "!**/.git/*" },
                },
                buffers = {
                    mappings = {
                        i = {
                            ["<c-d>"] = actions.delete_buffer --+ actions.move_to_top,
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
                    ".direnv",
                    ".mypy_cache",
                    ".ruff_cache",
                    "node_modules",
                    "undodir",
                },
                prompt_prefix = "  ",
                layout_config = {
                    prompt_position = 'top',
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
                    dropdown
                },
            },
        }

        Load.now(telescope.load_extension, 'projects')
        Load.now(telescope.load_extension, 'fzf')
        Load.now(telescope.load_extension, "git_worktree")
        Load.now(telescope.load_extension, "undo")
        Load.now(telescope.load_extension, "ui-select")

        local builtin = require('telescope.builtin')
        nmap("<leader>?", builtin.keymaps, "Search keymaps")
        nmap("<leader>b", function()
            builtin.buffers(preview)
        end, "[b]uffers")
        nmap("<leader>fc", function() builtin.current_buffer_fuzzy_find(no_preview) end, "fuzzy [c]urrent buffer search")
        nmap("<leader>ff", function() builtin.find_files(preview) end, "find [f]iles")
        nmap("<C-p>", function() builtin.git_files(preview) end, "Git [F]iles")
        nmap("<leader>fh", function() builtin.help_tags(preview) end, "fuzzy search [h]elp tags")
        nmap("<leader>fg", function() builtin.live_grep(preview) end, "file search with [g]rep")
        nmap("<leader>fb", function() builtin.builtin(preview) end, "See [b]uiltin telescope pickers")
        nmap("<leader>fs", function() builtin.lsp_document_symbols(preview) end, "LSP document [s]ymbols")
        nmap("<leader>fw", function() builtin.lsp_dynamic_workspace_symbols(preview) end, "LSP workspace [s]ymbols")
        nmap("<leader>/", function() builtin.live_grep(preview) end, "Global search with grep")
        nmap("gr", function() builtin.lsp_references(preview) end, "Goto [r]eferences (telescope)")
        nmap("gi", function() builtin.lsp_implementations(preview) end, "Goto [i]mplementations (telescope)")
        nmap("gd", function() builtin.lsp_definitions(preview) end, "Goto [d]efinitions (telescope)")

        nmap("<leader>gw", "<cmd>Telescope git_worktree git_worktrees<CR>", "git [w]orktrees")
        nmap("<leader>fp", function() telescope.extensions.projects.projects() end, "Find [p]rojects")
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
        nmap("<leader>fs", function() MiniExtra.pickers.lsp({ scope = "document_symbol" }) end, "LSP document [s]ymbols")
        nmap(
            "<leader>fw",
            function() MiniExtra.pickers.lsp({ scope = "workspace_symbol" }) end,
            "LSP [w]orkspace symbols"
        )
        nmap("<leader>/", MiniPick.builtin.grep_live, "Global search with grep")
        nmap("gr", function() MiniExtra.pickers.lsp({ scope = "references" }) end, "Goto [r]eferences")
        nmap("gi", function() MiniExtra.pickers.lsp({ scope = "implementation" }) end, "Goto [i]mplementations")
        nmap("<leader>gw", function() MiniExtra.pickers.git_branches({ scope = 'local' }) end, "git [w]orktrees")
    end)
end)
