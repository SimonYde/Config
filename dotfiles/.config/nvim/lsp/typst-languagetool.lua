local root_files = { 'main.typ' }
local paths = vim.fs.find(root_files, { stop = vim.env.HOME })
local root_dir = vim.fs.dirname(paths[1])

if not root_dir then return nil end

return {
    cmd = { 'typst-languagetool-lsp' },
    root_markers = { '.git' },
    root_dir = root_dir,
    filetypes = { 'typst' },
    init_options = {
        backend = 'server', -- "bundle" | "jar" | "server"
        host = 'https://languagetool.ts.simonyde.com',
        port = '443',
        root = root_dir,
        main = root_dir .. '/main.typ',
        languages = { de = 'de-DE', en = 'en-GB' },
    },
}
