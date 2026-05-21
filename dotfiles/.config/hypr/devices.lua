--    ____             _
--   |  _ \  _____   _(_) ___ ___  ___
--   | | | |/ _ \ \ / / |/ __/ _ \/ __|
--   | |_| |  __/\ V /| | (_|  __/\__ \
--   |____/ \___| \_/ |_|\___\___||___/
--
-- Device specific settings, like enabling acceleration on touchpads.
hl.device({
    name = 'msft0001:00-06cb:ce2d-touchpad',
    accel_profile = 'adaptive',
})

hl.device({
    name = 'pixa3854:00-093a:0274-touchpad',
    accel_profile = 'adaptive',
})

hl.device({
    name = 'kanata',
    kb_layout = 'us,dk',
    kb_variant = 'colemak_dh,',
    kb_options = 'caps:escape,grp:ctrls_toggle',
})

hl.device({
    name = 'at-translated-set-2-keyboard',
    kb_layout = 'us,dk',
    kb_variant = 'colemak_dh,',
    kb_options = 'caps:escape,grp:ctrls_toggle',
})

hl.device({
    name = 'glove80-keyboard',
    kb_layout = 'eu',
})

hl.device({
    name = 'zsa-technology-labs-moonlander-mark-i',
    kb_layout = 'eu',
})

hl.device({
    name = 'zsa-technology-labs-moonlander-mark-i-keyboard',
    kb_layout = 'eu',
})

hl.device({
    name = 'zsa-technology-labs-moonlander-mark-i-consumer-control',
    kb_layout = 'eu',
})

hl.device({
    name = 'zsa-technology-labs-moonlander-mark-i-system-control',
    kb_layout = 'eu',
})
