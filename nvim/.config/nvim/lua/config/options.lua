local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs / indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Faster UI updates
opt.updatetime = 250

-- Better completion experience
opt.completeopt = { "menu", "menuone", "noselect" }

-- Mouse is occasionally useful even in Neovim
opt.mouse = "a"

-- System clipboard
opt.clipboard = "unnamedplus"
