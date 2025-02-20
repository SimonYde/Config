export def weather [city?: string] {
    http get https://wttr.in/($city | default "")
}
