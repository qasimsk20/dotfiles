return {
	"madskjeldgaard/cppman.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local cppman = require("cppman")
		cppman.setup()

		vim.opt.shell = "sh"

		-- Optional: Keymaps
		-- Open search box
		vim.keymap.set("n", "<leader>cc", function()
			cppman.input()
		end)

		-- Open word under cursor in CPPman
		vim.keymap.set("n", "<leader>cm", function()
			cppman.open_cppman_for(vim.fn.expand("<cword>"))
		end)
	end,
}
