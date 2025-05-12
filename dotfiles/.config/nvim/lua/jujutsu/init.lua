local Jujutsu = {}
local H = {}

---@class Jujutsu
---@field executable? string

---@type Jujutsu
Jujutsu.config = H.default_config

---@param config? Jujutsu
Jujutsu.setup = function(config)
    _G.Jujutsu = Jujutsu

    config = H.setup_config(config)

    H.apply_config(config)

    H.has_jujutsu = vim.fn.executable(config.executable) == 1
    if not H.has_jujutsu then H.notify('There is no `' .. config.executable .. '` executable', 'WARN') end

    H.create_user_commands()
end

---@type Jujutsu
H.default_config = {
    executable = 'jj',
}

H.cache = {}

---@param config? table optional user configuration.
H.setup_config = function(config)
    config = vim.tbl_deep_extend('force', vim.deepcopy(H.default_config), config or {})

    vim.validate('executable', config.executable, 'string')
    return config
end

H.apply_config = function(config) Jujutsu.config = config end

---@param message string message to notify.
H.notify = function(message, log_level) vim.notify('(Jujutsu) ' .. message, log_level) end

H.error = function(message) error('(Jujutsu) ' .. message) end

H.create_user_commands = function()
    local opts = { bang = true, nargs = '*', complete = H.command_complete, desc = 'Execute Jujutsu command' }
    vim.api.nvim_create_user_command('JJ', H.command_impl, opts)
end

H.command_impl = function(input)
    if not H.has_jujutsu then
        return H.notify('There is no `' .. Jujutsu.config.executable .. '` executable', 'ERROR')
    end

    H.run_interactive({ 'jj', 'log' })
    vim.print(input)
end

H.ensure_jj_subcommands = function()
    if H.jj_subcommands ~= nil then return end

    local subcommands = {}

    -- TODO: 2025-05-10 Simon Yde, figure out how to collect these from the command line, or get user aliases.
    -- stylua: ignore
    local supported = {
        'abandon', 'absorb', 'bookmark', 'commit', 'config',
        'describe', 'diff', 'diffedit', 'duplicate', 'edit',
        'evolog', 'file', 'fix', 'git', 'help', 'interdiff',
        'log', 'new', 'next', 'operation', 'parallelize',
        'prev', 'rebase', 'resolve', 'restore', 'revert',
        'root', 'show', 'sign', 'simplify-parents', 'sparse',
        'split', 'squash', 'status', 'tag', 'util', 'undo',
        'unsign', 'version', 'workspace',
    }

    subcommands.supported = supported

    local complete = vim.deepcopy(supported)
    local add_twoword = function(prefix, suffixes)
        if not vim.tbl_contains(supported, prefix) then return end

        for _, suffix in ipairs(suffixes) do
            table.insert(complete, prefix .. ' ' .. suffix)
        end
    end

    add_twoword('bookmark', { 'create', 'delete', 'forget', 'list', 'move', 'set', 'track', 'untrack' })
    add_twoword('config', { 'edit', 'get', 'list', 'set', 'unset' })
    add_twoword('file', { 'annotate', 'chmod', 'files', 'show', 'track', 'untrack' })
    add_twoword('git', { 'clone', 'export', 'fetch', 'import', 'init', 'push', 'remote' })
    subcommands.complete = complete

    local info_commands = {
        'diff',
        'evolog',
        'log',
        'operation',
        'show',
        'status',
        'help',
        'version',
    }
    local info = {}

    for _, cmd in ipairs(info_commands) do
        info[cmd] = true
    end

    subcommands.info = info

    -- Compute commands which aliases rely on
    local alias_data = H.git_cli_output({ 'config', '--get-regexp', 'alias.*' })
    local alias = {}
    for _, l in ipairs(alias_data) do
        -- Assume simple alias of the form `alias.xxx subcommand ...`
        local alias_cmd, cmd = string.match(l, '^alias%.(%S+) (%S+)')
        if vim.tbl_contains(supported, cmd) then alias[alias_cmd] = cmd end
    end

    subcommands.alias = alias

    H.jj_subcommands = subcommands
end

H.cli_output = function(args, cwd, env) end

