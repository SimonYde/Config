local nmap = require("syde.keymap").nmap

local has_diffview, diffview = pcall(require, 'diffview')
if has_diffview then
  diffview.setup {}
  nmap("<leader>gd", vim.cmd.DiffviewOpen, "[g]it [d]iffview")
end

local neogit = vim.F.npcall(require, 'neogit')
if neogit then
  neogit.setup {
    integrations = {
      diffview = has_diffview,
    },
  }
  nmap("<leader>gs", neogit.open, "Neo[g]it [s]tatus")
  nmap("<leader>gc", function() neogit.open { "commit" } end, "Neo[g]it [c]ommit")
end

local gitsigns = vim.F.npcall(require, 'gitsigns')
if gitsigns then
  gitsigns.setup {
    current_line_blame_opts = {
      delay = 1000,
      virt_text_pos = "eol",
    },
  }
end
