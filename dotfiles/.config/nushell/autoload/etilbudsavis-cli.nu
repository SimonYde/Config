module completions {

  def "nu-complete etilbudsavis-cli format" [] {
    [ "json" "rss" "table" ]
  }

  def "nu-complete etilbudsavis-cli generator" [] {
    [ "bash" "fish" "nushell" "zsh" ]
  }

  # A CLI interface for the eTilbudsavis API.
  export extern etilbudsavis-cli [
    ...search: string
    --format(-f): string@"nu-complete etilbudsavis-cli format" # The desired output format
    --dealer(-d)              # Search by dealer
    --generate: string@"nu-complete etilbudsavis-cli generator"
    --help(-h)                # Print help
    --version(-V)             # Print version
  ]

  # Add a dealer to favorites
  export extern "etilbudsavis-cli add" [
    ...dealers: string
    --help(-h)                # Print help
  ]

  # Remove a dealer from favorites
  export extern "etilbudsavis-cli remove" [
    ...dealers: string
    --help(-h)                # Print help
  ]

  # List available dealers
  export extern "etilbudsavis-cli dealers" [
    --help(-h)                # Print help
  ]

  # List currently set favorites
  export extern "etilbudsavis-cli favorites" [
    --help(-h)                # Print help
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "etilbudsavis-cli help" [
  ]

  # Add a dealer to favorites
  export extern "etilbudsavis-cli help add" [
  ]

  # Remove a dealer from favorites
  export extern "etilbudsavis-cli help remove" [
  ]

  # List available dealers
  export extern "etilbudsavis-cli help dealers" [
  ]

  # List currently set favorites
  export extern "etilbudsavis-cli help favorites" [
  ]

  # Print this message or the help of the given subcommand(s)
  export extern "etilbudsavis-cli help help" [
  ]

}

export use completions *
