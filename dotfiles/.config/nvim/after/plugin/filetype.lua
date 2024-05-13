Load.now(function()
    vim.filetype.add({
        extension = {
            mll = "ocamllex",
            mly = "menhir",
            ll = "llvm",
            tex = "tex",
            rasi = "css",
            conf = function (path, _)
                -- For hyprland config files
                if string.find(path, "hypr") then
                    return "hyprlang"
                end
                return "conf"
            end
        },
        filename = {
            ["flake.lock"] = "json",
        },
    })
end)
