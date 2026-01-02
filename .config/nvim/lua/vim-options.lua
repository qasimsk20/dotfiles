vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

vim.opt.swapfile = false

-- System clipboard shortcuts (separate from neovim registers)
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d', { desc = "Delete to system clipboard" })

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

-- Disable LazyVim import order check
vim.g.lazyvim_check_order = false

-- Forced Transparency
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    local highlights = {
      "Normal", "NormalFloat", "NormalNC", "SignColumn", "EndOfBuffer",
      -- Telescope
      "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal",
      "TelescopeResultsNormal", "TelescopePreviewNormal",
      "TelescopePromptBorder", "TelescopeResultsBorder", "TelescopePreviewBorder",
      -- Neo-tree
      "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeFloatNormal",
      -- Nvim-tree
      "NvimTreeNormal", "NvimTreeNormalNC",
      -- Other common ones
      "FloatBorder", "Pmenu", "PmenuSel"
    }

    for _, highlight in ipairs(highlights) do
      vim.api.nvim_set_hl(0, highlight, { bg = "none" })
    end
  end,
})

-- Also set the blend options
vim.opt.pumblend = 0
vim.opt.winblend = 0

-- Using ripgrep
vim.o.grepprg = "rg --vimgrep --smart-case --no-heading"
vim.o.grepformat = "%f:%l:%c:%m"

-- Force sharp borders for floating windows (including pickers)
vim.api.nvim_create_autocmd("FileType", {
  pattern = {"SnacksPicker", "snacks_picker"},
  callback = function()
    local border_color = "#45475a"
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = border_color, bg = "NONE" })
    vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = border_color, bg = "NONE" })
    vim.api.nvim_win_set_option(0, "winhl", "Normal:NormalFloat,FloatBorder:FloatBorder")
  end,
})
