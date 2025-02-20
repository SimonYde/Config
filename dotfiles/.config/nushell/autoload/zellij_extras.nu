$env.config = ($env.config | upsert hooks.pre_prompt {|config|
    let pre_prompt = ($config | get -i hooks.pre_prompt)

    $pre_prompt | append {
        if $env.ZELLIJ? != null {
            let dir = pwd
                | str replace '/home/syde' '~'
                | path parse
                | get parent
                | path split
                | each { |dir| $dir | split chars | first }
            let basename = pwd | path basename
            let join = $dir | append $basename | path join
            zellij action rename-tab $join
        }
    }
})
$env.config = ($env.config | upsert hooks.pre_execution {|config|
    let pre_execution = ($config | get -i hooks.pre_execution)

    $pre_execution | append {
        if $env.ZELLIJ? != null {
            let cmd = commandline | split row ' ' | first
            zellij action rename-tab $cmd
        }
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
    let current = pwd | split words | last
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
