return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      auto_install = true,
      ensure_installed = {
        "bash",
        "ruby",
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "json",
        "lua",
      },
      highlight = { enable = true },
      indent = { enable = false },
    }
  }
}
