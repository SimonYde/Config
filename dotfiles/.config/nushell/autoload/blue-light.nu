module blue-light {
    const NIGHT_TEMP = 2200
    const DAY_TEMP = 6000

    export def main [] {
        let current_time = date now | format date "%H" | into int
        if $current_time >= 20 {
            try {
                enable
            } catch {
                systemctl --user restart hyprsunset.service
                enable
            }
        } else if $current_time >= 5 {
            disable
        }
    }

    export def "enable" [] {
        if (which hyprsunset | is-empty) {
            error make {msg: "`hyprsunset` is not installed"}
        }
        hyprctl hyprsunset temperature $NIGHT_TEMP
        hyprctl hyprsunset gamma 80
    }

    export def "disable" [] {
        if (which hyprsunset | is-empty) {
            error make {msg: "`hyprsunset` is not installed"}
        }
        hyprctl hyprsunset temperature $DAY_TEMP
        hyprctl hyprsunset gamma 100
    }
}

use blue-light
