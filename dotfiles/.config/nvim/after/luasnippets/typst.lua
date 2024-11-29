local ls = require('luasnip')

local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node

local fmt = require('luasnip.extras.fmt').fmt

ls.add_snippets('typst', {
    s('bb', fmt('[|{}|]{}', { i(1), i(0) })),
    s('sum', fmt('sum_({})^({}){}', { i(1), i(2), i(0) })),
})
