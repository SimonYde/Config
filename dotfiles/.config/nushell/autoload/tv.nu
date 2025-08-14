module television {
    export extern "tv" [
        --preview (-p): string # A preview command to use with the stdin channel.
        --no-preview # Disable the preview panel entirely on startup.
        --delimiter: string # The delimeter used to extract fields from the entry to provide to the preview command.
        --tick-rate (-t) # The application's tick rate.
        --keybindings (-k): string # Keybindings to override the default keybindings.
        --input (-i): string # Input text to pass to the channel to prefill the prompt.
        --custom-header: string # Input fields header title.
        --autocomplete-prompt: string # Try to guess the channel from the provided input prompt.
        --exact # Use substring mattching instead of fuzzy matching.
        --select-1 # Automatically select and output the first entry if there is only one entry.
        --no-remote # Disable the remote control.
        --no-help # Disable the help panel.
        --help (-h) # Print help.
        --version (-V) # Print version.
        channel?: string@"nu-complete television channels"
        path?: path
    ]

    def "nu-complete television channels" [] {
        ^tv list-channels
        | lines
        | where ($it | str starts-with (char tab))
        | str trim
    }
}

use television [ tv ]
