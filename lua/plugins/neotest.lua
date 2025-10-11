return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		{
			"nvim-treesitter/nvim-treesitter", -- Optional, but recommended
			branch = "main", -- NOTE; not the master branch!
			build = function()
				vim.cmd(":TSUpdate go")
			end,
		},
		{
			"fredrikaverpil/neotest-golang",
			version = "*", -- Optional, but recommended; track releases
			build = function()
				vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
			end,
		},
	},
	keys = {
		{ "<leader>tr", "<cmd>Neotest run<cr>" },
		{ "<leader>ti", "<cmd>Neotest output<cr>" },
		{ "<leader>ts", "<cmd>Neotest summary<cr>" },
	},
	config = function()
		local config = {
			runner = "gotestsum", -- Optional, but recommended
		}
		require("neotest").setup({
			adapters = {
				require("neotest-golang")(config),
			},
		})
	end,
}
