local whichkey = require('which-key')
whichkey.setup {}
whichkey.register({
  ["<leader>"] = {
    f = {
      name = "Find (telescope)",
    },
    d = { vim.diagnostic.open_float, "Open diagnostics" },
    k = { "<cmd>Lspsaga hover_doc<cr>", "hover documentation" },
    a = { "<cmd>Lspsaga code_action<cr>", "code actions" },
    -- k = { vim.lsp.buf.hover, "hover documentation" },
    -- a = { vim.lsp.buf.code_action, "code actions" },
  },
  ["g"] = {
    d = { vim.lsp.buf.definition, "Goto Definition" },
    D = { vim.lsp.buf.declaration, "Goto Declaration" },
    -- r = { vim.lsp.buf.references, "Goto References"},
    r = { require('telescope.builtin').lsp_references, "Goto References" },
    -- i = { vim.lsp.buf.implementation, "Goto Implementation" },
    i = { require('telescope.builtin').lsp_implementations, "Goto Implementations" },
  },
  ["["] = {
    d = { vim.diagnostic.goto_prev, "Previous diagnostic" },
  },
  ["]"] = {
    d = { vim.diagnostic.goto_next, "Next diagnostic" },
  },
})
local presets = require("which-key.plugins.presets")
presets.operators["v"] = nil
