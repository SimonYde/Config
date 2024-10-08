Load.now(function()
    local MiniStatusline = require('mini.statusline')
    local section_macro_recording = function()
        local recording_register = vim.fn.reg_recording()

        if recording_register == "" then
            return ""
        else
            return ("rec @%s"):format(recording_register)
        end
    end

    local diagnostic_level = function(level)
        local n = #vim.diagnostic.get(0, { severity = level })
        local sign = vim.diagnostic.config().signs.text[level]
        return (n == 0) and '' or ('%s %s'):format(sign, n)
    end

    local section_fileinfo = function(args)
        local get_filesize = function()
            local size = vim.fn.getfsize(vim.fn.getreg('%'))
            if size < 1024 then
                return ('%dB'):format(size)
            elseif size < 1048576 then
                return ('%.2fKiB'):format(size / 1024)
            else
                return ('%.2fMiB'):format(size / 1048576)
            end
        end

        local get_filetype_icon = function()
            if not MiniStatusline.config.use_icons then return '' end
            local MiniIcons = Load.now(require, 'mini.icons')
            -- NOTE: Make sure setup is called
            local file_name = vim.fn.expand('%:t')
            local icon, _, is_default = MiniIcons.get('file', file_name)
            if is_default then return '' end

            return icon
        end
        local filetype = vim.bo.filetype

        -- Don't show anything if can't detect file type or not inside a "normal buffer"
        if (filetype == '') or vim.bo.buftype ~= '' then return '' end

        -- Add filetype icon
        local icon = get_filetype_icon()
        if icon ~= '' then filetype = ('%s %s'):format(icon, filetype) end

        -- Construct output string if truncated
        if MiniStatusline.is_truncated(args.trunc_width) then return filetype end

        -- Construct output string with extra file info
        local encoding = vim.bo.fileencoding or vim.bo.encoding
        if encoding == 'utf-8' then encoding = '' else encoding = ('[%s]'):format(encoding) end

        local format = vim.bo.fileformat
        local format_icon = ''
        if format == 'unix' then
            format_icon = ''
        elseif format == 'dos' then
            format_icon = ''
        end

        local size = get_filesize()

        return ('%s %s%s %s'):format(filetype, format_icon, encoding, size)
    end


    MiniStatusline.setup({
        content = {
            active = function()
                local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
                local git           = MiniStatusline.section_git({ trunc_width = 75 })
                local diff          = MiniStatusline.section_diff({ trunc_width = 75 })
                local errors        = diagnostic_level(vim.diagnostic.severity.ERROR) -- alternative symbol "⬤ "
                local warnings      = diagnostic_level(vim.diagnostic.severity.WARN)  -- alternative symbol ""
                local info          = diagnostic_level(vim.diagnostic.severity.INFO)
                local hints         = diagnostic_level(vim.diagnostic.severity.HINT)
                local macro         = section_macro_recording()
                local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
                local searchcount   = MiniStatusline.section_searchcount({ trunc_width = 75 })
                local fileinfo      = section_fileinfo({ trunc_width = 120 })
                local location      = MiniStatusline.section_location({ trunc_width = 75 })
                -- local lsp           = MiniStatusline.section_lsp({ trunc_width = 60 })

                return MiniStatusline.combine_groups({
                    { hl = mode_hl,                 strings = { mode } },
                    { hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
                    '%<', -- Mark general truncate point
                    { hl = 'MiniStatuslineFilename', strings = { filename } },
                    { hl = 'DiagnosticError',        strings = { errors } },
                    { hl = 'DiagnosticWarn',         strings = { warnings } },
                    { hl = 'DiagnosticHint',         strings = { hints } },
                    { hl = 'DiagnosticInfo',         strings = { info } },
                    '%=', -- End left alignment
                    --
                    { hl = 'MiniStatuslineFilename', strings = { macro, searchcount } },
                    { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
                    { hl = mode_hl,                  strings = { location } },
                })
            end,
        },
        set_vim_settings = false,
    })
    -- local group = vim.api.nvim_create_augroup("StatusLineCmdLine", { clear = true })
    -- vim.api.nvim_create_autocmd("CmdlineEnter", {
    --     group = group,
    --     callback = function()
    --         vim.opt.cmdheight = 1
    --     end
    -- })
    -- vim.api.nvim_create_autocmd("CmdlineLeave", {
    --     group = group,
    --     callback = function()
    --         vim.opt.cmdheight = 0
    --     end
    -- })
end)
