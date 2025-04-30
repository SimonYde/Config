const DAY_TEMP = 6000
const DAY_TIME = 6
const NIGHT_TEMP = 2000
const NIGHT_TIME = 21

def main [temperature?: number] {
    let current_time = date now | into record

    let set_temp = {|temp|
        try {
            hyprctl hyprsunset temperature $temp
        } catch {
            systemctl --user restart hyprsunset.service
            hyprctl hyprsunset temperature $temp
        }
    }

    let set_gamma = {|gamma|
        try {
            hyprctl hyprsunset gamma $gamma
        } catch {
            systemctl --user restart hyprsunset.service
            hyprctl hyprsunset gamma $gamma
        }
    }

    if $temperature != null {
        do $set_temp $temperature
        return
    }

    let tick_down_time = $NIGHT_TIME - 3

    if $current_time.hour >= $NIGHT_TIME {
        do $set_gamma 80
        do $set_temp $NIGHT_TEMP
    } else if $current_time.hour in $tick_down_time..=$NIGHT_TIME {
        let part = ($DAY_TEMP - $NIGHT_TEMP) / ($NIGHT_TIME - $tick_down_time)

        let time = $current_time.hour + $current_time.minute / 60

        let temp = $DAY_TEMP - ($time - $tick_down_time) * $part | math floor

        do $set_temp $temp
    } else {
        do $set_gamma 100
        do $set_temp $DAY_TEMP
    }
}
