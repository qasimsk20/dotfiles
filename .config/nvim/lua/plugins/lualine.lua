return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      section_separators = { left = "", right = "" },
      component_separators = { left = "󱪼", right = "󱪼" },
    },
    sections = {
      lualine_b = {
        { "branch", icon = "" },
      },
      -- lualine_b = { 'branch' },
      lualine_x = { 'diff', 'filetype' },
      lualine_z = {
        { "location" },
      },
    },
  },
}
