hl.curve('window', { type = 'bezier', points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve('windowIn', { type = 'bezier', points = { { 0.1, 1.1 }, { 0.1, 1.0 } } })
hl.curve('windowOut', { type = 'bezier', points = { { 0.3, -0.3 }, { 0.0, 1.0 } } })

hl.animation({ leaf = 'windows', enabled = true, speed = 2, bezier = 'window', style = 'popin' })
hl.animation({ leaf = 'windowsIn', enabled = true, speed = 3, bezier = 'windowIn', style = 'popin' })
hl.animation({ leaf = 'windowsOut', enabled = true, speed = 3, bezier = 'windowOut', style = 'popin' })
hl.animation({ leaf = 'windowsMove', enabled = true, speed = 1.5, bezier = 'window', style = 'slide' })
hl.animation({ leaf = 'border', enabled = false })
hl.animation({ leaf = 'workspaces', enabled = false })
hl.animation({ leaf = 'fade', enabled = false })

hl.config({
    general = {
        allow_tearing = true,
        border_size = 2,
        gaps_in = 2,
        gaps_out = 2,
        layout = 'scrolling',
        resize_on_border = true,
    },

    input = {
        accel_profile = 'flat',
        follow_mouse = 2,
        repeat_delay = 300,
        resolve_binds_by_sym = true,
        special_fallthrough = true,

        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
        },
    },

    animations = {
        enabled = true,
    },

    decoration = {
        rounding = 10,

        blur = {
            enabled = false,
        },

        shadow = {
            enabled = false,
        },
    },

    debug = {
        disable_logs = false,
    },

    ecosystem = {
        no_update_news = true,
    },

    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },

    opengl = {
        nvidia_anti_flicker = false,
    },

    render = {
        direct_scanout = 2, -- reduce latency when gaming in fullscreen.
    },

    xwayland = {
        force_zero_scaling = true,
    },
})

hl.gesture({ fingers = 3, direction = 'horizontal', action = 'workspace' })
