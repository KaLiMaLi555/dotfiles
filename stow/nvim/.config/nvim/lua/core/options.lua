local opt = vim.opt
local g = vim.g

-- Leader keys (must be set before lazy.nvim)
g.mapleader = " "
g.maplocalleader = ","

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true

-- Search (ignorecase + smartcase only — hlsearch/incsearch are 0.11 defaults)
opt.ignorecase = true
opt.smartcase = true

-- Appearance
opt.signcolumn = "yes"
opt.colorcolumn = "88"
opt.cursorline = true
opt.scrolloff = 15
opt.wrap = false

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Files
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("state") .. "/undodir"
opt.undofile = true

-- Misc
opt.isfname:append("@-@")
opt.updatetime = 250
opt.timeoutlen = 300
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.completeopt = "menu,menuone,noinsert,popup"

-- Disable netrw (using telescope file-browser instead)
g.loaded_netrwPlugin = 1
g.loaded_netrw = 1
