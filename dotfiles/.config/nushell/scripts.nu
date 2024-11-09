module zellij_extras {
    # Zellij attach helper
    export def za [session?: string@session_completer] {
        zellij attach (
            match $session {
            null => (
                parse_sessions
                | sk
                | ansi strip
            ),
            _ => $session
            }
        )
    }

    # Zellij create session (Attach if already exists)
    export def zc [] {
        let current = pwd | split words | last
        let exists = parse_sessions | ansi strip | any {|el| $el == $current }

        if $exists {
            zellij a $current
        } else {
            zellij -s $current
        }
    }

    def parse_sessions [] {
        zellij list-sessions | parse "{session} {other}" | get session
    }

    def session_completer [] {
        parse_sessions | ansi strip
    }
}

use zellij_extras *
