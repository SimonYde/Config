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
    stay_focused = true,
    size = { 480, 700 },
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
        class = 'ck3|stellaris|cs2',
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

hl.window_rule({ match = { class = '^nm-connection-editor$' }, float = true })
hl.window_rule({ match = { class = '.*File Upload.*' }, float = true })
hl.window_rule({ match = { class = '.*Connection Details.*' }, float = true })
hl.window_rule({
    match = {
        class = 'paradox-launcher-v.*',
    },
    float = true,
    center = true,
})

hl.window_rule({
    name = 'Float settings window',
    match = {
        class = 'md.obsidian.Obsidian',
        initial_title = 'Settings.*',
    },
    float = true,
    center = true,
})

hl.window_rule({ match = { class = 'md.obsidian.Obsidian' }, workspace = 1 })
hl.window_rule({ match = { class = 'brave-origin' }, workspace = '2 silent' })
hl.window_rule({ match = { class = '^steam$' }, workspace = 5 })
hl.window_rule({ match = { class = 'ferdium|Ferdium|discord|legcord|vesktop|WhatsApp' }, workspace = '9 silent' })

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
local workspace_programs = {
    ['special:music'] = {
        'uwsm-app -- spotify',
        { -- rules
        },
    },
    ['special:scratch4'] = {
        'uwsm-app -- ' .. _G.browser .. ' --profile-directory=Default --app-id=ljkacldhgllhakfdiahgjioaamcogcin',
        { -- rules
        },
    },
}
hl.on('workspace.created', function(ws)
    if not ws.is_empty then return end

    local program = workspace_programs[ws.name]
    if program == nil then return end

    local cmd, rules = table.unpack(program)

    rules.workspace = ws.name .. ' silent'

    hl.exec_cmd(cmd, rules)
end)

-- Larger gaps so special (scratchpad) workspaces stand out from regular ones.
for _, name in ipairs({ 'music', 'scratch1', 'scratch2', 'scratch3', 'scratch4' }) do
    hl.workspace_rule({ workspace = 'special:' .. name, gaps_in = 25, gaps_out = 50 })
end
