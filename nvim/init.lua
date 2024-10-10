----------------------------
--- Bootstrap lazy.nvim ---
----------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

----------------
--- options ---
----------------
vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.number = true

-- indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- search
opt.ignorecase = true
opt.smartcase = true

-- display
opt.wrap = true
opt.cursorline = true

-- colors
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true

----------------
--- keymaps ---
----------------
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

local keymap = vim.keymap

keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })
keymap.set("n", "<leader><space>", ":nohl<CR>", { desc = "Clear search highlights" })

-- splits
keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>_", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>=", "<C-w>=", { desc = "Make splits equal size" })

-- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous Tab" })
keymap.set("n", "<leader>tb", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })


---------------
--- plugins ---
---------------
require("lazy").setup(".plugins", {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

