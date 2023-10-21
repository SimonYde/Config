local function map(mode, keys, cmd, desc) vim.keymap.set(mode, keys, cmd, { desc = desc }) end
local function nmap(keys, cmd, desc) map("n", keys, cmd, desc) end

local diffview = vim.F.npcall(require, 'diffview')
if diffview then
  diffview.setup {}
  nmap("<leader>gd", vim.cmd.DiffviewOpen, "[g]it [d]iffview")
end

local neogit = vim.F.npcall(require, 'neogit')
if neogit then
  neogit.setup {
    integrations = {
      diffview = true,
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
