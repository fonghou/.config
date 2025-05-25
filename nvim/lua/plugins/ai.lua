return {
  {
    "GeorgesAlkhouri/nvim-aider",
    cmd = "Aider",
    keys = {
      { "<leader>aa", "<cmd>Aider add<cr>", desc = "Aider: Add File" },
      { "<leader>ab", "<cmd>Aider buffer<cr>", desc = "Aider: Send Buffer" },
      { "<leader>ac", "<cmd>Aider command<cr>", desc = "Aider: Send Command" },
      { "<leader>ad", "<cmd>Aider drop<cr>", desc = "Aider: Drop File" },
      { "<leader>ar", "<cmd>Aider add readonly<cr>", desc = "Aider: Read File" },
      { "<leader>as", "<cmd>Aider send<cr>", desc = "Aider: Send", mode = { "n", "v" } },
      { "<leader>at", "<cmd>Aider toggle<cr>", desc = "Aider: Open Terminal " },
    },
    dependencies = {
      "folke/snacks.nvim",
    },
    opts = {
      args = {
        "--model",
        "flash",
        "--no-analytics",
        "--no-auto-commits",
        "--yes-always",
        "--watch-files",
      },
      win = {
        position = "right",
        wo = { winbar = "Aider" },
      },
    },
  },
}
