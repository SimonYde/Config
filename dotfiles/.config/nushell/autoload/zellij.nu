$env.config.hooks.pre_prompt = (
    $env.config.hooks.pre_prompt
    | append {
        if "ZELLIJ" in $env {
            let dir = pwd
            | str replace '/home/syde' '~'
            | path parse
            | get parent
            | path split
            | each { |dir| $dir | split chars | first }
            let basename = pwd | path basename
            zellij action rename-tab ($dir | append $basename | path join)
        }
    }
)
$env.config.hooks.pre_execution = ($env.config.hooks.pre_execution | append {
    if "ZELLIJ" in $env {
        let cmd = commandline | split row ' ' | first
        zellij action rename-tab $cmd
    }
})

# Zellij attach helper
export def za [session?: string@sessions] {
    zellij attach (
        match $session {
        null => (
            sessions
            | get value
            | str join (char newline)
            | fzf
        ),
        _ => $session
        }
    )
}

# Zellij create session (Attach if already exists)
export def zc [] {
    let current = basename
    let exists = sessions | ansi strip | any {|session| $session == $current }

    if $exists {
        zellij a $current
    } else {
        zellij -s $current
    }
}

def sessions [] {
    zellij list-sessions
    | parse "{session} {other}"
    | each {|ses| {value: ($ses.session | ansi strip), description: $ses.other} }
}