H.get_jj_cwd = function()
    local buf_id = vim.api.nvim_get_current_buf()
    local names = { '.jj', '.jj' }

    if not vim.api.nvim_buf_is_valid(buf_id) then H.error('Current buffer is invalid') end

    -- Compute directory to start search from.
    -- NOTEs on why not using file path:
    -- - This has better performance because `vim.fs.find()` is called less.
    -- - *Needs* to be a directory for callable `names` to work.
    -- - Later search is done including initial `path` if directory, so this
    --   should work for detecting buffer directory as root.
    local path = vim.api.nvim_buf_get_name(buf_id)
    if path == '' then return end
    local dir_path = vim.fs.dirname(path)

    -- Find root
    local root_file = vim.fs.find(names, { path = dir_path, upward = true })[1]
    local res = nil
    if root_file ~= nil then
        res = vim.fs.dirname(root_file)
    end

    -- Use absolute path to an existing directory
    if type(res) ~= 'string' then return end
    res = H.fs_normalize(vim.fn.fnamemodify(res, ':p'))
    if vim.fn.isdirectory(res) == 0 then return end

    return res
end

H.run_cli = function(args)
    local cmd = { Jujutsu.config.executable }
    vim.list_extend(cmd, args)

    vim.system(cmd, {}, function(out)
        if out.code ~= 0 then H.notify(out.stderr, 'ERROR') end
    end)
end

---@param command table command to run.
H.run_interactive = function(command)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
    vim.api.nvim_set_option_value('modifiable', false, { buf = buf })

    local height, width = math.ceil(vim.o.lines * 0.8), math.ceil(vim.o.columns * 0.8)

    local win = vim.api.nvim_open_win(buf, true, {
        style = 'minimal',
        relative = 'editor',
        width = width,
        height = height,
        row = math.ceil((vim.o.lines - height) / 2),
        col = math.ceil((vim.o.columns - width) / 2),
        border = 'single',
    })

    vim.api.nvim_set_current_win(win)

    vim.fn.jobstart(command, {
        term = true,

        on_exit = function(_, _, _)
            if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
        end,
    })

    vim.cmd.startinsert()
end

H.command_complete = function(_, line, col)
    -- Compute completion base manually to be "at cursor" and respect `\ `
    local base = H.get_complete_base(line:sub(1, col))
    local candidates, _ = H.command_get_complete_candidates(line, col, base)
    return vim.tbl_filter(function(x) return vim.startswith(x, base) end, candidates)
end

H.get_complete_base = function(line)
    local from, _, res = line:find('(%S*)$')
    while from ~= nil do
        local cur_from, _, cur_res = line:sub(1, from - 1):find('(%S*\\ )$')
        if cur_res ~= nil then res = cur_res .. res end
        from = cur_from
    end
    return (res:gsub([[\ ]], ' '))
end

H.command_get_complete_candidates = function(line, col, base)
    H.ensure_jj_subcommands()

    -- Determine current Git subcommand as the earliest present supported one
    local subcmd, subcmd_end = nil, math.huge
    for _, cmd in pairs(H.jj_subcommands.supported) do
        local _, ind = line:find(' ' .. cmd .. ' ', 1, true)
        if ind ~= nil and ind < subcmd_end then
            subcmd, subcmd_end = cmd, ind
        end
    end

    subcmd = subcmd or 'jj'
    local cwd = H.get_git_cwd()

    -- Determine command candidates:
    -- - Command options if complete base starts with "-".
    -- - Paths if after explicit "--".
    -- - Git commands if there is none fully formed yet or cursor is at the end
    --   of the command (to also suggest subcommands).
    -- - Command targets specific for each command (if present).
    if vim.startswith(base, '-') then return H.command_complete_option(subcmd) end
    if subcmd_end == math.huge or (subcmd_end - 1) == col then return H.git_subcommands.complete, 'subcommand' end

    subcmd = H.git_subcommands.alias[subcmd] or subcmd
    local complete_targets = H.command_complete_subcommand_targets[subcmd]
    if complete_targets == nil then return {}, nil end
    return complete_targets(cwd, base, line)
end

return Jujutsu
