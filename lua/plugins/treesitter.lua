-- NOTE: the "main" (rewritten) nvim-treesitter branch has no `setup({ ensure_installed = ... })`
-- option; parsers must be installed via `.install()` and highlighting must be started per
-- filetype via `vim.treesitter.start()` in a FileType autocmd. See :h nvim-treesitter (main).
local ensure_installed = {
	"bash",
	"css",
	"dockerfile",
	"embedded_template",
	"fish",
	"go",
	"gomod",
	"gosum",
	"html",
	"http",
	"ini",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"python",
	"ruby",
	"rust",
	"toml",
	"tsx",
	"typescript",
	"yaml",
}

local ts_filetypes = {
	"sh",
	"css",
	"dockerfile",
	"eruby",
	"fish",
	"go",
	"gomod",
	"gosum",
	"html",
	"http",
	"ini",
	"javascript",
	"javascriptreact",
	"json",
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
					-- pcall: a missing parser should not throw on FileType
					pcall(vim.treesitter.start)
				end,
			})
		end,
	},
}
