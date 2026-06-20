hl.window_rule({
    name = 'pavucontrol',
    match = {
        class = 'org.pulseaudio.pavucontrol',
    },
    size = '(monitor_w*0.70) (monitor_h*0.70)',
    float = true,
    center = true,
})

hl.window_rule({
    name = 'Picture-in-Picture',
    match = {
        initial_title = '^(Picture-in-picture|Picture-in-Picture)$',
    },
    float = true,
    pin = true,
    content = 'video',
    move = '(monitor_w*0.60) (monitor_h*0.02)',
    size = '(monitor_w*0.40) (monitor_h*0.40)',
})

hl.window_rule({
    name = 'Bitwarden Brave',
    match = {
        initial_class = 'brave-nngceckbapebfimnlniiiahkandclblb-Default',
    },
    float = true,
    pin = true,
    center = true,
})

hl.window_rule({
    name = 'games should tear',
    match = {
        tag = 'game|proton-game',
    },
    content = 'game',
    monitor = 'DP-1',
    fullscreen = true,
    immediate = true,
})

hl.window_rule({
    name = 'games should tear class',
    match = {
        class = 'ck3',
    },
    content = 'game',
    monitor = 'DP-1',
    fullscreen = true,
    immediate = true,
})

hl.window_rule({
    name = 'Nextcloud',
    match = {
        class = '^com.nextcloud.desktopclient.nextcloud$',
    },
    float = true,
    no_anim = true,
    move = '(monitor_w*0.75) (monitor_h*0.02)',
    size = '(monitor_w*0.25) (monitor_h*0.80)',
})

hl.window_rule({ match = { class = '.*blueman-manager.*' }, float = true })
hl.window_rule({ match = { class = '^nm-connection-editor$' }, float = true })
hl.window_rule({ match = { class = '.*File Upload.*' }, float = true })
hl.window_rule({ match = { class = '.*Connection Details.*' }, float = true })
hl.window_rule({ match = { class = 'Paradox Launcher' }, float = true })

hl.window_rule({ match = { class = 'electron|obsidian', initial_title = 'Obsidian' }, workspace = 1 })
hl.window_rule({ match = { class = '^steam$' }, workspace = 5 })
hl.window_rule({ match = { class = 'ferdium|Ferdium|discord|legcord|vesktop|WhatsApp' }, workspace = '9 silent' })
hl.window_rule({
    name = 'polkit keep focus',
    match = {
        title = 'Hyprland Polkit Agent',
    },
    stay_focused = true,
    dim_around = true,
})

---------------------
---- LAYER RULES ----
---------------------
hl.layer_rule({
    match = { namespace = '^(logout_dialog)$' },
    blur = true,
    ignore_alpha = 0.5,
})

-------------------------
---- WORKSPACE RULES ----
-------------------------
hl.workspace_rule({ workspace = 'special:music', on_created_empty = 'uwsm-app -- spotify' })
