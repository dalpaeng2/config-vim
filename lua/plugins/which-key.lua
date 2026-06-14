return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
	config = function()
		local wk = require("which-key")
		wk.setup({
			plugins = {
				spelling = { enabled = true },
			},
			win = {
				border = "rounded",
			},
			layout = {
				align = "center",
			},
		})
		wk.add({
			{ "<leader>s", group = "Search" },
			{ "<leader>h", group = "Git Hunk" },
			{ "<leader>g", group = "Git" },
			{ "<leader>d", group = "Debug" },
			{ "<leader>t", group = "Test/Toggle" },
			{ "<leader>b", group = "Buffer" },
			{ "<leader>l", group = "LazyGit" },
		})
	end,
}
