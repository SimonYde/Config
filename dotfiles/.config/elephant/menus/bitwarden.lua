Name = "bitwarden"
NamePretty = "Bitwarden"
Icon = "applications-other"
Cache = false
HideFromProviderlist = false
Description = "get login entries from bitwarden using `rbw`"
SearchName = true

function GetEntries()
	local entries = {}

	local handle = io.popen("rbw list --fields=name,user,type,folder")
	if handle then
		for line in handle:lines() do
			local name, user, type, folder = line:match("([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)")
			if name then
				table.insert(entries, {
					Text = name .. " - " .. user,
					Subtext = type .. " - " .. folder,
					Value = line,
					Actions = {
						copy = "rbw get " .. name .. "| wl-copy",
					},
					-- Preview = line,
					-- PreviewType = "file",
					-- Icon = line
				})
			end
		end
		handle:close()
	end

	return entries
end
