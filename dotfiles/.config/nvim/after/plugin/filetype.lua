vim.filetype.add({
  extension = {
    mll = "ocamllex",
    mly = "menhir",
    ll = "llvm",
    tex = "tex",
  },
  filename = {
   ["flake.lock"] = "json",
  },
})
