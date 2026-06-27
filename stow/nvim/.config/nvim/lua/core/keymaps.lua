local map = vim.keymap.set

-- Save file
map({ "n", "i" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Escape insert mode
map("i", "jk", "<Esc>")

-- Terminal escape
map("t", "<Esc><Esc>", "<C-\\><C-n><cmd>q<CR>")

-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Join lines keeping cursor position
map("n", "J", "mzJ`z")

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Centered search navigation
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- System clipboard yank
map("n", "<leader>Y", [["+Y]])

-- Delete to void register
map({ "n", "v" }, "<leader>d", [["_d]])

-- Close window / buffer
map("n", "<leader>w", "<cmd>q<CR>", { desc = "Close window" })
map("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete buffer" })

-- Quickfix navigation (bracket pattern: ]q / [q)
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Prev quickfix" })

-- Search and replace word under cursor
map("n", "<leader>S", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })

-- Window navigation (overridden by tmux-navigator later)
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize splits with arrow keys
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Tabs
map("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
map("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tl", "<cmd>tablast<CR>", { desc = "Last tab" })
map("n", "]<Tab>", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "[<Tab>", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Reload current file (useful when editing config)
map("n", "<leader>rr", "<cmd>source %<CR><cmd>echo 'File reloaded'<CR>", { desc = "Source current file" })

-- Discipline module
require("core.discipline").run({ max_keypress_allowed = 10 })
