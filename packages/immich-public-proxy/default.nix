{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
}:

let
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "alangrainger";
    repo = "immich-public-proxy";
    tag = "v${version}";
    hash = "sha256-MJ5VoBHXM5Mxch4nVaFk0B8/SNjkXf8oXQgnRwscc4E=";
  };

  # Every workspace is built from the same monorepo lockfile.
  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-t1bZPs3gwgM6Lt1Ox/XDb+gU6pGKi5olQJFUCx4LUu4=";

  common = {
    inherit
      src
      version
      npmDepsFetcherVersion
      npmDepsHash
      ;
    dontNpmBuild = true;
    dontNpmInstall = true;
  };

  # The apps install their own production node_modules. Dereference the
  # @ipp/core workspace symlink so the result is self-contained.
  installDeps = ''
    npm prune --omit=dev --workspace=''${workspace}
    cp -rL node_modules "$pkg/node_modules"
    rm -rf "$pkg/node_modules/.bin" \
      "$pkg/node_modules/immich-public-proxy" \
      "$pkg/node_modules/immich-public-proxy-upload"
    rm -rf "$pkg/node_modules/@ipp/core"
    cp -r shared "$pkg/node_modules/@ipp/core"
    rm -rf "$pkg/node_modules/@ipp/core/src" \
      "$pkg/node_modules/@ipp/core/tests" \
      "$pkg/node_modules/@ipp/core/tsconfig.json" \
      "$pkg/node_modules/@ipp/core/vitest.config.ts" \
      "$pkg/node_modules/@ipp/core/dist/tsconfig.tsbuildinfo"
  '';
in
{
  immich-public-proxy = buildNpmPackage (
    common
    // {
      pname = "immich-public-proxy";

      # The app serves its public/ directory relative to the working
      # directory, so point it at the installed copy instead.
      postPatch = ''
        substituteInPlace app/src/index.ts --replace-fail \
          "for (const dir of ['public', CORE_PUBLIC_DIR])" \
          "for (const dir of ['$out/lib/node_modules/immich-public-proxy/public', CORE_PUBLIC_DIR])"
      '';

      buildPhase = ''
        runHook preBuild
        npm run build --workspace=shared --workspace=app
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        pkg="$out/lib/node_modules/immich-public-proxy"
        mkdir -p "$pkg"
        cp -r app/dist app/public app/config.json app/package.json "$pkg/"

        workspace=app
        ${installDeps}

        mkdir -p "$out/bin"
        makeWrapper "${nodejs}/bin/node" "$out/bin/immich-public-proxy" \
          --add-flags "$pkg/dist/index.js"

        runHook postInstall
      '';

      meta = {
        description = "Share your Immich photos and albums in a safe way without exposing your Immich instance to the public";
        homepage = "https://github.com/alangrainger/immich-public-proxy";
        license = lib.licenses.agpl3Only;
        inherit (nodejs.meta) platforms;
        mainProgram = "immich-public-proxy";
      };
    }
  );

  immich-public-proxy-upload = buildNpmPackage (
    common
    // {
      pname = "immich-public-proxy-upload";

      # The upload app also serves its public/ directory relative to the
      # working directory.
      postPatch = ''
        substituteInPlace upload-app/src/index.ts --replace-fail \
          "for (const dir of ['public', CORE_PUBLIC_DIR])" \
          "for (const dir of ['$out/lib/node_modules/immich-public-proxy-upload/public', CORE_PUBLIC_DIR])"
      '';

      buildPhase = ''
        runHook preBuild
        npm run build --workspace=shared --workspace=upload-app
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        pkg="$out/lib/node_modules/immich-public-proxy-upload"
        mkdir -p "$pkg"
        cp -r upload-app/dist upload-app/public upload-app/config.json upload-app/package.json "$pkg/"

        workspace=upload-app
        ${installDeps}

        mkdir -p "$out/bin"
        makeWrapper "${nodejs}/bin/node" "$out/bin/immich-public-proxy-upload" \
          --add-flags "$pkg/dist/index.js"

        runHook postInstall
      '';

      meta = {
        description = "Visitor upload service for Immich Public Proxy";
        homepage = "https://github.com/alangrainger/immich-public-proxy";
        license = lib.licenses.agpl3Only;
        inherit (nodejs.meta) platforms;
        mainProgram = "immich-public-proxy-upload";
      };
    }
  );
}
