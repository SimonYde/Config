local uwsm = 'uwsm-app -- '
hl.bind('SUPER + B', hl.dsp.exec_cmd(uwsm .. _G.browser))
hl.bind('SUPER + T', hl.dsp.exec_cmd(uwsm .. 'wezterm connect local'))
hl.bind('SUPER + Y', hl.dsp.exec_cmd(uwsm .. _G.terminal .. ' -e yazi'))
hl.bind('SUPER + SHIFT + F', hl.dsp.exec_cmd(uwsm .. _G.terminal .. ' -e yazi'))
hl.bind('SUPER + O', hl.dsp.exec_cmd(uwsm .. 'obsidian'))
hl.bind('SUPER + G', hl.dsp.exec_cmd(uwsm .. 'hyprland-gamemode'))
hl.bind('SUPER + L', hl.dsp.exec_cmd(uwsm .. 'loginctl lock-session'))
hl.bind('SUPER + V', hl.dsp.exec_cmd('voxtype record toggle'))

hl.bind('SUPER + ALT + B', hl.dsp.exec_cmd(uwsm .. 'random-wallpaper'))
hl.bind('SUPER + ALT + L', hl.dsp.exec_cmd(uwsm .. 'toggle-laptop-display'))

hl.bind('SUPER + space', hl.dsp.exec_cmd('walker'))
hl.bind('SUPER + period', hl.dsp.exec_cmd('walker -m symbols'))
hl.bind('SUPER + escape', hl.dsp.exec_cmd(uwsm .. 'pidof wlogout || wlogout'))

-- Screenshots
hl.bind('SUPER + SHIFT + S', hl.dsp.exec_cmd(uwsm .. 'hyprshot --clipboard-only -m region'))
hl.bind('Print', hl.dsp.exec_cmd(uwsm .. 'hyprshot -m output'))
hl.bind('SHIFT + Print', hl.dsp.exec_cmd(uwsm .. 'hyprshot -m region'))

hl.bind(
    'XF86AudioMedia',
    hl.dsp.exec_cmd(
        'hyprctl eval "hl.config({ input = { touchpad = { tap_to_click = false } } })" && notify-send -a "hyprctl" "Disabled tap-to-click"'
    )
)

hl.bind('SUPER + ALT + F', hl.dsp.window.float({ action = 'toggle' }))
hl.bind('SUPER + F', hl.dsp.window.fullscreen_state({ internal = 2, client = 0, action = 'toggle' }))

hl.bind('SUPER + Q', hl.dsp.window.close())
hl.bind('SUPER + P', hl.dsp.window.pin({ window = 'activewindow' }))

hl.bind('SUPER + M', hl.dsp.focus({ direction = 'left' }))
hl.bind('SUPER + N', hl.dsp.focus({ direction = 'down' }))
hl.bind('SUPER + E', hl.dsp.focus({ direction = 'up' }))
hl.bind('SUPER + I', hl.dsp.focus({ direction = 'right' }))

hl.bind('SUPER + SHIFT + M', hl.dsp.window.move({ direction = 'left' }))
hl.bind('SUPER + SHIFT + N', hl.dsp.window.move({ direction = 'down' }))
hl.bind('SUPER + SHIFT + E', hl.dsp.window.move({ direction = 'up' }))
hl.bind('SUPER + SHIFT + I', hl.dsp.window.move({ direction = 'right' }))

hl.bind('SUPER + ALT + M', hl.dsp.workspace.move({ monitor = 'l' }))
hl.bind('SUPER + ALT + N', hl.dsp.workspace.move({ monitor = 'd' }))
hl.bind('SUPER + ALT + E', hl.dsp.workspace.move({ monitor = 'u' }))
hl.bind('SUPER + ALT + I', hl.dsp.workspace.move({ monitor = 'r' }))

hl.bind('SUPER + Left', hl.dsp.focus({ workspace = '-1' }), { repeating = true })
hl.bind('SUPER + Right', hl.dsp.focus({ workspace = '+1' }), { repeating = true })
hl.bind('SUPER + SHIFT + Left', hl.dsp.window.move({ workspace = '-1' }), { repeating = true })
hl.bind('SUPER + SHIFT + Right', hl.dsp.window.move({ workspace = '+1' }), { repeating = true })

hl.bind('SUPER + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind('SUPER + mouse:273', hl.dsp.window.resize(), { mouse = true })

for i = 1, 10 do
    local key = i % 10
    hl.bind('SUPER + ' .. key, hl.dsp.focus({ workspace = i }))
    hl.bind('SUPER + SHIFT + ' .. key, hl.dsp.window.move({ workspace = i }))
end

-- Audio control
hl.bind('XF86AudioMicMute', hl.dsp.exec_cmd(uwsm .. 'swayosd-client --input-volume mute-toggle'))
hl.bind(
    'XF86AudioMute',
    hl.dsp.exec_cmd('swayosd-client --output-volume mute-toggle --max-volume 100'),
    { locked = true }
)
hl.bind(
    'XF86AudioRaiseVolume',
    hl.dsp.exec_cmd('swayosd-client --output-volume +10 --max-volume 100'),
    { locked = true, repeating = true }
)
hl.bind(
    'XF86AudioLowerVolume',
    hl.dsp.exec_cmd('swayosd-client --output-volume -10 --max-volume 100'),
    { locked = true, repeating = true }
)

-- Brightness control
hl.bind('XF86MonBrightnessUp', hl.dsp.exec_cmd('swayosd-client --brightness +10'), { locked = true, repeating = true })
hl.bind(
    'XF86MonBrightnessDown',
    hl.dsp.exec_cmd('swayosd-client --brightness -10'),
    { locked = true, repeating = true }
)

-- Media control
hl.bind('XF86AudioPlay', hl.dsp.exec_cmd('swayosd-client --playerctl play-pause'), { locked = true })
hl.bind('XF86AudioPause', hl.dsp.exec_cmd('swayosd-client --playerctl play-pause'), { locked = true })
hl.bind('XF86AudioNext', hl.dsp.exec_cmd('swayosd-client --playerctl next'), { locked = true })
hl.bind('XF86AudioPrev', hl.dsp.exec_cmd('swayosd-client --playerctl prev'), { locked = true })

-- Resizing
hl.bind('SUPER + code:20', hl.dsp.layout('colresize -conf'), { repeating = true })
hl.bind('SUPER + code:21', hl.dsp.layout('colresize +conf'), { repeating = true })
hl.bind('SUPER + SHIFT + code:20', hl.dsp.window.resize({ x = 0, y = -100, relative = true }), { repeating = true })
hl.bind('SUPER + SHIFT + code:21', hl.dsp.window.resize({ x = 0, y = 100, relative = true }), { repeating = true })

-- Special workspaces
hl.bind('SUPER + X', hl.dsp.workspace.toggle_special('music'))
hl.bind('SUPER + SHIFT + X', hl.dsp.window.move({ workspace = 'special:music' }))
