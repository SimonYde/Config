Load.later(function()
    require('render-markdown').setup({
        callout = {
            definition = { raw = '[!definition]', rendered = ' Definition', highlight = 'RenderMarkdownInfo' },
            theorem = { raw = '[!theorem]', rendered = '󰨸 Theorem', highlight = 'RenderMarkdownHint' },
            proof = { raw = '[!proof]', rendered = '󰌶 Proof', highlight = 'RenderMarkdownWarn' },
        }
    })
end)
