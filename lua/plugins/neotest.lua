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
				vim.cmd(":TSUpdate ruby")
			end,
		},
		{
			"fredrikaverpil/neotest-golang",
			version = "*", -- Optional, but recommended; track releases
			build = function()
				vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
			end,
		},
		{
			"volodya-lombrozo/neotest-ruby-minitest",
		},
	},
	keys = {
		{ "<leader>tr", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test" },
    { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run current file" },
    -- { "<leader>ta", "<cmd>lua require('neotest').run.run(vim.fn.getcwd())<cr>", desc = "Run all tests" },
    { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>", desc = "Toggle summary" },
    { "<leader>to", "<cmd>lua require('neotest').output.open({ enter = true })<cr>", desc = "Show output" },
    { "<leader>tO", "<cmd>lua require('neotest').output_panel.toggle()<cr>", desc = "Toggle output panel" },
    { "<leader>tS", "<cmd>lua require('neotest').run.stop()<cr>", desc = "Stop test" },
    { "<leader>tw", "<cmd>lua require('neotest').watch.toggle()<cr>", desc = "Toggle watch" },
		-- { "<leader>tc", "<cmd>lua require('neotest').output_panel.clear()<cr>", desc = "Clear output panel" },
    -- { "<leader>tC", "<cmd>lua require('neotest').state.clear()<cr>", desc = "Clear all test results" },
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-golang")({
					runner = "gotestsum",
				}),
				require("neotest-ruby-minitest"),
			},
		})
	end,
}
