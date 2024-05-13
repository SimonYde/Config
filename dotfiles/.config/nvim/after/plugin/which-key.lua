Load.later(function()
    local whichkey = Load.now(function()
        local whichkey = require('which-key')
        local presets = require('which-key.plugins.presets')
        presets.operators['v'] = nil
        whichkey.setup {
            disable = {
                buftypes = { "nofile", "prompt", "quickfix", "terminal" }, -- nofile is for `cmdwin`. see `:h cmdwin`
            }
        }
        whichkey.register {
            ['<leader>'] = {
                d = { name = '[d]ebug' },
                f = { name = '[f]ind' },
                g = { name = '[g]it' },
                o = { name = '[o]bsidian' },
                l = { name = '[l]sp' },
            },
        }
        return whichkey
    end)
    if whichkey then return end

    Load.now(function()
        local MiniClue = require('mini.clue')
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
                { mode = 'n', keys = '<leader>o', desc = '[o]bsidian' },
                { mode = 'n', keys = '<leader>l', desc = '[l]sp' },
                { mode = 'n', keys = '<leader>d', desc = '[d]ebug' },
                MiniClue.gen_clues.builtin_completion(),
                MiniClue.gen_clues.g(),
                MiniClue.gen_clues.marks(),
                MiniClue.gen_clues.registers(),
                MiniClue.gen_clues.windows(),
                MiniClue.gen_clues.z(),
            },
        }
    end)
end)
