module agenix {
    use std/log
    export def "agenix rekey" [ ] {
        let file = mktemp -t
        log info $"Created `($file)` to store key"

        rbw get "SSH syde" | save -f $file
        log info $"Wrote private key to `($file)`"

        agenix --rekey -i $file
        log info $"Rekeyed secrets"

        rm -rf $file
        log info $"Deleted private key file: `($file)`"
    }

    export def "agenix edit" [input: path] {
        let file = mktemp -t
        log info $"Created `($file)` to store key"

        rbw get "SSH syde" | save -f $file
        log info $"Wrote private key to `($file)`"

        agenix -i $file -e $input
        log info $"Finished editing `($input)`"

        rm -rf $file
        log info $"Deleted private key file: `($file)`"
    }
}

use agenix *
