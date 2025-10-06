return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				-- "ruby_lsp",
				"gopls",
			},
		},
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {},
			},
			{
				"neovim/nvim-lspconfig",
				config = function()
					-- local lspconfig = require("lspconfig")
					local function add_ruby_deps_command(client, bufnr)
						vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps", function(opts)
							local params = vim.lsp.util.make_text_document_params()
							local showAll = opts.args == "all"

							client.request("rubyLsp/workspace/dependencies", params, function(error, result)
								if error then
									print("Error showing deps: " .. error)
									return
								end

								local qf_list = {}
								for _, item in ipairs(result) do
									if showAll or item.dependency then
										table.insert(qf_list, {
											text = string.format(
												"%s (%s) - %s",
												item.name,
												item.version,
												item.dependency
											),
											filename = item.path,
										})
									end
								end

								vim.fn.setqflist(qf_list)
								vim.cmd("copen")
							end, bufnr)
						end, {
							nargs = "?",
							complete = function()
								return { "all" }
							end,
						})
					end

					local capabilities = require("cmp_nvim_lsp").default_capabilities()

					vim.lsp.enable("lua_ls")
					vim.lsp.config("lua_ls", {
						capabilities = capabilities,
					})
					vim.lsp.enable("ruby-lsp")
					vim.lsp.config("ruby-lsp", {
						capabilities = capabilities,
						on_attach = function(client, buffer)
							add_ruby_deps_command(client, buffer)
						end,
					})
					vim.lsp.enable("gopls")
					vim.lsp.config("gopls", {
						capabilities = capabilities,
					})
					-- Autocommand to format Go files on save using LSP
					vim.api.nvim_create_autocmd("BufWritePre", {
						pattern = "*.go",
						callback = function()
							local params = vim.lsp.util.make_range_params()
							params.context = { only = { "source.organizeImports" } }
							-- buf_request_sync defaults to a 1000ms timeout. Depending on your
							-- machine and codebase, you may want longer. Add an additional
							-- argument after params if you find that you have to write the file
							-- twice for changes to be saved.
							-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
							local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
							for cid, res in pairs(result or {}) do
								for _, r in pairs(res.result or {}) do
									if r.edit then
										local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
										vim.lsp.util.apply_workspace_edit(r.edit, enc)
									end
								end
							end
							vim.lsp.buf.format({ async = false })
						end,
					})
					vim.lsp.enable("ruff")
					vim.lsp.config("ruff", {
						capabilities = capabilities,
						cmd = { "uvx", "ruff", "server" },
					})
          vim.lsp.enable("rust_analyzer")
					vim.lsp.config("rust_analyzer", {
						settings = {
							["rust-analyzer"] = {
								diagnostics = {
									enable = false,
								},
							},
						},
					})

					vim.diagnostic.config({
						virtual_text = true,
					})

					vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
					vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
					vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
				end,
			},
		},
	},
}
