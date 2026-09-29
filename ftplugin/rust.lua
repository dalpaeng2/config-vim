-- Rust-specific keymaps (rustaceanvim)
local bufnr = vim.api.nvim_get_current_buf()

local map = function(keys, cmd, desc, mode)
	vim.keymap.set(mode or "n", keys, function()
		vim.cmd.RustLsp(cmd)
	end, { buffer = bufnr, silent = true, desc = "Rust: " .. desc })
end

-- Override the generic code action with rust-analyzer's grouped actions
map("gra", "codeAction", "Code Action", { "n", "x" })
map("K", { "hover", "actions" }, "Hover Actions")

map("<leader>rr", "runnables", "Runnables")
map("<leader>rt", "testables", "Testables")
map("<leader>rd", "debuggables", "Debuggables")
map("<leader>rl", { "runnables", bang = true }, "Rerun Last Runnable")
map("<leader>rm", "expandMacro", "Expand Macro")
map("<leader>re", "explainError", "Explain Error")
map("<leader>rD", "renderDiagnostic", "Render Diagnostic")
map("<leader>ro", "openDocs", "Open docs.rs")
map("<leader>rc", "openCargo", "Open Cargo.toml")
map("<leader>rp", "parentModule", "Parent Module")
map("<leader>rj", "joinLines", "Join Lines")
map("<leader>rk", { "moveItem", "up" }, "Move Item Up")
map("<leader>rJ", { "moveItem", "down" }, "Move Item Down")
