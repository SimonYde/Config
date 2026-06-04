Name = 'power'
NamePretty = 'Power Options'
Icon = 'applications-other'
Cache = true
Action = 'notify-send %VALUE%'
HideFromProviderlist = false
Description = 'power menu'
SearchName = true

function GetEntries()
    local entries = {}

    table.insert(entries, {
        Text = "Lock",
        Actions = {
            lock = 'loginctl lock-session',
        },
        Icon = "lock",
    })
    table.insert(entries, {
        Text = "Suspend",
        Actions = {
            suspend = 'systemctl suspend',
        },
        Icon = "sleep",
    })
    table.insert(entries, {
        Text = "Power Off",
        Actions = {
            poweroff = 'systemctl poweroff',
        },
        Icon = "poweroff",
    })
    table.insert(entries, {
        Text = "Reboot",
        Actions = {
            reboot = 'systemctl reboot',
        },
        Icon = "reboot",
    })
    table.insert(entries, {
        Text = "Logout",
        Actions = {
            logout = "hyprctl dispatch 'hl.dsp.exit()'",
        },
        Icon = "logout",
    })

    return entries
end
