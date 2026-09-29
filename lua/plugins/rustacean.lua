return {
	"mrcjkb/rustaceanvim",
	version = "^6", -- Recommended
	lazy = false, -- This plugin is already lazy
	init = function()
		vim.g.rustaceanvim = {
			server = {
				default_settings = {
					["rust-analyzer"] = {
						-- Run clippy instead of `cargo check` on save
						check = { command = "clippy" },
					},
				},
			},
		}
	end,
}
