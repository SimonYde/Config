vim.cmd('setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab')
vim.cmd('setlocal wrap spell')

-- Customize 'mini.nvim'
local has_mini_ai, mini_ai = pcall(require, 'mini.ai')
if has_mini_ai then
    vim.b.miniai_config = {
        custom_textobjects = {
            ['*'] = mini_ai.gen_spec.pair('*', '*', { type = 'balanced' }),
            ['_'] = mini_ai.gen_spec.pair('_', '_', { type = 'balanced' }),
            ['$'] = mini_ai.gen_spec.pair('$', '$', { type = 'balanced' }),
        },
    }
end

local has_mini_surround, mini_surround = pcall(require, 'mini.surround')
if has_mini_surround then
    vim.b.minisurround_config = {
        custom_surroundings = {
            -- Bold
            B = { input = { '%*%*().-()%*%*' }, output = { left = '**', right = '**' } },
        },
    }
end
