return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"bash",
				"dockerfile",
				"fish",
				"go",
				"gomod",
				"gosum",
				"http",
				"ini",
				"javascript",
				"lua",
				"markdown",
				"python",
				"ruby",
				"rust",
				"toml",
				"typescript",
				"yaml",
			})
		end,
	},
}
