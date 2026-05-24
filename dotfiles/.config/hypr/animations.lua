hl.curve("bounce", { type = "spring", mass = 1, stiffness = 50, dampening = 10 })
hl.curve("slight_bounce", { type = "spring", mass = 1, stiffness = 35, dampening = 10 })

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

