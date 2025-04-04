return {
    cmd = { 'tinymist' },
    filetypes = { 'typst' },
    settings = { exportPdf = 'onSave' }, -- Choose `onType`, `onSave` or `never`.

    ---@param client vim.lsp.Client
    on_attach = function(client, bufnr)
        local nmap = function(keys, cmd, desc) Keymap.nmap(keys, cmd, desc, { buffer = bufnr }) end

        nmap('<leader>lp', function()
            local file = vim.api.nvim_buf_get_name(bufnr)
            local pdf = file:gsub('%.typ$', '.pdf')
            vim.system({ 'xdg-open', pdf })
        end, 'open [p]df')

        nmap('<leader>lw', function()
            local main_file = vim.api.nvim_buf_get_name(bufnr)
            ---@diagnostic disable-next-line: missing-fields the `title` argument is in fact not necessary.
            client:exec_cmd({ command = 'tinymist.pinMain', arguments = { main_file } })
            vim.notify('Pinned to ' .. main_file, vim.log.levels.INFO)
            local pdf = main_file:gsub('%.typ$', '.pdf')
            vim.system({ 'xdg-open', pdf })
        end, 'Pin main file to current')
    end,
}
