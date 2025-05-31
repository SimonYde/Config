vim.schedule(function()
	require("catppuccin").setup({
		flavour = "auto", -- latte, frappe, macchiato, mocha

		background = { -- :h background
			light = "latte",
			dark = "mocha",
		},

		transparent_background = true, -- disables setting the background color.
		show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
		term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)

		no_italic = true, -- Force no italic
		no_bold = false, -- Force no bold
		no_underline = false, -- Force no underline
		styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
			comments = {},
			conditionals = {},
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
			operators = {},
			-- miscs = {}, -- Uncomment to turn off hard-coded styles
		},
		color_overrides = {},
		custom_highlights = {},
		default_integrations = false,
		integrations = {
			blink_cmp = true,
			dap = true,
			dap_ui = true,
			lsp_saga = true,
			lsp_trouble = true,
			which_key = true,

			diffview = true,
			neogit = true,

			treesitter = true,
			treesitter_context = true,
			rainbow_delimiters = true,

			markdown = true,
			render_markdown = true,

			mini = {
				enabled = true,
				indentscope_color = "",
			},

			snacks = {
				enabled = true,
				indent_scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
			},

			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
					ok = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
		},
	})

	-- setup must be called before loading
	vim.cmd.colorscheme("catppuccin")
end)
