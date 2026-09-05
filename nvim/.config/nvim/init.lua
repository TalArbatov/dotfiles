vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy")
