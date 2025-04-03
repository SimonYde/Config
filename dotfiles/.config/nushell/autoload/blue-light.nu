def "blue-light enable" [ ] {
    if (which hyprsunset | is-empty) {
        error make {msg: "`hyprsunset` is not installed" }
    }
    hyprctl hyprsunset temperature 2200
    hyprctl hyprsunset gamma 80
}

def "blue-light disable" [ ] {
    if (which hyprsunset | is-empty) {
        error make {msg: "`hyprsunset` is not installed" }
    }
    hyprctl hyprsunset identity
}
