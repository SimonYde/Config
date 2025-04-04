return {
    cmd = { 'metals' },
    filetypes = { 'scala', 'sbt' },
    root_markers = { 'build.sbt', 'build.gradle' },
    init_options = {
        statusBarProvider = 'show-message',
        isHttpEnabled = true,
        compilerOptions = {
            snippetAutoIndent = false,
        },
    },
    capabilities = {
        workspace = {
            configuration = false,
        },
    },
}
