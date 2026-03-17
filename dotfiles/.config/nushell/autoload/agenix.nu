module agenix {
    use std/log
    export def "agenix rekey" [ ] {
        let file = mktemp
        log info $"Created `($file)` to store key"

        rbw get "SSH syde" | save -f $file
        log info $"Wrote private key to `($file)`"

        try {
            agenix --rekey -i $file
            log info $"Rekeyed secrets"
        } finally {
            rm -fp $file
            log info $"Deleted private key file: `($file)`"
        }
    }

    export def "agenix edit" [input: path] {
        let file = mktemp
        log info $"Created `($file)` to store key"

        rbw get "SSH syde" | save -f $file
        log info $"Wrote private key to `($file)`"

        try {
            agenix -i $file -e $input
            log info $"Finished editing `($input)`"
        } finally {
            rm -fp $file
            log info $"Deleted private key file: `($file)`"
        }
    }
}

use agenix *
