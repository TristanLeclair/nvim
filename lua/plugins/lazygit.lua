local M = {
	"kdheepak/lazygit.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}

function M.config()
	Set_keymap("n", "<leader>gg", "<cmd>LazyGit<cr>", { noremap = true, silent = true })
end

return M
