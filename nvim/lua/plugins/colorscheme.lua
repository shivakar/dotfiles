return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    vim.o.background = "dark"
    require("gruvbox").setup({
      contrast = "hard",
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = false,
      }, -- disable all italics
      palette_overrides = {
        bright_green = "#b1b501",
      }
    })
    vim.cmd([[colorscheme gruvbox]])
  end,
}
