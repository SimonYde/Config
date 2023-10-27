local has_mini, starter = pcall(require, 'mini.starter')
if not has_mini then
  return
end

local nmap = require('syde.keymap').nmap

require('mini.ai').setup {}
require('mini.align').setup {}
require('mini.bracketed').setup {}
require('mini.comment').setup {}
require('mini.pairs').setup {}
starter.setup {}
require('mini.surround').setup {}


require('mini.jump').setup {}
vim.cmd [[ highlight MiniJump guifg=#181825 guibg=#f38ba8 ]]


local has_nvimtree, _ = pcall(require, 'nvim-tree')
if not has_nvimtree then
  require('mini.files').setup {
    mappings = {
    },
  }
  nmap('<M-f>', '<cmd>lua MiniFiles.open()<CR>', "Show [f]ile-explorer")
  nmap('<M-F>', '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>', "Show current [F]ile in file-explorer")
end

local has_lualine, _ = pcall(require, 'lualine')
if not has_lualine then
  vim.opt.laststatus = 3 -- global statusline
  vim.opt.cmdheight = 0
  vim.opt.hlsearch = true

  local MiniStatusline = require('mini.statusline')

  local section_macro_recording = function()
    local recording_register = vim.fn.reg_recording()

    if recording_register == "" then
      return ""
    else
      return "rec @" .. recording_register .. " "
    end
  end




  local diagnostic_level = function(level, prefix)
    -- if MiniStatusline.is_truncated(75) then return '' end
    local n = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity[level] })
    return (n == 0) and '' or ('%s%s'):format(prefix, n)
  end


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
      local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
      if not has_devicons then return '' end

      local file_name, file_ext = vim.fn.expand('%:t'), vim.fn.expand('%:e')
      return devicons.get_icon(file_name, file_ext, { default = true })
    end
    local filetype = vim.bo.filetype

    -- Don't show anything if can't detect file type or not inside a "normal
    -- buffer"
    if (filetype == '') or vim.bo.buftype ~= '' then return '' end
    if MiniStatusline.is_truncated(args.trunc_width) then return filetype end
    -- Add filetype icon

    local icon = get_filetype_icon()
    if icon ~= '' then filetype = string.format('%s %s', icon, filetype) end

    -- Construct output string if truncated

    -- Construct output string with extra file info
    local encoding = vim.bo.fileencoding or vim.bo.encoding
    local format = vim.bo.fileformat
    local format_icon = ''
    if format == 'unix' then
      format_icon = ''
    elseif format == 'dos' then
      format_icon = ''
    end
    local size = get_filesize()

    return string.format('%s %s[%s] %s', filetype, encoding, format_icon, size)
  end
  MiniStatusline.setup {
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git           = MiniStatusline.section_git({ trunc_width = 75 })
        local errors        = diagnostic_level('ERROR', ' ')
        local warns         = diagnostic_level('WARN', ' ')
        local hints         = diagnostic_level('HINT', ' ')
        local macro         = section_macro_recording()
        local filename      = MiniStatusline.section_filename({ trunc_width = 140 })
        local searchcount   = MiniStatusline.section_searchcount({ trunc_width = 75 })
        local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        -- local fileinfo      = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location      = MiniStatusline.section_location({ trunc_width = 75 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl,                 strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { git } },
          '%<', -- Mark general truncate point
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          { hl = 'DiagnosticError',        strings = { errors } },
          { hl = 'DiagnosticWarn',         strings = { warns } },
          { hl = 'DiagnosticHint',         strings = { hints } },
          '%=', -- End left alignment

          { hl = 'MiniStatuslineFilename', strings = { macro, searchcount } },
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
          { hl = mode_hl,                  strings = { location } },
        })
      end,
    },
    set_vim_settings = false,
  }
end

local has_indent_blankline, _ = pcall(require, 'ibl')
if not has_indent_blankline then
  local indentscope = require('mini.indentscope')
  indentscope.setup {
    symbol = '▏',
    draw = {
      delay = 0,
      animation = indentscope.gen_animation.none(),
    },
  }
end

local has_telescope, _ = pcall(require, 'telescope')

if not has_telescope then
  local MiniPick = require('mini.pick')

  MiniPick.setup {

  }
  nmap("<leader>ff", MiniPick.builtin.files, "Mini [f]iles")
  nmap("<leader>fg", MiniPick.builtin.grep_live, "Mini [g]rep")
  nmap("<leader>/", MiniPick.builtin.grep_live, "Global search with grep")
  nmap("<leader>fh", MiniPick.builtin.help, "Mini [h]elp")
  nmap("<leader>b", MiniPick.builtin.buffers, "Mini [b]uffers")
end


local has_whichkey, _ = pcall(require, 'which-key')
if not has_whichkey then
  nmap("<leader>d", vim.diagnostic.open_float, "hover [d]iagnostics")
  nmap("<leader>k", "<cmd>Lspsaga hover_doc<cr>", "hover documentation")
  nmap("<leader>a", "<cmd>Lspsaga code_action<cr>", "code [a]ctions")
  nmap("gd", vim.lsp.buf.definition, "Goto Definition")
  nmap("gD", vim.lsp.buf.declaration, "Goto Declaration")
  nmap("gr", vim.lsp.buf.references, "Goto References")
  nmap("gi", vim.lsp.buf.implementation, "Goto Implementation")

  local clue = require('mini.clue')
  clue.setup {
    triggers = {
      -- Leader triggers
      { mode = 'n', keys = '<Leader>' },
      { mode = 'x', keys = '<Leader>' },
      -- { mode = 'n', keys = '[' },
      -- { mode = 'n', keys = ']' },

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

      -- `z` key
      { mode = 'n', keys = 'z' },
      { mode = 'x', keys = 'z' },
    },

    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.registers(),
      clue.gen_clues.windows(),
      clue.gen_clues.z(),
    },
  }
end

local has_cmp, _ = pcall(require, 'cmp')
if not has_cmp then
  local MiniCompletion = require('mini.completion')
  MiniCompletion.setup { }
end


