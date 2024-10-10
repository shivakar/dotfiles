return {
  "rmagatti/auto-session",
  config = function()
    local auto = require("auto-session")

    auto.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Desktop", "~/Documents" },
    })

    local keymap = vim.keymap

    keymap.set("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "Save session for auto session" })
    keymap.set("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })

  end,
}
