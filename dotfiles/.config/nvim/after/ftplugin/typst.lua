vim.cmd('setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab')
vim.cmd('setlocal wrap spell')

Load.now(function()
    local mini_ai = require('mini.ai')

    vim.b.miniai_config = {
        custom_textobjects = {
            ['*'] = mini_ai.gen_spec.pair('*', '*', { type = 'balanced' }),
            ['_'] = mini_ai.gen_spec.pair('_', '_', { type = 'balanced' }),
            ['$'] = mini_ai.gen_spec.pair('$', '$', { type = 'balanced' }),
        },
    }

    local mini_surround = require('mini.surround')
    vim.b.minisurround_config = {
        custom_surroundings = {
            -- Bold
            B = { input = { '%*().-()%*' }, output = { left = '*', right = '*' } },
            -- Math
            m = { input = { '%$().-()%$' }, output = { left = '$', right = '$' } },
            -- Link
            L = {
                input = { '%(.-%)%[().-()%]' },
                output = function()
                    local link = mini_surround.user_input('Link: ')
                    return { left = '#link("' .. link .. '")[', right = ']' }
                end,
            },
        },
    }
end)

Keymap.nmap('<leader>i', function() require('img-clip').paste_image() end, 'Insert image')
