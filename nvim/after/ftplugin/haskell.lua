if vim.g.vscode then
  return
end

local wk = require("which-key")
wk.add({
  { "<localleader>c", desc = "ghci clear" },
  { "<localleader>d", desc = "ghci doc" },
  { "<localleader>h", desc = "hoogle" },
  { "<localleader>i", desc = "ghci info" },
  { "<localleader>k", desc = "ghci kind" },
  { "<localleader>L", desc = "ghci load" },
  { "<localleader>l", desc = "ghci reload" },
  { "<localleader>m", desc = "ghci main" },
  { "<localleader>t", desc = "ghci type" },
})
wk.add({
  mode = "v",
  { "<localleader>i", desc = "ghci instances" },
  { "<localleader>k", desc = "ghci kind!" },
  { "<localleader>t", desc = "ghci type-at" },
})

vim.api.nvim_create_user_command("HlintApply", function()
  local bufname = vim.api.nvim_buf_get_name(0)
  local c = vim.api.nvim_win_get_cursor(0)
  vim.cmd(
    string.format("silent !hlint %s --refactor --refactor-options='--inplace --pos %s,%s' ", bufname, c[1], c[2] + 1)
  )
end, { nargs = 0 })

vim.api.nvim_create_user_command("HlintApplyAll", function()
  local bufname = vim.api.nvim_buf_get_name(0)
  vim.cmd(string.format("silent !hlint %s --refactor --refactor-options='--inplace' ", bufname))
end, { nargs = 0 })
