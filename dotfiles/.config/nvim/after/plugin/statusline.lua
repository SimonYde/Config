local lualine = vim.F.npcall(require, 'lualine')

if lualine then
  lualine.setup {
    options = {
      theme = "auto",
      icons_enabled = true,
      globalstatus = true,
      -- component_separators = { left = '', right = '' },
      -- section_separators = { left = '', right = '' },
      -- section_separators = { left = '', right = '' },
      -- component_separators = { left = '', right = '' }
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { 'branch', 'diff' },
      lualine_c = {
        {
          'filename',
          path = 1,
          shorting_target = 80,
        },
        'diagnostics'
      },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    extensions = {
      'nvim-tree',
      'trouble',
    },
  }
  return
end

local MiniStatusline = vim.F.npcall(require, 'mini.statusline')
if MiniStatusline then
  vim.opt.laststatus = 3 -- global statusline
  vim.opt.cmdheight = 0
  vim.opt.hlsearch = true


  local section_macro_recording = function()
    local recording_register = vim.fn.reg_recording()

    if recording_register == "" then
      return ""
    else
      return ("rec @%s"):format(recording_register)
    end
  end


  local diagnostic_level = function(level, prefix)
    -- if MiniStatusline.is_truncated(75) then return '' end
    local n = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
    return (n == 0) and '' or ('%s%s'):format(prefix, n)
  end

  -- vim.cmd [[ highlight DiagnosticWarnStatusLine  cterm=italic gui=italic guifg=#f9e2af guibg=#181825 ]]
  -- vim.cmd [[ highlight DiagnosticErrorStatusLine cterm=italic gui=italic guifg=#f38ba8 guibg=#181825 ]]
  -- vim.cmd [[ highlight DiagnosticHintStatusLine  cterm=italic gui=italic guifg=#94e2d5 guibg=#181825 ]]
  -- vim.cmd [[ highlight MiniStatuslineModeNormal  cterm=bold gui=bold guifg=#181825 guibg=#b4befe ]]


  MiniStatusline.section_fileinfo = function(args)
    local get_filesize = function()
      local size = vim.fn.getfsize(vim.fn.getreg('%'))
      if size < 1024 then
        return string.format('%dB', size)
      elseif size < 1048576 then
        return string.format('%.2fKiB', size / 1024)
      else
        return string.format('%.2fMiB', size / 1048576)
      end
    end

    local get_filetype_icon = function()
      if not MiniStatusline.config.use_icons then return '' end
      local devicons = vim.F.npcall(require, 'nvim-web-devicons')
      if not devicons then return '' end

      local file_name, file_ext = vim.fn.expand('%:t'), vim.fn.expand('%:e')
      return devicons.get_icon(file_name, file_ext, { default = true })
    end
    local filetype = vim.bo.filetype

    -- Don't show anything if can't detect file type or not inside a "normal buffer"
    if (filetype == '') or vim.bo.buftype ~= '' then return '' end
    if MiniStatusline.is_truncated(args.trunc_width) then return filetype end

    -- Add filetype icon

    local icon = get_filetype_icon()
    if icon ~= '' then filetype = string.format('%s %s', icon, filetype) end

    -- Construct output string if truncated

    -- Construct output string with extra file info
    -- local encoding = vim.bo.fileencoding or vim.bo.encoding
    local format = vim.bo.fileformat
    local format_icon = ''
    if format == 'unix' then
      format_icon = ''
    elseif format == 'dos' then
      format_icon = ''
    end

    local size = get_filesize()

    -- return string.format('%s %s[%s] %s', filetype, encoding, format_icon, size)
    return string.format('%s %s %s', filetype, format_icon, size)
  end


  MiniStatusline.setup {
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git           = MiniStatusline.section_git({ trunc_width = 75 })
        local errors        = diagnostic_level('ERROR', ' ') -- alternative symbol "⬤ "
        local warnings      = diagnostic_level('WARN', ' ') -- alternative symbol ""
        local hints         = diagnostic_level('HINT', ' ')
        local info          = diagnostic_level('INFO', ' ')
        local macro         = section_macro_recording()
        local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
        local searchcount   = MiniStatusline.section_searchcount({ trunc_width = 75 })
        local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location      = MiniStatusline.section_location({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl,                 strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { git } },
          '%<', -- Mark general truncate point
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          { hl = 'DiagnosticError',        strings = { errors } },
          { hl = 'DiagnosticWarn',         strings = { warnings } },
          { hl = 'DiagnosticHint',         strings = { hints } },
          { hl = 'DiagnosticInfo',         strings = { info } },
          '%=', -- End left alignment

          { hl = 'MiniStatuslineFilename', strings = { macro, searchcount } },
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
          { hl = mode_hl,                  strings = { location } },
        })
      end,
    },
    set_vim_settings = false,
  }
  return
end
