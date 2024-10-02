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
--             local banner = [[
--
--       ████ ██████           █████      ██
--      ███████████             █████ 
--      █████████ ███████████████████ ███   ███████████
--     █████████  ███    █████████████ █████ ██████████████
--    █████████ ██████████ █████████ █████ █████ ████ █████
--  ███████████ ███    ███ █████████ █████ █████ ████ █████
-- ██████  █████████████████████ ████ █████ █████ ████ ██████
--
--   ]]
            local banner = [[

	     /\__\         /\  \         /\  \         /\__\          ___        /\__\
	    /::|  |       /::\  \       /::\  \       /:/  /         /\  \      /::|  |
	   /:|:|  |      /:/\:\  \     /:/\:\  \     /:/  /          \:\  \    /:|:|  |
	  /:/|:|  |__   /::\~\:\  \   /:/  \:\  \   /:/__/  ___      /::\__\  /:/|:|__|__
	 /:/ |:| /\__\ /:/\:\ \:\__\ /:/__/ \:\__\  |:|  | /\__\  __/:/\/__/ /:/ |::::\__\
	 \/__|:|/:/  / \:\~\:\ \/__/ \:\  \ /:/  /  |:|  |/:/  / /\/:/  /    \/__/~~/:/  /
	     |:/:/  /   \:\ \:\__\    \:\  /:/  /   |:|__/:/  /  \::/__/           /:/  /
	     |::/  /     \:\ \/__/     \:\/:/  /     \::::/__/    \:\__\          /:/  /
	     /:/  /       \:\__\        \::/  /       ~~~~         \/__/         /:/  /
	     \/__/         \/__/         \/__/                                   \/__/

]]
            local msg = greeting()
            local n = math.floor((70 - msg:len()) / 2)
            return banner .. pad(msg, n)
        end,
    }
    require('mini.sessions').setup {}
end)
