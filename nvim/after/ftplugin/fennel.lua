if vim.g.vscode then
  return
end

require("lspconfig").fennel_ls.setup {}

local wk = require("which-key")
wk.register({
  c = { "connect" },
  e = { "eval" },
  l = { "log" },
}, { prefix = "<localleader>", mode = "n", silent = true })

-- <cword>
vim.opt.iskeyword:append(".,:")

local opts = { noremap = true, silent = true }
vim.keymap.set("i", "<C-j>", "<Left><C-o>:ConjureEval ,complete <C-r><C-w><CR><Right>", opts)

-- disable autopairs
vim.cmd "inoremap <buffer> (  ("
vim.cmd "inoremap <buffer> '  '"
vim.cmd "inoremap <buffer> `  `"

local command = vim.api.nvim_create_user_command
command("FnlApropos", "ConjureEval ,apropos <args>", { nargs = 1 })
command("FnlComplete", "ConjureEval ,complete <args>", { nargs = 1 })
command("FnlDoc", "ConjureEval ,doc <args>", { nargs = 1 })
command("FnlFind", "ConjureEval ,find <args>", { nargs = 1 })
command("FnlReload", "ConjureEval ,reload <args>", { nargs = 1 })
