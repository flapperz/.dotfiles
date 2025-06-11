local vscode = require("vscode")
-- vim.opt.clipboard = 'unnamedplus'
-- TODO: format function to another files
local function toggle_line_number()
	local lineNumberConfig = vscode.get_config("editor.lineNumbers")
	if lineNumberConfig == "relative" then
		vscode.update_config("editor.lineNumbers", "on", "global")
	elseif lineNumberConfig == "on" then
		vscode.update_config("editor.lineNumbers", "relative", "global")
	end
end

local function toggle_zen_mode()
	vscode.action("workbench.action.toggleZenMode")
	vscode.action("workbench.action.toggleMaximizeEditorGroup")
end

local function prev_problem_in_files()
	vscode.action("editor.action.marker.prevInFiles")
end
local function prev_problem()
	vscode.action("editor.action.marker.prev")
end
local function next_problem_in_files()
	vscode.action("editor.action.marker.nextInFiles")
end
local function next_problem()
	vscode.action("editor.action.marker.next")
end

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
-- Remaps
vim.g.mapleader = " "

-- vim.keymap.set('n', '<leader>pv', [[lua vscode.action 'workbench.action.files.saveFiles']])
--
-- vim.keymap.set('n', '<leader>pv', function()
--   vscode.action 'workbench.action.toggleSidebarVisibility'
-- end, { noremap = true })

-- vim.keymap.set("n","u","<Cmd>call VSCodeNotify('undo')<CR>")
-- vim.keymap.set("n","<C-r>","<Cmd>call VSCodeNotify('redo')<CR>")

-- exit insert mode
-- vim.keymap.set({ "n", "v", "o" }, "<C-h>", "^")
-- vim.keymap.set({ "n", "v", "o" }, "<C-l>", "$")
vim.keymap.set("n", "J", "mzJ`z", { noremap = true })

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d', { noremap = true })
vim.keymap.set(
	{ "n", "v" },
	"<leader>c",
	":let @+=@0",
	{ noremap = true, desc = "Copy last yanked text to system clipboard" }
)

-- vim.keymap.set({ 'n' }, '<leader>sf', function()
--   vscode.action 'workbench.action.quickOpen'
-- end)

-- duplicate of vscode keybinds
-- vim.keymap.set({ "n", "v" }, "<C-w>Q", function()
-- 	vscode.call("workbench.action.closeGroup")
-- end, { noremap = true })
vim.keymap.set("n", "<leader>j", next_problem)
vim.keymap.set("n", "<C-j>", next_problem_in_files)
vim.keymap.set("n", "<leader>k", prev_problem)
vim.keymap.set("n", "<C-k>", prev_problem_in_files)

-- -------
-- harpoon
-- -------
vim.keymap.set("n", "<leader>ha", function()
	vscode.action("vscode-harpoon.addEditor");
end, { desc = "harpoon add" })
vim.keymap.set("n", "<leader>hp", function()
	vscode.action("vscode-harpoon.editorQuickPick")
end, { desc = "harpoon quick pick" })
vim.keymap.set("n", "<leader>he", function()
	vscode.action("vscode-harpoon.editEditors")
end, { desc = "harpoon edit editors" })
vim.keymap.set("n", "<leader>hh", function()
	vscode.action("vscode-harpoon.gotoPreviousHarpoonEditor")
end, { desc = "harpoon goto previous editor" })
for i = 1, 9 do -- You can extend this range if you need more direct access
	vim.keymap.set("n", "<leader>h" .. i, function()
		vscode.action("vscode-harpoon.gotoEditor" .. i)
	end, { desc = "harpoon go to file " .. i })
end

vim.keymap.set("n", "<leader>fd", function()
	vscode.action("editor.action.formatDocument")
end, { noremap = true })

vim.keymap.set("n", "<leader>tl", toggle_line_number, { noremap = true })
vim.keymap.set("n", "<leader>tz", toggle_zen_mode, { noremap = true })
vim.keymap.set("n", "<leader>ow", function()
	vscode.action("workbench.action.switchWindow")
end, { noremap = true })
vim.keymap.set("n", "<leader>or", function()
	vscode.action("workbench.action.openRecent")
end, { noremap = true })
vim.keymap.set("n", "<leader>tmm", function()
	vscode.action("editor.action.toggleMinimap")
end, { noremap = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "HiFlapYank" })
	end,
})

vim.keymap.set("n", "gr", function()
	vscode.action("editor.action.goToReferences")
end, { noremap = true })

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			-- require("mini.move").setup({
			-- 	mappings = {
			-- 		left = "",
			-- 		right = "",
			-- 		down = "<M-j>",
			-- 		up = "<M-k>",

			-- 		-- Move current line in Normal mode
			-- 		line_left = "",
			-- 		line_right = "",
			-- 		line_down = "<M-j>",
			-- 		line_up = "<M-k>",
			-- 	},
			-- })
			require("mini.jump").setup({ silent = true })
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
		end,
	},
	{
		"bkad/CamelCaseMotion",
		init = function()
			vim.g.camelcasemotion_key = ","
		end,
	},
	{
		"monaqa/dial.nvim",
		config = function()
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				-- default augends used when no group name is specified
				default = {
					augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
					augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
					augend.date.alias["%d/%m/%y"], -- date (2022/02/19, etc.)
					augend.constant.alias.bool,
					augend.constant.new({ elements = { "True", "False" }, word = true, cyclic = true }),
					augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
					augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
				},
			})
			vim.keymap.set("n", "<c-a>", function()
				require("dial.map").manipulate("increment", "normal")
			end)
			vim.keymap.set("n", "<c-x>", function()
				require("dial.map").manipulate("decrement", "normal")
			end)
			-- ? i don't know what g do
			-- vim.keymap.set("n", "g<c-a>", function()
			-- 	require("dial.map").manipulate("increment", "gnormal")
			-- end)
			-- vim.keymap.set("n", "g<c-x>", function()
			-- 	require("dial.map").manipulate("decrement", "gnormal")
			-- end)
			vim.keymap.set("v", "<c-a>", function()
				require("dial.map").manipulate("increment", "visual")
			end)
			vim.keymap.set("v", "<c-x>", function()
				require("dial.map").manipulate("decrement", "visual")
			end)
			-- vim.keymap.set("v", "g<c-a>", function()
			-- 	require("dial.map").manipulate("increment", "gvisual")
			-- end)
			-- vim.keymap.set("v", "g<c-x>", function()
			-- 	require("dial.map").manipulate("decrement", "gvisual")
			-- end)
		end,
	},
})
