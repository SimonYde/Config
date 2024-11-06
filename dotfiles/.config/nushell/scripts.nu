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

    def parse_sessions [] {
        zellij list-sessions | parse "{session} {other}" | get session
    }

    def session_completer [] {
        parse_sessions | ansi strip
    }
}

use zellij_extras *
