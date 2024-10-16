local source = function(path) dofile(Config.path_source .. path) end

source('load.lua')
source('options.lua')
source('remap.lua')
source('colorscheme.lua')

source('plugin/mini.lua')
source('plugin/treesitter.lua')
source('plugin/completion.lua')
source('plugin/conform.lua')
source('plugin/lsp.lua')

local nmap = Keymap.nmap
local imap = Keymap.imap

Load.later(function()
    require("todo-comments").setup()
end)

Load.later(function()
    Load.packadd('trouble.nvim')
    require('trouble').setup()

    nmap(
        '<leader>td',
        function()
            vim.cmd("Trouble diagnostics toggle")
        end,
        "Toggle [t]rouble [d]iagnostics"
    )
end)

Load.on_events(function()
    require('nvim-autopairs').setup()
    require('cmp').event:on(
        'confirm_done',
        require('nvim-autopairs.completion.cmp').on_confirm_done()
    )
end, "InsertEnter")

Load.later(function()
    Load.packadd('indent-blankline.nvim')
    local ibl = require('ibl')
    ibl.setup {
        indent = {
            char = '▏',
        },
        scope = {
            enabled = false,
        },
    }
    return ibl
end)

Load.later(function()
    Load.packadd('render-markdown.nvim')
    require('render-markdown').setup({
        callout = {
            definition = { raw = '[!definition]', rendered = ' Definition', highlight = 'RenderMarkdownInfo' },
            theorem = { raw = '[!theorem]', rendered = '󰨸 Theorem', highlight = 'RenderMarkdownHint' },
            proof = { raw = '[!proof]', rendered = '󰌶 Proof', highlight = 'RenderMarkdownWarn' },
        }
    })
end)

Load.later(function()
    Load.packadd('diffview.nvim')
    local diffview = require('diffview')
    diffview.setup()
    nmap("<leader>gd", function() diffview.open() end, "git [d]iffview")
end)

Load.later(function()
    local neogit = require('neogit')
    neogit.setup({
        integrations = {
            diffview = true,
            telescope = true,
            mini_pick = true,
        },
    })
    nmap("<leader>gs", function() neogit.open() end, "Neogit [s]tatus")
    nmap("<leader>gw", function() neogit.open({ "worktree" }) end, "Neogit [w]orktree")
    nmap("<leader>gc", function() neogit.open({ "commit" }) end, "Neogit [c]ommit")
end)

