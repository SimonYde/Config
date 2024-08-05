Load.now(function()
    local pad = function(str, n)
        return string.rep(" ", n) .. str
    end

    local greeting = function()
        local hour = tonumber(vim.fn.strftime("%H"))
        -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
        local part_id = math.floor((hour + 4) / 8) + 1
        local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
        local username = vim.loop.os_get_passwd()["username"] or "USERNAME"

        return ("Good %s, %s"):format(day_part, username)
    end

    require('mini.starter').setup {
        header = function()
            local banner = [[

      ████ ██████           █████      ██
     ███████████             █████ 
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████

  ]]
            local msg = greeting()
            local n = math.floor((70 - msg:len()) / 2)
            return banner .. pad(msg, n)
        end,
    }
    local group = vim.api.nvim_create_augroup("MiniStarterKeymap", { clear = true })
    vim.api.nvim_create_autocmd("User", {
        -- once = true,
        pattern = "MiniStarterOpened",
        group = group,
        callback = function(starter_args)
            local starter_bufid = starter_args.buf
            local was_colemak = _G.COLEMAK
            -- Turn off colemak langmap for the starter buffer, if it was enabled
            if was_colemak then
                Colemak_toggle()
            end
            vim.api.nvim_create_autocmd("BufLeave", {
                group = group,
                callback = function(args)
                    -- If we're leaving the starter buffer, and we had Colemak enabled
                    -- before entering the starter buffer, we toggle it back on
                    if args.buf == starter_bufid and was_colemak then
                        was_colemak = false
                        Colemak_toggle()
                    end
                end,

            })
            vim.api.nvim_create_autocmd("BufEnter", {
                group = group,
                callback = function(args)
                    -- If we're back in the starter buffer we disable langmap again
                    if args.buf == starter_bufid then
                        if _G.COLEMAK then
                            was_colemak = true
                            Colemak_toggle()
                        end
                    end
                end,
            })
        end,
    })
    require('mini.sessions').setup {}
end)
