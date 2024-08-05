Load.later(function()
    require('obsidian').setup {
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

        attachments = {
            img_folder = "attachments",
        },
    }

    local nmap = require("syde.keymap").nmap
    local imap = require("syde.keymap").imap

    nmap("<leader>oo", vim.cmd.ObsidianOpen, "Open current file in Obsidian")
    nmap("<leader>od", vim.cmd.ObsidianDailies, "Open [d]aily note search")
    nmap("<leader>on", vim.cmd.ObsidianTemplate, "Insert Obsidian template")
    nmap("<leader>ot", vim.cmd.ObsidianTags, "Open tag list")
    imap("<C-l>", vim.cmd.ObsidianToggleCheckbox, "Toggle markdown checkbox")
end)