Load.later(function()
    local telescope = require('telescope')
    -- Clone the default Telescope configuration
    local vimgrep_arguments = { unpack(require("telescope.config").values.vimgrep_arguments) }

    table.insert(vimgrep_arguments, "--hidden")   -- I want to search in hidden/dot files.
    table.insert(vimgrep_arguments, "--glob")
    table.insert(vimgrep_arguments, "!**/.git/*") -- I don't want to search in the `.git` directory.

    local actions = require("telescope.actions")
    local themes = require("telescope.themes")

    local previewers = require("telescope.previewers")
    local putils = require("telescope.previewers.utils")
    local pfiletype = require("plenary.filetype")

    local new_maker = function(filepath, bufnr, opts)
        opts = opts or {}
        if opts.use_ft_detect == nil then
            local ft = pfiletype.detect(filepath)
            -- Here for example you can say: if ft == "xyz" then this_regex_highlighing else nothing end
            if ft == "sh" or ft == "text" then
                putils.regex_highlighter(bufnr, ft)
                opts.use_ft_detect = false
            end
        end
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end

    require("telescope").setup {
        defaults = {
            buffer_previewer_maker = new_maker,
        }
    }

    vim.g.telescope_preview = {
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

    vim.g.telescope_no_preview = {
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
            buffer_previewer_maker = new_maker,
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

    Load.now(function()
        telescope.load_extension('projects')
        nmap("<leader>fp", function() telescope.extensions.projects.projects() end, "Find [p]rojects")
    end)
    Load.now(function() telescope.load_extension('fzf') end)
    Load.now(function()
        telescope.load_extension('git_worktree')
        nmap("<leader>gw", function() telescope.extensions.git_worktree.git_worktrees() end, "git [w]orktrees")
    end)
    Load.now(function() telescope.load_extension('ui-select') end)

    local builtin = require('telescope.builtin')
    local preview = vim.g.telescope_preview
    local no_preview = vim.g.telescope_no_preview
    nmap("<leader>?", builtin.keymaps, "Search keymaps")
    nmap("<leader>b", function() builtin.buffers(preview) end, "[b]uffers")
    nmap("<leader>fc", function() builtin.current_buffer_fuzzy_find(no_preview) end, "fuzzy [c]urrent buffer search")
    nmap("<leader>ff", function() builtin.find_files(preview) end, "find [f]iles")
    nmap("<leader>fh", function() builtin.help_tags(preview) end, "fuzzy search [h]elp tags")
    nmap("<leader>fg", function() builtin.live_grep(preview) end, "file search with [g]rep")
    nmap("<leader>fb", function() builtin.builtin(preview) end, "See [b]uiltin telescope pickers")
    nmap("<leader>fs", function() builtin.lsp_document_symbols(preview) end, "LSP document [s]ymbols")
    nmap("<leader>fw", function() builtin.lsp_dynamic_workspace_symbols(preview) end, "LSP workspace [s]ymbols")
    nmap("<leader>/", function() builtin.live_grep(preview) end, "Global search with grep")
    nmap("<leader>'", function() builtin.resume() end, "Resume last picker")
    nmap("gr", function() builtin.lsp_references(preview) end, "Goto [r]eferences (telescope)")
    nmap("gi", function() builtin.lsp_implementations(preview) end, "Goto [i]mplementations (telescope)")
    nmap("gd", function() builtin.lsp_definitions(preview) end, "Goto [d]efinitions (telescope)")
end)

Load.later(function()
    local whichkey = require('which-key')
    whichkey.setup {
        disable = {
            buftypes = { "nofile", "prompt", "quickfix", "terminal" }, -- nofile is for `cmdwin`. see `:h cmdwin`
        },
        triggers = {
            { "<auto>", mode = "nixsotc" },
            { "s",      mode = { "n", "v" } },
            { "S",      mode = { "n", "v" } },
        },
    }
    whichkey.add {
        { "<leader>w", proxy = "<c-w>",   group = "windows" }, -- proxy to window mappings
        { "<leader>d", group = "Debug" },
        { "<leader>f", group = "Find" },
        { "<leader>v", group = "Visits" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "Lsp" },
        { "<leader>o", group = "Obsidian" },
    }
end)

Load.later(function()
    require('copilot').setup {
        suggestion = {
            keymap = {
                accept = "<M-l>",
                next = "<M-j>",
                prev = "<M-k>",
            },
            auto_trigger = false,
        },
    }
end)

Load.later(function()
    require('lsp_signature').setup({
        doc_lines = 0,
        hint_enable = false,
        hint_inline = function() return false end, -- should the hint be inline(nvim 0.10 only)?  default false
        handler_opts = {
            border = "none"
        },
    })
end)

Load.later(function()
    require('neodev').setup()
end)

Load.later(function()
    local otter = require('otter')
    otter.setup {
        lsp = {
            diagnostic_update_events = { "BufWritePost" },
            root_dir = function(_) return vim.fn.getcwd(0) end,
        },
        buffers = {
            set_filetype = false,
            -- write <path>.otter.<embedded language extension> files to
            -- disk on save of main buffer.
            -- useful for some linters that require actual files
            -- otter files are deleted on quit or main buffer close
            write_to_disk = false,
        },
        strip_wrapping_quote_characters = { "'", '"', "`" },
        -- otter may not work the way you expect when entire code blocks are indented (eg. in Org files)
        -- When true, otter handles these cases fully.
        handle_leading_whitespace = true,
    }
    nmap("<leader>lo", function() otter.activate() end, "Otter activate")
end)

Load.later(function()
    require('lspsaga').setup({
        symbol_in_winbar = {
            enable = false,
        },
        code_action = {
            show_server_name = true,
        },
        lightbulb = {
            enable = false,
        },
        implement = {
            enable = true,
        },
        ui = {
            border = 'none'
        }
    })
end)

Load.later(function()
    local dap, dapui = require("dap"), require("dapui")
    local widgets = require('dap.ui.widgets')
    dapui.setup()
    dap.listeners.before.attach.dapui_config = function()
        dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
    end

    nmap("<leader>db", dap.toggle_breakpoint, "toggle [b]reakpoint")
    nmap("<leader>dc", dap.continue, "[c]ontinue")
    nmap("<leader>di", dap.step_into, "step [i]nto")
    nmap("<leader>do", dap.step_over, "step [o]ver")
    nmap("<leader>dO", dap.step_out, "step [O]ut")
    nmap("<leader>dr", dap.repl.open, "open [r]epl")
    nmap("<leader>dl", dap.run_last, "run [l]ast")
    nmap("<leader>dh", widgets.hover, "show [h]over")
    nmap("<leader>dp", widgets.preview, "show [p]review")
    nmap("<leader>df", function() widgets.centered_float(widgets.frames) end, "[f]rames")
    nmap("<leader>ds", function() widgets.centered_float(widgets.scopes) end, "[s]copes")
    nmap("<leader>du", dapui.toggle, "toggle [u]i")
end)

Load.later(function()
    require('dap-go').setup()
end)

Load.later(function()
    require('dap-python').setup(PYTHON_PATH) -- PYTHON_PATH set by nix
end)

Load.later(function()
    require('obsidian').setup {
        ui = {
            enable = false,
        },
        workspaces = {
            {
                name = "Apollo",
                path = "~/Obsidian/Apollo",
            },
        },
        new_notes_location = "current_dir", -- NOTE: or "notes_subdir"
        completion = {
            nvim_cmp = true,
            min_chars = 2,
        },
        templates = {
            subdir = "templates",
            date_format = "%Y-%m-%d-%a",
            time_format = "%H:%M",
        },
        daily_notes = {
            -- Optional, if you keep daily notes in a separate directory.
            folder = "reviews/Daily Notes",
            -- Optional, if you want to change the date format for the ID of daily notes.
            date_format = "%Y-%m-%d",
            -- Optional, if you want to change the date format of the default alias of daily notes.
            alias_format = "%B %-d, %Y",
            -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
            template = "templates/daily.md",
        },

        use_advanced_uri = true,
        disable_frontmatter = true,
        follow_url_func = function(url) vim.ui.open(url) end,
        follow_img_func = function(img) vim.fn.jobstart({ "xdg-open", img }) end,

        attachments = {
            img_folder = "attachments",
        },
    }

    nmap("<leader>oo", vim.cmd.ObsidianOpen, "Open current file in Obsidian")
    nmap("<leader>od", vim.cmd.ObsidianDailies, "Open [d]aily note search")
    nmap("<leader>on", vim.cmd.ObsidianTemplate, "Insert Obsidian template")
    nmap("<leader>ot", vim.cmd.ObsidianTags, "Open tag list")
    imap("<C-l>", vim.cmd.ObsidianToggleCheckbox, "Toggle markdown checkbox")
end)
