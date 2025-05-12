local wezterm = require("wezterm")
local action = wezterm.action

---@class Wezterm
local config = wezterm.config_builder()

config.color_scheme = "stylix"

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	"Symbols Only Nerd Font",
	"Noto Color Emoji",
})

config.max_fps = 144

config.font_size = 11.5
config.command_palette_font_size = 13
config.underline_position = -4
config.adjust_window_size_when_changing_font_size = false
-- config.window_background_opacity = 0.9

config.hide_tab_bar_if_only_one_tab = true
config.enable_kitty_keyboard = true
config.term = "wezterm"

config.unix_domains = {
	{ name = "unix" },
}
-- config.default_gui_startup_args = { "connect", "unix" }

config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = "#1b1b1b",
			fg_color = "#d5c4a1",
		},
		inactive_tab_hover = {
			bg_color = "#d5c4a1",
			fg_color = "#1b1b1b",
		},
		new_tab_hover = {
			bg_color = "#d5c4a1",
			fg_color = "#1b1b1b",
		},
	},
}

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
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "l",
		mods = "LEADER|CTRL",
		action = action.SendKey({ key = "l", mods = "CTRL" }),
	},
}

return config
