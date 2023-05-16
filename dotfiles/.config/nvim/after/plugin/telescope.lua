require('telescope').setup {
  defaults = {
    -- borderchars = { "█", " ", "▀", "█", "█", " ", " ", "▀" },
		file_ignore_patterns = {
			"__pycache__/",
			"target",
      "undodir",
		}
	}
}


