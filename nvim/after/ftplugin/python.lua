if vim.g.vscode then
  return
end

local vo = vim.opt_local
vo.tabstop = 4
vo.shiftwidth = 4
vo.softtabstop = 4

local wk = require("which-key")
wk.add({
  { "<localleader>c", group = "connect" },
  { "<localleader>e", group = "eval" },
  { "<localleader>l", group = "log" },
})

local function options(desc)
  return { buffer = true, noremap = true, silent = true, desc = desc }
end

local map = vim.keymap.set
map("n", ",C", ":Repl %clear<CR>", options("ipython clear"))
map("n", ",i", ":Repl %pinfo <C-r>=expand('<cexpr>')<CR><CR>", options("ipython info"))
map("n", ",s", ":Repl %psource <C-r>=expand('<cexpr>')<CR><CR>", options("ipython source"))
map("n", ",r", ":Repl %run -e -i <C-r>=expand('%:p')<CR><CR>", options("ipython run"))
map("n", ",t", ":Repl !pytest -v --doctest-modules <C-r>=expand('%:p')<CR><CR>", options("pytest file"))
map(
  "n",
  ",d",
  ":Repl !pytest --trace --pdb --pdbcls=IPython.terminal.debugger:TerminalPdb <C-r>=expand('%:p')<CR>::<C-r>=expand('<cword>')<CR><CR>",
  options("pytest debug")
)
