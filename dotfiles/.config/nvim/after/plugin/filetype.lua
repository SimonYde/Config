Load.now(function()
    vim.filetype.add({
        extension = {
            mll = "ocamllex",
            mly = "menhir",
            ll = "llvm",
            tex = "tex",
            rasi = "css",
        },
        filename = {
            ["flake.lock"] = "json",
        },
    })
end)
