return {
    cmd = { 'nixd' },
    filetypes = { 'nix' },
    settings = {
        nixd = {
            nixpkgs = { expr = 'import <nixpkgs> { }' },

            options = {
                nixos = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.'
                        .. vim.uv.os_gethostname()
                        .. '.options',
                },
            },
        },
    },
}
