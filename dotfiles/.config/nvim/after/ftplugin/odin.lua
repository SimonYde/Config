vim.api.nvim_create_user_command('Odin', function(cmd)
    cmd = vim.list_extend(vim.list_extend({ 'odin' }, cmd.fargs), { '-terse-errors' })

    local command_res = vim.system(cmd):wait()

    if command_res.code == 0 and command_res.stdout ~= nil then
        print(command_res.stdout)
        vim.fn.setqflist({})
        vim.cmd([[ cwindow ]])
        return
    end

    if command_res.stderr == nil then
        vim.fn.setqflist({})
        vim.cmd([[ cwindow ]])
        return
    end

    local err_lines = vim.split(command_res.stderr, '\n', { plain = true, trimempty = true })

    vim.fn.setqflist({}, 'r', {
        efm = [[%f(%l:%c)\ %m]],
        lines = err_lines,
    })
end, { nargs = '+' })
