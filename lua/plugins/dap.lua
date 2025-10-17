return {
	-- nvim-dap: Debug Adapter Protocol client
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			-- UI for nvim-dap
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			-- Virtual text support
			"theHamsta/nvim-dap-virtual-text",
			-- Mason integration for DAP
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			-- Setup dap-ui
			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
				mappings = {
					expand = { "<CR>", "<2-LeftMouse>" },
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				layouts = {
					{
						elements = {
							{ id = "scopes", size = 0.25 },
							{ id = "breakpoints", size = 0.25 },
							{ id = "stacks", size = 0.25 },
							{ id = "watches", size = 0.25 },
						},
						size = 40,
						position = "left",
					},
					{
						elements = {
							{ id = "repl", size = 0.5 },
							{ id = "console", size = 0.5 },
						},
						size = 10,
						position = "bottom",
					},
				},
			})

			-- Setup virtual text
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
			})

			-- Setup mason-nvim-dap
			require("mason-nvim-dap").setup({
				ensure_installed = { "python", "codelldb", "delve" },
				automatic_installation = true,
				handlers = {},
			})

			-- Automatically open/close dapui
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			-- Set up signs
			vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "⭕", texthl = "", linehl = "", numhl = "" })

			-- Keymaps
			local keymap = vim.keymap.set
			local opts = { noremap = true, silent = true }

			-- Debug session management
			keymap(
				"n",
				"<leader>dc",
				dap.continue,
				vim.tbl_extend("force", opts, { desc = "DAP: Continue/Start" })
			)
			keymap(
				"n",
				"<leader>dn",
				dap.step_over,
				vim.tbl_extend("force", opts, { desc = "DAP: Step Over (Next)" })
			)
			keymap(
				"n",
				"<leader>di",
				dap.step_into,
				vim.tbl_extend("force", opts, { desc = "DAP: Step Into" })
			)
			keymap("n", "<leader>do", dap.step_out, vim.tbl_extend("force", opts, { desc = "DAP: Step Out" }))

			-- Breakpoints
			keymap(
				"n",
				"<leader>db",
				dap.toggle_breakpoint,
				vim.tbl_extend("force", opts, { desc = "DAP: Toggle Breakpoint" })
			)
			keymap("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, vim.tbl_extend("force", opts, { desc = "DAP: Set Conditional Breakpoint" }))
			keymap("n", "<leader>dL", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, vim.tbl_extend("force", opts, { desc = "DAP: Set Log Point" }))
			keymap(
				"n",
				"<leader>dC",
				dap.clear_breakpoints,
				vim.tbl_extend("force", opts, { desc = "DAP: Clear All Breakpoints" })
			)

			-- UI controls
			keymap("n", "<leader>du", dapui.toggle, vim.tbl_extend("force", opts, { desc = "DAP: Toggle UI" }))
			keymap(
				"n",
				"<leader>dr",
				dap.repl.toggle,
				vim.tbl_extend("force", opts, { desc = "DAP: Toggle REPL" })
			)
			keymap("n", "<leader>dl", dap.run_last, vim.tbl_extend("force", opts, { desc = "DAP: Run Last" }))

			-- Evaluate and hover
			keymap("n", "<leader>dh", function()
				require("dap.ui.widgets").hover()
			end, vim.tbl_extend("force", opts, { desc = "DAP: Hover Variables" }))
			keymap("n", "<leader>dp", function()
				require("dap.ui.widgets").preview()
			end, vim.tbl_extend("force", opts, { desc = "DAP: Preview" }))
			keymap("n", "<leader>de", function()
				vim.ui.input({ prompt = "Expression: " }, function(expr)
					if expr then
						require("dapui").eval(expr)
					end
				end)
			end, vim.tbl_extend("force", opts, { desc = "DAP: Evaluate Expression" }))

			-- Terminate
			keymap(
				"n",
				"<leader>dt",
				dap.terminate,
				vim.tbl_extend("force", opts, { desc = "DAP: Terminate Session" })
			)
			keymap(
				"n",
				"<leader>dq",
				dap.close,
				vim.tbl_extend("force", opts, { desc = "DAP: Quit/Close Session" })
			)
		end,
	},
}
