export def main [city?: string] {
    http get https://wttr.in/($city | default "")
}
