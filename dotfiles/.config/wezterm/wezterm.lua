local wezterm = require("wezterm")
local action = wezterm.action

---@class Wezterm
local config = wezterm.config_builder()

local ok, colorscheme = pcall(require, "stylix")
if ok then
	for key, value in pairs(colorscheme) do
		config[key] = value
	end
end

config.max_fps = 120

config.underline_position = "-0.2cell"
config.use_fancy_tab_bar = true
config.adjust_window_size_when_changing_font_size = false

config.window_decorations = "NONE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.hide_tab_bar_if_only_one_tab = true
config.enable_kitty_keyboard = true
config.term = "wezterm"

config.ssh_domains = {
	{
		name = "icarus",
		remote_address = "icarus",
		username = "syde",
	},
	{
		name = "talos",
		remote_address = "talos",
		username = "syde",
	},
	{
		name = "perdix",
		remote_address = "perdix",
		username = "syde",
	},
	{
		name = "hestia",
		remote_address = "hestia",
		username = "syde",
	},
}

config.unix_domains = {
	{ name = "unix" },
}

local _ok, sessionizer = pcall(require, 'sessionizer')

config.leader = { key = "l", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
	{
		key = "s",
		mods = "LEADER",
		action = action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "v",
		mods = "LEADER",
		action = action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "t",
		mods = "LEADER",
		action = action.ActivateTabRelative(1),
	},
	{
		key = "w",
		mods = "LEADER",
		action = action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action_callback(sessionizer.open),
	},
	{
		key = "d",
		mods = "LEADER",
		action = action.ShowLauncherArgs({ flags = "FUZZY|DOMAINS" }),
	},
	{
		key = "l",
		mods = "LEADER",
		action = action.ShowLauncher,
	},
	{
		key = "t",
		mods = "LEADER|SHIFT",
		action = action.ActivateTabRelative(-1),
	},
	-- Send "CTRL-l" to the terminal when pressing CTRL-l, CTRL-l
	{
		key = "l",
		mods = "LEADER|CTRL",
		action = action.SendKey({ key = "l", mods = "CTRL" }),
	},
}

wezterm.on("format-tab-title", function(tab, tabs)
	local pane = tab.active_pane
	if pane.domain_name then
		return ("(%s) %s"):format(pane.domain_name, pane.title)
	end
	return nil
end)



return config
