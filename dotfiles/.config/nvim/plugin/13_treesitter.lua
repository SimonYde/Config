Load.now_if_args(function()
    Load.packadd('nvim-treesitter')
    -- local parser_install_dir = vim.fn.stdpath('state') .. '/treesitter'
    -- vim.opt.runtimepath:prepend(parser_install_dir)

    Config.treesitter = {}
    Config.treesitter.filetypes = {}

    for _, lang in ipairs(require('nvim-treesitter').get_available()) do
        for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
            table.insert(Config.treesitter.filetypes, ft)
        end
    end

    local ensure_languages = {
        'diff',
        'lua',
        'markdown',
        'markdown_inline',
        'nix',
        'nu',
        'query',
        'regex',
        'vim',
        'vimdoc',
    }

    require('nvim-treesitter').setup({
        -- Directory to install parsers and queries to
        -- install_dir = parser_install_dir,
    })

    require('nvim-treesitter').install(ensure_languages)

    -- Ensure tree-sitter enabled after opening a file for target language
    local filetypes = {}

    for _, lang in ipairs(ensure_languages) do
        for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
            table.insert(filetypes, ft)
        end
    end

    local ts_start = function(ev)
        vim.bo[ev.buf].indentexpr = [[v:lua.require('nvim-treesitter').indentexpr()]]
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = [[v:lua.vim.treesitter.foldexpr()]]
        vim.treesitter.start(ev.buf)
    end

    local autoinstall = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)

        local installed = require('nvim-treesitter').get_installed()

        local lang_is_installed = #vim.tbl_filter(function(value) return value == lang end, installed) > 0

        if not lang_is_installed then require('nvim-treesitter').install(lang):wait(500000) end

        ts_start(ev)
    end

    Config.create_autocmd('FileType', Config.treesitter.filetypes, autoinstall, 'Autoinstall tree-sitter parser')

    vim.api.nvim_create_user_command('TSReinstall', function()
        local installed = require('nvim-treesitter').get_installed()

        for _, value in ipairs(installed) do
            require('nvim-treesitter').uninstall(value):wait(500000)
        end

        for _, value in ipairs(installed) do
            require('nvim-treesitter').install(value)
        end

        vim.api.nvim_echo({{"Successfully reinstalled treesitter parsers"}}, true, {})
    end, {})
end)

Load.later(function()
    Load.packadd('nvim-treesitter-context')
    local context = require('treesitter-context')
    context.setup()

    Snacks.toggle
        .new({ name = 'Treesitter context', get = context.enabled, set = context.toggle })
        :map('<leader><leader>t')
end)
