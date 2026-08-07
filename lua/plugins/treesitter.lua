-- NOTE: the "main" (rewritten) nvim-treesitter branch has no `setup({ ensure_installed = ... })`
-- option; parsers must be installed via `.install()` and highlighting must be started per
-- filetype via `vim.treesitter.start()` in a FileType autocmd. See :h nvim-treesitter (main).
local ensure_installed = {
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
	"markdown_inline",
	"python",
	"ruby",
	"rust",
	"toml",
	"typescript",
	"yaml",
}

local ts_filetypes = {
	"sh",
	"dockerfile",
	"fish",
	"go",
	"gomod",
	"gosum",
	"http",
	"ini",
	"javascript",
	"javascriptreact",
	"lua",
	"markdown",
	"python",
	"ruby",
	"rust",
	"toml",
	"typescript",
	"typescriptreact",
	"yaml",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install(ensure_installed)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = ts_filetypes,
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},
}
