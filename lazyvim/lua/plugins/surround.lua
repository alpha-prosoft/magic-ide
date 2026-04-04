return {
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          -- Visual mode: wrap selection
          visual = "S",
          -- Normal mode: surround motion
          normal = "ys",
          -- Normal mode: surround line
          normal_line = "yss",
          -- Normal mode: delete surrounding
          delete = "ds",
          -- Normal mode: change surrounding
          change = "cs",
        },
      })
    end,
  },
}
