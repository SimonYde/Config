local whichkey = vim.F.npcall(require, "which-key")
if whichkey then
    whichkey.setup {}
    whichkey.register {
        ["<leader>"] = {
            f = { name = "[f]ind" },
            g = { name = "[g]it" },
        },
    }
    local presets = require("which-key.plugins.presets")
    -- presets.text_objects = true
    presets.operators["v"] = nil
    return
end

local MiniClue = vim.F.npcall(require, 'mini.clue')
if MiniClue then
    MiniClue.setup {
        window = {
            config = { anchor = 'SE', row = 'auto', col = 'auto', width = 'auto' },
            delay = vim.o.timeoutlen,
        },
        triggers = {
            -- Leader triggers
            { mode = 'n', keys = '<Leader>' },
            { mode = 'x', keys = '<Leader>' },
            { mode = 'n', keys = '[' },
            { mode = 'n', keys = ']' },
            { mode = 'v', keys = '[' },
            { mode = 'v', keys = ']' },

            -- Built-in completion
            { mode = 'i', keys = '<C-x>' },

            -- `g` key
            { mode = 'n', keys = 'g' },
            { mode = 'x', keys = 'g' },

            -- Marks
            { mode = 'n', keys = "'" },
            { mode = 'n', keys = '`' },
            { mode = 'x', keys = "'" },
            { mode = 'x', keys = '`' },

            -- Registers
            { mode = 'n', keys = '"' },
            { mode = 'x', keys = '"' },
            { mode = 'i', keys = '<C-r>' },
            { mode = 'c', keys = '<C-r>' },

            -- Window commands
            { mode = 'n', keys = '<C-w>' },
            { mode = 'n', keys = '<leader>w' },

            -- `z` key
            { mode = 'n', keys = 'z' },
            { mode = 'x', keys = 'z' },
        },

        clues = {
            -- Enhance this by adding descriptions for <Leader> mapping groups
            { mode = 'n', keys = '<leader>f', desc = '[f]ind' },
            { mode = 'n', keys = '<leader>g', desc = '[g]it' },
            MiniClue.gen_clues.builtin_completion(),
            MiniClue.gen_clues.g(),
            MiniClue.gen_clues.marks(),
            MiniClue.gen_clues.registers(),
            MiniClue.gen_clues.windows(),
            MiniClue.gen_clues.z(),
        },
    }
    return
end
