return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
    },
    settings = {
        Lua = {
            telemetry = { enable = false },
            runtime = { version = 'LuaJIT' },

            workspace = {
                checkThirdParty = false,
                ignoreSubmodules = true,
            },
        },
    },
}
