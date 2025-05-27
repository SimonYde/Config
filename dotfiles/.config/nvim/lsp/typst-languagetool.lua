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
        -- jar_location = "path/to/jar/location"
        host = 'http://127.0.0.1',
        port = '8081',
        root = root_dir,
        main = root_dir .. '/main.typ',
        languages = { de = 'de-DE', en = 'en-GB' },
    },
}
