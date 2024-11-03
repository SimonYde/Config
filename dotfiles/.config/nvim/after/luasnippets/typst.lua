local ls = require('luasnip')

local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node

local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets('typst', {
    s('bb', fmt('[|{}|]{}', { i(1), i(0) })),
})
