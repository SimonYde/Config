# Lines-of-code.
export def "loc" [
    language?: string # return lines-of-code by file matching `language`.
] {
    if (which tokei | is-empty) {
        error make {
            msg: "`tokei` is not installed"
            help: "nix shell nixpkgs#tokei"
        }
    }

    let report = tokei --hidden -o json
    | from json
    | rename --block { str downcase }

    if ($language | is-empty) {
        return (
            $report
            | transpose
            | each { {language: $in.column0 code: $in.column1.code} }
        )
    }

    $report
    | get $language
    | get reports
    | each { {name: $in.name code: $in.stats.code} }
    | sort-by code
}
