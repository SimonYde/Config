module agenix {
    export def "agenix rekey" [ ] {
        let file = mktemp -t
        rbw get "SSH key" | save -f $file
        agenix --rekey -i $file
        rm -rf $file
    }

}

use agenix *
