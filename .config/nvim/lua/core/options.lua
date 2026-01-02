-- Editor options
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.swapfile = false
vim.wo.number = true

-- Disable LazyVim import order check
vim.g.lazyvim_check_order = false

-- Transparency blend options
vim.opt.pumblend = 0
vim.opt.winblend = 0

-- Using ripgrep
vim.o.grepprg = "rg --vimgrep --smart-case --no-heading"
vim.o.grepformat = "%f:%l:%c:%m"
