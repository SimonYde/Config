hl.monitor({
    output = 'eDP-1',
    mode = '2880x1920@120',
    position = '0x0',
    scale = 1.5,
})

hl.monitor({
    output = 'desc:AOC Q27G2G4 0x00000F64',
    mode = '2560x1440@144',
    position = "auto-right",
    scale = 1,
})

hl.workspace_rule({ workspace = "1", monitor = "desc:AOC Q27G2G4 0x00000F64" })
hl.workspace_rule({ workspace = "2", monitor = "desc:AOC Q27G2G4 0x00000F64" })
hl.workspace_rule({ workspace = "3", monitor = "desc:AOC Q27G2G4 0x00000F64" })
hl.workspace_rule({ workspace = "4", monitor = "desc:AOC Q27G2G4 0x00000F64" })
hl.workspace_rule({ workspace = "5", monitor = "desc:AOC Q27G2G4 0x00000F64" })
hl.workspace_rule({ workspace = "6", monitor = "desc:AOC Q27G2G4 0x00000F64" })

hl.workspace_rule({ workspace = "7", monitor = "desc:AOC Q27G2G4 0x00000F64" })
hl.workspace_rule({ workspace = "8", monitor = "desc:AOC Q27G2G4 0x00000F64" })
hl.workspace_rule({ workspace = "9", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "10", monitor = "eDP-1" })
