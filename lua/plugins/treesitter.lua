return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			ensure_installed = { "lua", "go", "python", "javascript", "typescript", "ruby" },
		},
		config = function()
			-- require("nvim-treesitter").install({
			-- 	"bash",
			-- 	"dockerfile",
			-- 	"fish",
			-- 	"go",
			-- 	"gomod",
			-- 	"gosum",
			-- 	"http",
			-- 	"ini",
			-- 	"javascript",
			-- 	"lua",
			-- 	"markdown",
			-- 	"python",
			-- 	"ruby",
			-- 	"rust",
			-- 	"toml",
			-- 	"typescript",
			-- 	"yaml",
			-- })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "go" },
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},
}
