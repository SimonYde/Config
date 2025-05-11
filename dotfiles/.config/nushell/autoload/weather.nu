export def weather [
    --json
    ...cities: string
] {
    let cities = [...$cities] | str join ","

    let url = if $json { $"https://wttr.in/($cities)?format=j1" } else {
        $"https://wttr.in/($cities)"
    }
    let response = http get $url

    if $json {
        $response | get current_condition | select temp_C FeelsLikeC | rename "℃ " "feels like"
    } else {
        $response
    }

}
