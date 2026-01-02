return {
	"folke/snacks.nvim",
	dependencies = {
		"echasnovski/mini.icons",
	},
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			win = {
				border = "single",
				padding = { 0, 0 },
			},
			preset = {
				header = [[
                                                                      
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 
        ]],
			},
		},
		indent = { enabled = true },
		input = {
			enabled = true,
			win = {
				border = "single",
				padding = { 0, 0 },
			},
		},
		git = { enabled = true },
		picker = {
			enabled = true,
			layout = "custom",
			layouts = {
				custom = {
					layout = {
						box = "horizontal",
						width = 0.8,
						min_width = 120,
						height = 0.8,
						{
							box = "vertical",
							border = "single",
							title = "{title} {live} {flags}",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
						},
						{
							win = "preview",
							title = "{preview}",
							border = "single",
							width = 0.5,
						},
					},
				},
			},
		},
		notifier = {
			enabled = true,
			win = {
				border = "single",
				padding = 0,
			},
		},
		quickfile = { enabled = true },
		lazygit = {
			enabled = true,
			win = {
				border = "single",
				padding = 0,
			},
		},
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		{
			"<leader>sf",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Log (cwd)",
		},
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<C-p>",
			function()
				Snacks.picker.pick("files")
			end,
			desc = "Find Files",
		},
		{
			"<leader><leader>",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep Files",
		},
		{
			"<C-n>",
			function()
				Snacks.explorer()
			end,
			desc = "Explorer",
		},
	},
}
