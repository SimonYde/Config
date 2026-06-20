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
        middle_click_paste = false,
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
