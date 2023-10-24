local whichkey = vim.F.npcall(require, "which-key")
if not whichkey then
  return
end
whichkey.setup {}
whichkey.register({
  ["<leader>"] = {
    f = {
      name = "[f]ind (telescope)",
    },
    d = { vim.diagnostic.open_float, "hover [d]iagnostics" },
    k = { "<cmd>Lspsaga hover_doc<cr>", "hover documentation" },
    a = { "<cmd>Lspsaga code_action<cr>", "code [a]ctions" },
    -- k = { vim.lsp.buf.hover, "hover documentation" },
    -- a = { vim.lsp.buf.code_action, "code actions" },
  },
  ["g"] = {
    d = { vim.lsp.buf.definition, "Goto Definition" },
    D = { vim.lsp.buf.declaration, "Goto Declaration" },
    -- r = { vim.lsp.buf.references, "Goto References"},
    -- i = { vim.lsp.buf.implementation, "Goto Implementation" },
    r = { "<cmd>Telescope lsp_references<cr>", "Goto References" },
    i = { "<cmd>Telescope lsp_implementations<cr>", "Goto References" },
  },
  -- ["["] = {
  --   d = { vim.diagnostic.goto_prev, "Previous diagnostic" },
  -- },
  -- ["]"] = {
  --   d = { vim.diagnostic.goto_next, "Next diagnostic" },
  -- },
})
local presets = require("which-key.plugins.presets")
presets.operators["v"] = nil
