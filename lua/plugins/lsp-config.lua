return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				-- "ruby_lsp",
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

			    local capabilities = require('cmp_nvim_lsp').default_capabilities()

          vim.lsp.config("lua_ls", {
            capabilities = capabilities,
          })
          -- vim.lsp.enable("ruby-lsp")
          vim.lsp.config("ruby-lsp", {
            capabilities = capabilities,
            on_attach = function(client, buffer)
              add_ruby_deps_command(client, buffer)
            end,
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
