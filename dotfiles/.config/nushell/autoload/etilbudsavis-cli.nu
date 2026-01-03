module completions {

  def "nu-complete etb format" [] {
    [ "json" "rss" "table" ]
  }

  def "nu-complete etb generator" [] {
    [ "bash" "fish" "nushell" "zsh" ]
  }

  # A CLI interface for the eTilbudsavis API.
  export extern etb [
    ...search: string
    --format(-f): string@"nu-complete etb format" # The desired output format
    --dealer(-d)              # Search by dealer
    --generate: string@"nu-complete etb generator"
    --help(-h)                # Print help
    --version(-V)             # Print version
  ]

  # Add a dealer to favorites
  export extern "etb add" [
    ...dealers: string
    --help(-h)                # Print help
  ]

  # Remove a dealer from favorites
  export extern "etb remove" [
    ...dealers: string
    --help(-h)                # Print help
  ]

  # List available dealers
  export extern "etb dealers" [
    --help(-h)                # Print help
  ]

  # List currently set favorites
  export extern "etb favorites" [
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "etb help" [
  ]
}

export use completions *
