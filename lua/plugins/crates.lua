return {
	"saecki/crates.nvim",
	tag = "stable",
	event = { "BufRead Cargo.toml" },
	config = function()
		local crates = require("crates")
		crates.setup({
			-- In-process LSP: completion (via blink.cmp's lsp source), code actions and hover
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
		})

		vim.api.nvim_create_autocmd("BufRead", {
			group = vim.api.nvim_create_augroup("crates-keymaps", { clear = true }),
			pattern = "Cargo.toml",
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, silent = true, desc = "Crates: " .. desc })
				end
				map("<leader>cp", crates.show_popup, "Show Popup")
				map("<leader>cv", crates.show_versions_popup, "Show Versions")
				map("<leader>cf", crates.show_features_popup, "Show Features")
				map("<leader>cd", crates.show_dependencies_popup, "Show Dependencies")
				map("<leader>cu", crates.update_crate, "Update Crate")
				map("<leader>cU", crates.upgrade_crate, "Upgrade Crate")
				map("<leader>ca", crates.update_all_crates, "Update All Crates")
				map("<leader>cA", crates.upgrade_all_crates, "Upgrade All Crates")
				map("<leader>cD", crates.open_documentation, "Open Documentation")
				map("<leader>cR", crates.open_repository, "Open Repository")
			end,
		})
	end,
}
