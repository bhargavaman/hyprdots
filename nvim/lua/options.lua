vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "markdown", "text" },
	callback = function()
		vim.wo.conceallevel = 0
	end,
})

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.api.nvim_create_autocmd("BufNewFile", {
	pattern = "*.go",
	callback = function()
		vim.cmd("0r ~/.config/nvim/templates/go_main.go")
	end,
})

-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	pattern = "*.js",
-- 	command = "vert split | terminal node %",
-- })

vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local bufname = vim.api.nvim_buf_get_name(diagnostic.bufnr or 0)

			-- Check if file is inside /modules/
			if bufname:match("/modules/") then
				-- Filter specific Terraform LSP warnings
				if diagnostic.message:match("required_providers") or diagnostic.message:match("required_version") then
					return nil
				end
			end

			return diagnostic.message
		end,
	},
})

local function toggleTrueFalse()
	local word = vim.fn.expand("<cword>")
	if word == "true" then
		vim.cmd("normal! ciwfalse")
	elseif word == "false" then
		vim.cmd("normal! ciwtrue")
	end
end

vim.keymap.set("n", "<leader>te", "oif err != nil {<CR><CR>}<Esc>", { desc = "Insert Go error check" })

vim.keymap.set("n", "<leader>tf", toggleTrueFalse, { desc = "Toggle True False" }, { noremap = true, silent = true })

vim.cmd("autocmd FileType * setlocal formatoptions-=cro")

vim.wo.number = true
vim.wo.relativenumber = true

local opt = vim.opt
-- UI & Display
opt.termguicolors = true
opt.cursorline = true
opt.autochdir = false
opt.scroll = 5
opt.signcolumn = "yes"
opt.wrap = true
opt.scrolloff = 8
opt.autoindent = true
opt.sidescrolloff = 8
opt.winborder = "none"

-- Searching
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- Indentation
opt.smartindent = true

-- Performance
opt.updatetime = 250
opt.swapfile = false
opt.undofile = true
opt.timeoutlen = 400

-- Clipboard
opt.clipboard = "unnamedplus"

-- Splits
opt.splitright = true
opt.splitbelow = true
